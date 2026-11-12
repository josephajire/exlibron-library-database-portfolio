# Portfolio 1: Database Design and Modelling — Exlibron Library

## 1. Case Study Overview
**Exlibron Library** is a multi-branch hybrid academic and public library network operating across major Nigerian cities (Abuja, Lagos, and Port Harcourt). The relational database system manages physical book collections, branch locations, registered library members, book check-out/return circulation logs, and overdue fine records.

This portfolio component establishes the foundational relational schema using **MySQL 8.0+ (InnoDB)**, ensuring data integrity through strict constraints and **Third Normal Form (3NF)** normalisation.

---

## 2. Entity-Relationship (ER) Diagram
The Entity-Relationship diagram below illustrates the six core entities (`BRANCHES`, `MEMBERS`, `BOOKS`, `BOOK_COPIES`, `LOANS`, and `FINES`), their attributes, primary/foreign keys, and cardinality relationships.

![Exlibron Library ER Diagram](./er_diagram.png)

### Key Relationships
* **BRANCHES to BOOK_COPIES (1:N):** Each library branch houses zero or more physical book copies, while every physical copy belongs to exactly one branch.
* **BOOKS to BOOK_COPIES (1:N):** One bibliographic book title (identified by ISBN) can have multiple physical copies distributed across branches.
* **MEMBERS to LOANS (1:N):** A registered member can borrow many books over time, while each loan record belongs to one member.
* **BOOK_COPIES to LOANS (1:N):** A specific physical copy can be loaned out multiple times sequentially, while each loan transaction references one physical copy.
* **LOANS to FINES (1:0..1):** An overdue loan incurs at most one fine record, and every fine corresponds to a single loan.

---

## 3. Relational Schema Specification

The logical design maps directly into six relational tables:

1. **BRANCHES** (`branch_id` [PK], `branch_name` [UNIQUE], `city`, `address`)
2. **MEMBERS** (`member_id` [PK], `first_name`, `last_name`, `email` [UNIQUE], `membership_tier`, `account_status`)
3. **BOOKS** (`isbn` [PK], `title`, `author_name`, `publication_year`, `genre`)
4. **BOOK_COPIES** (`copy_id` [PK], `isbn` [FK], `branch_id` [FK], `barcode` [UNIQUE], `copy_status`)
5. **LOANS** (`loan_id` [PK], `copy_id` [FK], `member_id` [FK], `checkout_date`, `due_date`, `return_date`)
6. **FINES** (`fine_id` [PK], `loan_id` [PK/FK, UNIQUE], `amount_ngn`, `payment_status`)

---

## 4. Keys and Integrity Constraints

To enforce business rules at the database engine level, the following keys and constraints are implemented:

| Constraint Type | Table & Column(s) | Purpose / Business Rule Enforced |
| :--- | :--- | :--- |
| **Primary Keys (PK)** | `branch_id`, `member_id`, `isbn`, `copy_id`, `loan_id`, `fine_id` | Uniquely identifies every tuple in each relation. |
| **Foreign Keys (FK)** | `book_copies.isbn` $\rightarrow$ `books.isbn`<br>`book_copies.branch_id` $\rightarrow$ `branches.branch_id`<br>`loans.copy_id` $\rightarrow$ `book_copies.copy_id`<br>`loans.member_id` $\rightarrow$ `members.member_id`<br>`fines.loan_id` $\rightarrow$ `loans.loan_id` | Enforces referential integrity using `ON UPDATE CASCADE` and `ON DELETE RESTRICT` so active branches, books, or members with loan histories cannot be accidentally deleted. |
| **Unique Constraints** | `branches.branch_name`, `members.email`, `book_copies.barcode`, `fines.loan_id` | Prevents duplicate branch names, duplicate member accounts, duplicate physical barcodes, and double-fining on a single loan. |
| **Check Constraints** | `chk_isbn_length` (`CHAR_LENGTH(isbn) IN (10, 13)`)<br>`chk_loan_dates` (`return_date IS NULL OR return_date >= checkout_date`)<br>`chk_fine_amount` (`amount_ngn > 0`) | Validates standard ISBN-10/ISBN-13 lengths, prevents books from being returned before their checkout timestamp, and blocks zero/negative fine amounts. |
| **Domain / ENUM Constraints** | `membership_tier`, `account_status`, `copy_status`, `payment_status` | Restricts categorical columns to valid predefined application states. |

---

## 5. Normalisation Process (1NF $\rightarrow$ 2NF $\rightarrow$ 3NF)

The schema was systematically normalised to eliminate data redundancy and prevent insertion, update, and deletion anomalies:

* **First Normal Form (1NF):**
  * Every attribute contains atomic, indivisible values with no repeating groups.
  * *Design Choice:* Member names are split into atomic **`first_name`** and **`last_name`** attributes rather than a composite `full_name` string, enabling clean sorting and indexing by surname. Furthermore, physical copies are separated from bibliographic titles (`BOOKS` vs. `BOOK_COPIES`) so each copy has its own atomic barcode and status.
* **Second Normal Form (2NF):**
  * The schema satisfies 1NF, and every non-key attribute is fully functionally dependent on the entire primary key.
  * *Design Choice:* Every table uses a single-attribute primary key (`branch_id`, `member_id`, `isbn`, `copy_id`, `loan_id`, `fine_id`), which eliminates any possibility of partial dependencies.
* **Third Normal Form (3NF):**
  * The schema satisfies 2NF, and all transitive dependencies (non-key attributes depending on other non-key attributes) are removed.
  * *Design Choice:* Branch attributes (`branch_name`, `city`, `address`) are isolated in `BRANCHES` rather than repeated inside `BOOK_COPIES`. Similarly, bibliographic attributes (`title`, `author_name`, `genre`) stay strictly in `BOOKS` rather than inside `BOOK_COPIES`, and member attributes (`first_name`, `last_name`, `email`) stay in `MEMBERS` rather than inside `LOANS`.

---

## 6. Files and Practical Verification

* **`er_diagram.png`**: Visual Entity-Relationship diagram illustrating entities, keys, and cardinalities.
* **`01_create_schema.sql`**: MySQL DDL script creating the `exlibron_library` database, tables, keys, and `CHECK` constraints.
* **`02_seed_data.sql`**: DML script populating sample Nigerian branch locations, members, books, physical copies, loans, and fines.
* **`schema_verification.png`**: Screenshot showing successful table creation (`SHOW TABLES;`) and sample relational query execution in MySQL.

### How to Run Locally
```bash
mysql -u root -p < 01_create_schema.sql
mysql -u root -p < 02_seed_data.sql
```

---

## 7. Academic Integrity & AI Use Declaration
* **AI Tool Used:** Google Gemini
* **Purpose:** Used as a learning and structuring aid to refine the 3NF schema design, review MySQL `CHECK` constraint syntax, and format technical documentation.
* **Verification:** All SQL DDL and DML scripts were executed, tested, and verified locally on MySQL 8.0, and the ER diagram was independently generated and reviewed against the relational schema.

