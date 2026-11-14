-- ============================================================================
-- MIT 8103: Advanced Database Systems - Portfolio 3
-- Script 2: Concurrency Control & Pessimistic Locking (SELECT ... FOR UPDATE)
-- Instructions: Open TWO separate connection tabs in MySQL Workbench. 
----- Tab 1 should be in the first connection while Tab 2 should be in the second connection.
----- NB: Tab 1 and Tab 2 should not be in the same MySQL connection. 
-- ============================================================================

USE exlibron_library;

-- [SETUP - Run in Tab 1] Reset Copy 2 to 'Available' before testing
UPDATE book_copies SET copy_status = 'Available' WHERE copy_id = 2;
SELECT copy_id, barcode, copy_status FROM book_copies WHERE copy_id = 2;

-- ============================================================================
-- STEP 1 [Run in TAB 1 - Librarian A]
-- Starts a transaction at REPEATABLE READ isolation and acquires an Exclusive
-- Row Lock (X-Lock) on Copy 2 using SELECT ... FOR UPDATE.
-- ============================================================================
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

SELECT copy_id, barcode, copy_status
FROM book_copies
WHERE copy_id = 2
FOR UPDATE;
-- Tab 1 now holds an exclusive lock on copy_id = 2! Do NOT commit yet.


-- ============================================================================
-- STEP 2 [Switch to TAB 2 in the second Connection - Librarian B and run while Tab 1 is still open]
-- Librarian B also tries to lock and borrow Copy 2 for Member 2 at the exact
-- same moment.
-- ============================================================================
USE exlibron_library;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

-- This statement will BLOCK (spin/wait) because Tab 1 holds the X-Lock!
SELECT copy_id, barcode, copy_status
FROM book_copies
WHERE copy_id = 2
FOR UPDATE;


-- ============================================================================
-- STEP 3 [Switch back to TAB 1 - Librarian A]
-- Complete Member 1's checkout and COMMIT to release the lock.
-- ============================================================================
UPDATE book_copies SET copy_status = 'Loaned' WHERE copy_id = 2;

INSERT INTO loans (copy_id, member_id, checkout_date, due_date)
VALUES (2, 1, NOW(), DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY));

COMMIT;
-- As soon as Tab 1 commits, Tab 2 immediately unblocks!


-- ============================================================================
-- STEP 4 [Switch to TAB 2 - Librarian B]
-- Inspect the result that just unblocked in Tab 2:
-- Copy 2 now shows copy_status = 'Loaned' (preventing a lost update / double booking)!
-- Librarian B safely aborts the checkout with ROLLBACK.
-- ============================================================================
ROLLBACK;

-- Final Verification: Only ONE loan was created for Copy 2
SELECT * FROM loans WHERE copy_id = 2 ORDER BY loan_id DESC LIMIT 2;
