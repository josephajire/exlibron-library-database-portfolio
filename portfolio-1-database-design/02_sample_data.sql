USE exlibron_library;

INSERT INTO branches (branch_name, city, address) VALUES
('Exlibron Central Abuja', 'Abuja', 'Plot 42 Ademola Adetokunbo Crescent, Wuse 2'),
('Exlibron Victoria Island', 'Lagos', '18 Adeola Odeku Street, Victoria Island'),
('Exlibron GRA Port Harcourt', 'Port Harcourt', '7 Tombia Street, New GRA Phase 2');

INSERT INTO members (first_name, last_name, email, membership_tier, account_status) VALUES
('Zainab', 'Bello', 'zainab.bello@example.ng', 'Researcher', 'Active'),
('Tunde', 'Adeyemi', 'tunde.adeyemi@example.ng', 'Student', 'Active'),
('Ngozi', 'Eze', 'ngozi.eze@example.ng', 'General', 'Active');

INSERT INTO books (isbn, title, author_name, publication_year, genre) VALUES
('9780134190440', 'The Go Programming Language', 'Alan A. A. Donovan', 2015, 'Computer Science'),
('9781449373320', 'Designing Data-Intensive Applications', 'Martin Kleppmann', 2017, 'Database Systems'),
('9780385474542', 'Things Fall Apart', 'Chinua Achebe', 1994, 'African Literature');

INSERT INTO book_copies (isbn, branch_id, barcode, copy_status) VALUES
('9781449373320', 1, 'EXL-ABJ-0001', 'Loaned'),
('9781449373320', 1, 'EXL-ABJ-0002', 'Available'),
('9780134190440', 2, 'EXL-LOS-0001', 'Available'),
('9780385474542', 3, 'EXL-PHC-0001', 'Loaned');

INSERT INTO loans (copy_id, member_id, checkout_date, due_date, return_date) VALUES
(1, 1, '2026-10-01 10:15:00', '2026-10-15', NULL),
(4, 2, '2026-09-10 14:30:00', '2026-09-24', '2026-09-29 11:00:00');

INSERT INTO fines (loan_id, amount_ngn, payment_status) VALUES
(2, 2500.00, 'Paid');
