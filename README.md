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
* **Library Members (Students, Researchers, & General Public):** Search the multi-branch catalogue, place reservations on borrowed books, view personal loan history, and settle overdue fines.
* **Librarians & Front-Desk Staff:** Register new members, process book check-outs and returns, verify physical book conditions, and manage fine payments or waivers.
* **System Administrators & Acquisitions Managers:** Add new book titles, allocate physical copies across branches, monitor overdue analytics, and manage database performance and security.

### Major Data Stored
* **Member Records:** Member IDs, contact details, registration dates, membership tiers, and account statuses.
* **Bibliographic & Inventory Data:** Book ISBNs, titles, authors, genres, publication years, physical copy barcodes, condition statuses, and branch assignments.
* **Circulation & Financial Logs:** Loan issue dates, due dates, return timestamps, reservation queues, and overdue fine assessments/payments.
* **Unstructured Catalogue Data:** Book descriptions, user reviews, dynamic tags, and digital format metadata.

### Key Database Operations Supported
* Registering and updating library member accounts.
* Searching book availability across multiple branches in real time.
* Processing atomic book check-outs, returns, and overdue fine payments.
* Managing FIFO (First-In, First-Out) hold/reservation queues for high-demand titles.
* Generating branch-level borrowing analytics and overdue reports.

---

## 2. Repository Structure

This repository is organised progressively across five practical portfolio activities:

```text
exlibron-library-database-portfolio/
├── portfolio-1-database-design/          
├── portfolio-2-query-optimisation/       
├── portfolio-3-transactions-concurrency/ 
├── portfolio-4-nosql/                    
├── portfolio-5-distributed-cloud/        
└── README.md                            
```

---


All database schemas, SQL scripts, NoSQL models, and performance analyses in this repository represent my practical work for **MIT 8103**. 
