-- Run: sqlite3 campusconnect.db < sql/transactions.sql
PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

UPDATE courses
SET seats_taken = seats_taken + 1
WHERE course_id = 9
  AND seats_taken < seats_total;

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrolled_at, status)
VALUES (13, 11, 9, '2025-08-11 09:00:00', 'active');

COMMIT;

SELECT course_id, seats_taken, seats_total FROM courses WHERE course_id = 9;
SELECT * FROM enrollments WHERE enrollment_id = 13;
