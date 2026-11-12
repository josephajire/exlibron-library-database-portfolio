-- ============================================================================
-- MIT 8103: Advanced Database Systems - Portfolio 1
-- Organisation: Exlibron Library 
-- DBMS: MySQL 8.0+ (InnoDB)
-- ============================================================================

DROP DATABASE IF EXISTS exlibron_library;
CREATE DATABASE exlibron_library
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE exlibron_library;

-- 1. Library Branches
CREATE TABLE branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- 2. Library Members (Atomic first_name and last_name for 1NF compliance)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    membership_tier ENUM('Student', 'Researcher', 'General') NOT NULL DEFAULT 'General',
    account_status ENUM('Active', 'Suspended', 'Expired') NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB;

-- 3. Books (Bibliographic Catalogue)
CREATE TABLE books (
    isbn VARCHAR(13) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_name VARCHAR(120) NOT NULL,
    publication_year YEAR NOT NULL,
    genre VARCHAR(60) NOT NULL,
    CONSTRAINT chk_isbn_length CHECK (CHAR_LENGTH(isbn) IN (10, 13))
) ENGINE=InnoDB;

-- 4. Book Copies (Physical Inventory per Branch)
CREATE TABLE book_copies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(13) NOT NULL,
    branch_id INT NOT NULL,
    barcode VARCHAR(30) NOT NULL UNIQUE,
    copy_status ENUM('Available', 'Loaned', 'Reserved') NOT NULL DEFAULT 'Available',
    CONSTRAINT fk_copy_book FOREIGN KEY (isbn)
        REFERENCES books(isbn)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_copy_branch FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. Loans (Circulation Records)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    return_date DATETIME NULL,
    CONSTRAINT fk_loan_copy FOREIGN KEY (copy_id)
        REFERENCES book_copies(copy_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_loan_member FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_loan_dates CHECK (return_date IS NULL OR return_date >= checkout_date)
) ENGINE=InnoDB;

-- 6. Fines (1-to-0..1 relationship with overdue Loans)
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL UNIQUE,
    amount_ngn DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Unpaid', 'Paid', 'Waived') NOT NULL DEFAULT 'Unpaid',
    CONSTRAINT fk_fine_loan FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_fine_amount CHECK (amount_ngn > 0)
) ENGINE=InnoDB;
