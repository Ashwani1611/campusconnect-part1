-- Run this file using: sqlite3 campusconnect.db < sql/sample_data.sql
PRAGMA foreign_keys = ON;

-- ----------------------------------------------------------------
-- FOREIGN KEY INSERTION ORDER DEMO
-----------------------------------
-- ============================================================
-- INSERTION-ORDER DEMO (Task 3 requirement)
-- Uncomment and run this BEFORE the instructors INSERTs below
-- to see: Error: FOREIGN KEY constraint failed
--
-- INSERT INTO courses (course_id, course_code, title, credits, instructor_id, seats_total, seats_taken)
-- VALUES (9001, 'CS999', 'Ghost Course', 3, 9999, 30, 0);
-- --------------------------------------------------------------------------------------------------

-- ---------- STUDENTS ----------
-- Students are independent records, so we can insert them first.
INSERT INTO students (student_id, full_name, email, enrolled_on) VALUES
 (1, 'Aditi Rao',      'aditi.rao@campusconnect.edu',      '2025-08-01'),
 (2, 'Rohan Das',       'rohan.das@campusconnect.edu',      '2025-08-01'),
 (3, 'Meera Nair',      'meera.nair@campusconnect.edu',     '2025-08-02'),
 (4, 'Kabir Singh',     'kabir.singh@campusconnect.edu',    '2025-08-02'),
 (5, 'Priya Sharma',    'priya.sharma@campusconnect.edu',   '2025-08-03'),
 (6, 'Arjun Mehta',     'arjun.mehta@campusconnect.edu',    '2025-08-03'),
 (7, 'Sana Iqbal',      'sana.iqbal@campusconnect.edu',     '2025-08-04'),
 (8, 'Devansh Gupta',   'devansh.gupta@campusconnect.edu',  '2025-08-04'),
 (9, 'Lavanya Pillai',  'lavanya.pillai@campusconnect.edu', '2025-08-05'),
 (10,'Yusuf Khan',      'yusuf.khan@campusconnect.edu',     '2025-08-05'),
 (11,'Neha Kapoor',     'neha.kapoor@campusconnect.edu',    '2025-08-06');


-- ---------- INSTRUCTORS ----------
-- Instructors are also independent records.
INSERT INTO instructors (instructor_id, full_name, email, department) VALUES
 (1, 'Dr. Rakesh Mehta',  'r.mehta@campusconnect.edu',   'CSE'),
 (2, 'Dr. Kavita Iyer',   'k.iyer@campusconnect.edu',    'CSE'),
 (3, 'Dr. Sameer Joshi',  's.joshi@campusconnect.edu',   'Mathematics'),
 (4, 'Dr. Ananya Verma',  'a.verma@campusconnect.edu',   'CSE'),
 (5, 'Dr. Farhan Ali',    'f.ali@campusconnect.edu',     'Physics'),
 (6, 'Dr. Ritu Malhotra', 'r.malhotra@campusconnect.edu','CSE'),
 (7, 'Dr. Vikram Rathore','v.rathore@campusconnect.edu', 'Electronics'),
 (8, 'Dr. Nandini Bose',  'n.bose@campusconnect.edu',    'Mathematics'),
 (9, 'Dr. Imran Sheikh',  'i.sheikh@campusconnect.edu',  'CSE'),
 (10,'Dr. Pooja Reddy',   'p.reddy@campusconnect.edu',   'Physics'),
 (11,'Dr. Manav Chawla',  'm.chawla@campusconnect.edu',  'Electronics');


-- ---------- COURSES ----------
-- Each course is linked to instructor.
-- Since all instructors have already inserted above,
-- these course records can be added.
INSERT INTO courses (course_id, course_code, title, credits, instructor_id, seats_total, seats_taken) VALUES
 (1, 'CS101', 'Introduction to Computer Science', 4, 1, 60, 3),
 (2, 'CS102', 'Data Structures',                  4, 2, 50, 2),
 (3, 'CS201', 'Database Systems',                 3, 1, 40, 1),
 (4, 'CS202', 'Operating Systems',                4, 6, 45, 2),
 (5, 'CS301', 'Computer Networks',                3, 9, 35, 1),
 (6, 'MA101', 'Calculus I',                       3, 3, 80, 2),
 (7, 'MA201', 'Linear Algebra',                   3, 8, 50, 1),
 (8, 'PH101', 'Physics I',                        4, 5, 60, 1),
 (9, 'EC101', 'Digital Electronics',              3, 7, 40, 1),
 (10,'CS302', 'Software Engineering',             4, 4, 55, 1),
 (11,'CS401', 'Distributed Systems',              3, 6, 30, 0);
-- ---------- enrollments ----------
-- Insertion-order demo: uncomment BEFORE the students/courses inserts above
-- to see: Error: FOREIGN KEY constraint failed
--
-- INSERT INTO enrollments (enrollment_id, student_id, course_id, status)
-- VALUES (9002, 9999, 9999, 'active');

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrolled_at, status) VALUES
(1, 1, 1,  '2025-08-10 09:00:00', 'active'),
(2, 1, 3,  '2025-08-10 09:05:00', 'active'),
(3, 2, 1,  '2025-08-10 09:10:00', 'active'),
(4, 2, 2,  '2025-08-10 09:12:00', 'active'),
(5, 3, 6,  '2025-08-10 10:00:00', 'active'),
(6, 4, 4,  '2025-08-10 10:05:00', 'active'),
(7, 5, 5,  '2025-08-10 10:10:00', 'active'),
(8, 6, 4,  '2025-08-10 10:15:00', 'active'),
(9, 7, 9,  '2025-08-10 10:20:00', 'dropped'),
(10,8, 8,  '2025-08-10 10:25:00', 'active'),
(11,9, 7,  '2025-08-10 10:30:00', 'completed'),
(12,10,2, '2025-08-10 10:35:00', 'active');
