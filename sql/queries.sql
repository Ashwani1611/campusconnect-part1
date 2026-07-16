-- Run: sqlite3 campusconnect.db < sql/queries.sql
PRAGMA foreign_keys = ON;

-- 1. IN and BETWEEN
SELECT course_code, title, credits
FROM courses
WHERE course_code IN ('CS101', 'CS102', 'CS201', 'MA101');

SELECT course_code, title, credits
FROM courses
WHERE credits BETWEEN 3 AND 4;

-- 2. IS NULL / IS NOT NULL
SELECT enrollment_id, student_id, course_id
FROM enrollments
WHERE enrolled_at IS NULL;

SELECT enrollment_id, student_id, course_id
FROM enrollments
WHERE enrolled_at IS NOT NULL;

-- 3. GROUP BY with HAVING
SELECT i.instructor_id, i.full_name, COUNT(c.course_id) AS course_count FROM instructors i
JOIN courses c ON c.instructor_id = i.instructor_id GROUP BY i.instructor_id, i.full_name
HAVING COUNT(c.course_id) > 1;

-- 4. Three different join types
SELECT s.full_name, c.course_code, c.title FROM students s
INNER JOIN enrollments e ON e.student_id = s.student_id
INNER JOIN courses c ON c.course_id = e.course_id
WHERE e.status = 'active';

SELECT c.course_code, c.title, COUNT(e.enrollment_id) AS enrollment_count FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id GROUP BY c.course_id, c.course_code, c.title;

SELECT s.full_name, e.enrollment_id, e.course_id
FROM students s FULL OUTER JOIN enrollments e ON e.student_id = s.student_id;

-- 5. Scalar subquery, correlated subquery, EXISTS
SELECT course_code, title, credits
FROM courses
WHERE credits > (SELECT AVG(credits) FROM courses);

SELECT s.full_name,(SELECT COUNT(*) FROM enrollments e WHERE e.student_id = s.student_id) AS my_enrollment_count
FROM students s
WHERE (SELECT COUNT(*) FROM enrollments e WHERE e.student_id = s.student_id)
      > (SELECT CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT student_id) FROM enrollments);

SELECT i.full_name FROM instructors i
WHERE EXISTS (
    SELECT 1 FROM courses c
    WHERE c.instructor_id = i.instructor_id AND c.seats_total > 50
);

-- 6. Set operation
SELECT e.student_id FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
JOIN instructors i ON i.instructor_id = c.instructor_id
WHERE i.department = 'CSE'
UNION
SELECT e.student_id FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
JOIN instructors i ON i.instructor_id = c.instructor_id
WHERE i.department = 'Mathematics';

-- 7. Window function
SELECT i.full_name,
       c.course_code,
       c.seats_taken,
       RANK() OVER (PARTITION BY c.instructor_id ORDER BY c.seats_taken DESC) AS seat_rank
FROM courses c
JOIN instructors i ON i.instructor_id = c.instructor_id;
