-- ============================================================================
-- MIT 8103: Advanced Database Systems - Portfolio 2
-- Script 1: Simple Bulk Data Generator using Recursive CTEs (MySQL 8.0+)
-- ============================================================================

USE exlibron_library;

-- Allow recursive CTEs up to 5,000 iterations
SET SESSION cte_max_recursion_depth = 5000;

-- 1. Generate 1,000 synthetic library members
INSERT INTO members (first_name, last_name, email, membership_tier, account_status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1000
)
SELECT 
    CONCAT('MemberFirst', n),
    CONCAT('Surname', (n % 200)),
    CONCAT('member', n, '@exlibron-bench.ng'),
    ELT(1 + (n % 3), 'Student', 'Researcher', 'General'),
    IF(n % 10 = 0, 'Suspended', 'Active')
FROM seq;

-- 2. Generate 2,000 physical book copies across the 3 branches
INSERT INTO book_copies (isbn, branch_id, barcode, copy_status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 2000
)
SELECT 
    ELT(1 + (n % 3), '9780134190440', '9781449373320', '9780385474542'),
    1 + (n % 3),
    CONCAT('EXL-BENCH-', LPAD(n, 5, '0')),
    ELT(1 + (n % 3), 'Available', 'Loaned', 'Reserved')
FROM seq;

-- 3. Generate 5,000 historical and active loan records
INSERT INTO loans (copy_id, member_id, checkout_date, due_date, return_date)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 5000
)
SELECT 
    1 + (n % 2000),
    1 + (n % 1000),
    DATE_SUB('2026-11-10 10:00:00', INTERVAL (n % 365) DAY),
    DATE_SUB('2026-11-24', INTERVAL (n % 365) DAY),
    IF(n % 4 = 0, NULL, DATE_SUB('2026-11-20 14:00:00', INTERVAL (n % 365) DAY))
FROM seq;

-- Verify generated row counts
SELECT 
    (SELECT COUNT(*) FROM members) AS total_members,
    (SELECT COUNT(*) FROM book_copies) AS total_copies,
    (SELECT COUNT(*) FROM loans) AS total_loans;
