-- ============================================================================
-- MIT 8103: Advanced Database Systems - Portfolio 5
-- Script 1: Horizontal Sharding / Partitioning Simulation by Branch
-- DBMS: MySQL 8.0+ (InnoDB)
-- ============================================================================

USE exlibron_library;

DROP TABLE IF EXISTS loans_branch_shards;

-- Create a horizontally partitioned table simulating regional branch shards:
-- Shard 1 (p_abuja): branch_id = 1
-- Shard 2 (p_lagos): branch_id = 2
-- Shard 3 (p_portharcourt): branch_id = 3
CREATE TABLE loans_branch_shards (
    loan_id INT NOT NULL,
    branch_id INT NOT NULL,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME NOT NULL,
    due_date DATE NOT NULL,
    return_date DATETIME NULL,
    PRIMARY KEY (loan_id, branch_id)
) ENGINE=InnoDB
PARTITION BY LIST (branch_id) (
    PARTITION p_abuja VALUES IN (1),
    PARTITION p_lagos VALUES IN (2),
    PARTITION p_portharcourt VALUES IN (3)
);

-- Populate the partitioned table from existing loans joined with book_copies
INSERT INTO loans_branch_shards (loan_id, branch_id, copy_id, member_id, checkout_date, due_date, return_date)
SELECT 
    l.loan_id,
    bc.branch_id,
    l.copy_id,
    l.member_id,
    l.checkout_date,
    l.due_date,
    l.return_date
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id;

-- Refresh table statistics
ANALYZE TABLE loans_branch_shards;

-- 1. Verify how rows are distributed across the 3 regional branch partitions
SELECT 
    PARTITION_NAME,
    PARTITION_DESCRIPTION AS branch_id_key,
    TABLE_ROWS AS estimated_rows
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'exlibron_library'
  AND TABLE_NAME = 'loans_branch_shards';

-- 2. Demonstrate Partition Pruning (Routing query ONLY to the Lagos shard)
EXPLAIN
SELECT COUNT(*) AS lagos_active_loans
FROM loans_branch_shards
WHERE branch_id = 2
  AND return_date IS NULL;
