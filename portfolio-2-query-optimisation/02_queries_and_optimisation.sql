-- ============================================================================
-- MIT 8103: Advanced Database Systems - Portfolio 2
-- Script 2: Complex Queries, Execution Plans, and Index Optimisation
-- ============================================================================

USE exlibron_library;

-- ----------------------------------------------------------------------------
-- QUERY 1: Overdue Active Loans Report by Branch and Member Tier
-- Business Use Case: Librarians retrieve all unreturned overdue books at a
-- specific branch to send reminder notices.
-- ----------------------------------------------------------------------------

-- [PART A1] Baseline Execution Plan (BEFORE Indexing)
EXPLAIN ANALYZE
SELECT 
    br.branch_name,
    m.first_name,
    m.last_name,
    m.email,
    b.title,
    l.due_date,
    DATEDIFF('2026-11-12', l.due_date) AS days_overdue
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN branches br ON bc.branch_id = br.branch_id
JOIN books b ON bc.isbn = b.isbn
JOIN members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL
  AND l.due_date < '2026-11-12'
  AND br.city = 'Abuja'
ORDER BY l.due_date ASC;

-- ----------------------------------------------------------------------------
-- QUERY 2: Available Book Copies Search by Genre & Branch
-- Business Use Case: Members search for available "Database Systems" books
-- in Lagos before visiting the library.
-- ----------------------------------------------------------------------------

-- [PART A2] Baseline Execution Plan (BEFORE Indexing)
EXPLAIN ANALYZE
SELECT 
    br.branch_name,
    b.isbn,
    b.title,
    b.author_name,
    COUNT(bc.copy_id) AS available_copies
FROM book_copies bc
JOIN books b ON bc.isbn = b.isbn
JOIN branches br ON bc.branch_id = br.branch_id
WHERE b.genre = 'Database Systems'
  AND bc.copy_status = 'Available'
  AND br.city = 'Lagos'
GROUP BY br.branch_name, b.isbn, b.title, b.author_name;

-- ============================================================================
-- [PART B] APPLY INDEXING OPTIMISATIONS
-- ============================================================================

-- 1. Composite covering/filtering index on loans for overdue active loan lookups
CREATE INDEX idx_loans_return_due ON loans (return_date, due_date);

-- 2. Composite index on book_copies for branch + availability status filtering
CREATE INDEX idx_copies_branch_status_isbn ON book_copies (branch_id, copy_status, isbn);

-- 3. Index on branches.city for fast city-level filtering
CREATE INDEX idx_branches_city ON branches (city);

-- 4. Index on books.genre for catalogue category searches
CREATE INDEX idx_books_genre ON books (genre);

-- Refresh table statistics so the MySQL Query Optimizer uses the new indexes
ANALYZE TABLE branches, books, book_copies, members, loans;

-- ============================================================================
-- [PART C] OPTIMISED EXECUTION PLANS (AFTER Indexing)
-- ============================================================================

-- [PART C1] Re-run Query 1 Execution Plan (AFTER Indexing)
EXPLAIN ANALYZE
SELECT 
    br.branch_name,
    m.first_name,
    m.last_name,
    m.email,
    b.title,
    l.due_date,
    DATEDIFF('2026-11-12', l.due_date) AS days_overdue
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN branches br ON bc.branch_id = br.branch_id
JOIN books b ON bc.isbn = b.isbn
JOIN members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL
  AND l.due_date < '2026-11-12'
  AND br.city = 'Abuja'
ORDER BY l.due_date ASC;

-- [PART C2] Re-run Query 2 Execution Plan (AFTER Indexing)
EXPLAIN ANALYZE
SELECT 
    br.branch_name,
    b.isbn,
    b.title,
    b.author_name,
    COUNT(bc.copy_id) AS available_copies
FROM book_copies bc
JOIN books b ON bc.isbn = b.isbn
JOIN branches br ON bc.branch_id = br.branch_id
WHERE b.genre = 'Database Systems'
  AND bc.copy_status = 'Available'
  AND br.city = 'Lagos'
GROUP BY br.branch_name, b.isbn, b.title, b.author_name;
