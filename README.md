# exlibron-library-database-portfolio
### This repository is for a database portfolio project modeling a Library Management System.

* **Student Name:** Joseph Kehinde Ajireloja
* **Student ID:** 301924175
* **Programme:** Master of Information Technology (MIT)
* **Course:** MIT 8103: Advanced Database Systems
* **Case Study Organisation:** Exlibron Library

---

## 1. Case Study Overview: Exlibron Library

### Nature of the Organisation
**Exlibron Library** is a multi-branch hybrid academic and public library network operating across major Nigerian cities (Abuja, Lagos, and Port Harcourt). The organisation manages physical book collections, digital media resources, membership subscriptions, book lending, hold reservations, and overdue fine collections.


### Database Users
* **Library Members (Students, Researchers, & General Public):** Search multi-branch book availability, browse digital metadata and member reviews, view loan history, and settle overdue fines.
* **Librarians & Front-Desk Staff:** Register new members, process atomic book check-outs and returns, and assess or collect overdue fines.
* **System Administrators & Acquisitions Managers:** Add new bibliographic titles, allocate physical copies across branches, monitor query performance, and oversee database availability.

### Major Data Stored
* **Member Records:** Member IDs, atomic first/last names, unique email addresses, membership tiers (`Student`, `Researcher`, `General`), and account statuses (`Active`, `Suspended`, `Expired`).
* **Bibliographic & Inventory Data:** Book ISBNs, titles, authors, publication years, genres, physical copy barcodes, branch assignments, and copy availability statuses.
* **Circulation & Financial Logs:** Loan checkout timestamps, due dates, return timestamps, and overdue fine assessments/payment statuses.
* **Unstructured Digital Catalogue Data:** Polymorphic e-book/audiobook metadata, dynamic search tags, and embedded member reviews.

### Key Database Operations Supported
* Registering and managing library member accounts.
* Searching physical book availability across multiple branches in real time.
* Processing atomic book check-outs, returns, and overdue fine assessments.
* Enforcing concurrency control to prevent double-lending of physical book copies.
* Querying semi-structured digital catalogue metadata and aggregating member ratings.
* Partitioning circulation records by branch for low-latency regional access.

---

## 2. Repository Structure
This repository is organised progressively across five practical portfolio activities:

```text
exlibron-library-database-portfolio/
├── portfolio-1-database-design/          # ER diagram, 3NF schema, DDL & sample data scripts
├── portfolio-2-query-optimisation/       # Recursive CTE bulk data, EXPLAIN ANALYZE & covering indexes
├── portfolio-3-transactions-concurrency/ # ACID COMMIT/ROLLBACK & two-session SELECT ... FOR UPDATE
├── portfolio-4-nosql/                    # MongoDB polymorphic document model, \$push & aggregations
├── portfolio-5-distributed-cloud/        # Multi-branch cloud architecture & MySQL LIST partitioning
└── README.md                             # Main portfolio overview, reflection & submission summary
```

---

## 3. Portfolio Progress & Technical Highlights

| Portfolio Component | Focus Area & Key Evidence | Status |
| :--- | :--- | :--- |
| **[Portfolio 1](./portfolio-1-database-design/)** | **Database Design & Modelling:** 6-table 3NF relational schema in MySQL 8.0+ (InnoDB) with `er_diagram.png`, `01_schema_creation.sql`, `02_sample_data.sql`, and constraint verification. | **Completed** |
| **[Portfolio 2](./portfolio-2-query-optimisation/)** | **Query Processing & Optimisation:** Benchmarked 1,000 members, 2,000 copies, and 5,000 loans via `EXPLAIN ANALYZE`; reduced query latency by **34.4%** (`31.1 ms` $\rightarrow$ `20.4 ms`) and **96.0%** (`4.24 ms` $\rightarrow$ `0.17 ms`) using composite covering indexes. | **Completed** |
| **[Portfolio 3](./portfolio-3-transactions-concurrency/)** | **Transactions & Concurrency Control:** Verified atomic return-and-fine `COMMIT` and constraint-error `ROLLBACK` (`Error 3819`), plus two-connection pessimistic locking (`SELECT ... FOR UPDATE`) at `REPEATABLE READ` isolation. | **Completed** |
| **[Portfolio 4](./portfolio-4-nosql/)** | **NoSQL & Advanced Data Models:** Implemented polymorphic `book_catalogue` documents in MongoDB with multikey/text indexes, atomic `$push` review updates, and `$avg` rating aggregation pipelines. | **Completed** |
| **[Portfolio 5](./portfolio-5-distributed-cloud/)** | **Distributed & Cloud Database Exercise:** Architected a multi-region cloud topology (Abuja Primary + Lagos/Port Harcourt Read Replicas), analysed CAP trade-offs, and verified **Partition Pruning** (`partitions: p_lagos`) via MySQL `LIST` partitioning. | **Completed** |

---

## 4. Individual Technical Reflection
Developing the **Exlibron Library** portfolio progressively across relational, document, and distributed database paradigms demonstrated how architectural decisions depend directly on workload patterns:
1. **Relational Integrity vs. Read Performance (Portfolios 1 & 2):** Normalising to 3NF prevented update anomalies across branches and loans, while benchmarking with `EXPLAIN ANALYZE` showed how MySQL's Cost-Based Optimizer leverages composite covering indexes (`idx_copies_branch_status_isbn`) to satisfy queries directly from B-Tree leaf nodes without reading table data pages.
2. **Isolation & Locking Mechanics (Portfolio 3):** Testing two separate database connections revealed how InnoDB combines MVCC snapshots for consistent reads with exclusive row locks (`FOR UPDATE`) to serialize conflicting checkouts and prevent lost updates.
3. **Polyglot Persistence & Data Locality (Portfolios 4 & 5):** Adopting MongoDB for polymorphic digital/audio book metadata eliminated sparse relational columns and multi-table joins, while partitioning circulation records by `branch_id` demonstrated how geographic data locality avoids costly cross-shard joins while keeping critical financial writes strongly consistent.

---

## 5. AI Use Declaration

* **AI Tool Used:** Google Gemini
* **Purpose:** Used as a learning and structuring aid to refine SQL DDL/CTE scripts, composite indexing strategies, MongoDB document queries, and technical documentation formatting.
* **Verification:** Every SQL script, index benchmark (`EXPLAIN ANALYZE`), two-connection concurrency lock test, and partitioning query was executed, debugged, and verified independently on my computer system in MySQL Workbench 8.0.

