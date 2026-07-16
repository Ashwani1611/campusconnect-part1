-- Run: sqlite3 campusconnect.db < sql/transactions.sql
-- Task 6, sub-requirement: "Write one multi-statement transaction (using BEGIN/COMMIT/ROLLBACK) that updates two related rows together so that
-- both changes succeed or neither does."
-- Demonstrates: incrementing seats_taken on courses + inserting a row into enrollments, as a single atomic unit.
PRAGMA foreign_keys = ON;

-- Scenario: student 11 (Neha Kapoor) enrolls in course 9 (EC101, 40 seats, 1 taken). Both statements below must succeed together, or neither should take effect.

BEGIN TRANSACTION;

-- Step 1: reserve a seat on the course (only succeeds if under capacity)
UPDATE courses
SET seats_taken = seats_taken + 1
WHERE course_id = 9
  AND seats_taken < seats_total;

-- Step 2: record the enrollment itself
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrolled_at, status)
VALUES (13, 11, 9, '2025-08-11 09:00:00', 'active');

COMMIT;

-- Verification query: seats_taken should now be 2, and the enrollment
-- row should exist.
SELECT course_id, seats_taken, seats_total FROM courses WHERE course_id = 9;
SELECT * FROM enrollments WHERE enrollment_id = 13;
