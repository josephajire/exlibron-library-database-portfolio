-- ============================================================================
-- MIT 8103: Advanced Database Systems - Portfolio 3
-- Script 1: ACID Transactions (COMMIT and ROLLBACK Demonstrations)
-- DBMS: MySQL 8.0+ (InnoDB)
-- ============================================================================

USE exlibron_library;

-- ----------------------------------------------------------------------------
-- SCENARIO A: ATOMIC BOOK RETURN & OVERDUE FINE ASSESSMENT (COMMIT)
-- Business Rule: Returning an overdue book must update loans.return_date,
-- reset book_copies.copy_status to 'Available', and insert a record in fines
-- atomically.
-- ----------------------------------------------------------------------------

-- 1. Inspect initial state of Loan 1 and Copy 1 before transaction
SELECT l.loan_id, l.copy_id, l.due_date, l.return_date, bc.copy_status
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
WHERE l.loan_id = 1;

START TRANSACTION;

-- Step 1: Record the book return timestamp
UPDATE loans
SET return_date = '2026-11-14 14:30:00'
WHERE loan_id = 1 AND return_date IS NULL;

-- Step 2: Mark the physical copy as Available again
UPDATE book_copies
SET copy_status = 'Available'
WHERE copy_id = 1;

-- Step 3: Assess overdue fine (30 days overdue @ NGN 100/day = NGN 3,000.00)
INSERT INTO fines (loan_id, amount_ngn, payment_status)
VALUES (1, 3000.00, 'Unpaid');

-- Commit all three changes permanently
COMMIT;

-- 2. Verify committed state across all three tables
SELECT l.loan_id, l.return_date, bc.copy_status, f.fine_id, f.amount_ngn, f.payment_status
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN fines f ON l.loan_id = f.loan_id
WHERE l.loan_id = 1;


-- ----------------------------------------------------------------------------
-- SCENARIO B: FAILED CHECKOUT TO A SUSPENDED MEMBER (ROLLBACK)
-- Business Rule: If a copy is marked 'Loaned' during checkout, but the
-- subsequent loan insert fails or violates policy (e.g., Suspended member or
-- invalid CHECK constraint), ROLLBACK restores the copy to 'Available'.
-- ----------------------------------------------------------------------------

-- Ensure Copy 2 ('EXL-ABJ-0002') is currently Available
UPDATE book_copies SET copy_status = 'Available' WHERE copy_id = 2;
SELECT copy_id, barcode, copy_status FROM book_copies WHERE copy_id = 2;

START TRANSACTION;

-- Step 1: Optimistically mark Copy 2 as 'Loaned'
UPDATE book_copies
SET copy_status = 'Loaned'
WHERE copy_id = 2;

-- Step 2: Attempt to insert a loan with an invalid return_date earlier than checkout_date
-- (Simulating an application/constraint error mid-transaction)
-- Note: Run the INSERT below; MySQL will throw Error 3819 (chk_loan_dates violated)
INSERT INTO loans (copy_id, member_id, checkout_date, due_date, return_date)
VALUES (2, 1, '2026-11-14 15:00:00', '2026-11-28', '2026-11-01 10:00:00');

-- Step 3: Because Step 2 failed, roll back the transaction so Copy 2 is NOT stuck as 'Loaned'
ROLLBACK;

-- Verify Copy 2 was cleanly reverted to 'Available'
SELECT copy_id, barcode, copy_status FROM book_copies WHERE copy_id = 2;
