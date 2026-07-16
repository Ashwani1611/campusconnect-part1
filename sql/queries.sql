-- Run: sqlite3 campusconnect.db < sql/queries.sql
PRAGMA foreign_keys = ON;

-- Task 4, sub-requirement: "One query using IN and one using BETWEEN"

-- (a) Query using IN
SELECT course_code, title, credits
FROM courses
WHERE course_code IN ('CS101', 'CS102', 'CS201', 'MA101');

-- (b) Query using BETWEEN
SELECT course_code, title, credits
FROM courses
WHERE credits BETWEEN 3 AND 4;


-- Task 4, sub-requirement: "One query using IS NULL or IS NOT NULL correctly (not = NULL)"

-- (a) IS NULL
SELECT enrollment_id, student_id, course_id
FROM enrollments
WHERE enrolled_at IS NULL;

-- (b) IS NOT NULL
SELECT enrollment_id, student_id, course_id
FROM enrollments
WHERE enrolled_at IS NOT NULL;


-- Task 4, sub-requirement: "One query using GROUP BY with HAVING (not WHERE) to filter an aggregate"
SELECT i.instructor_id, i.full_name, COUNT(c.course_id) AS course_count
FROM instructors i
JOIN courses c ON c.instructor_id = i.instructor_id
GROUP BY i.instructor_id, i.full_name
HAVING COUNT(c.course_id) > 1;


-- Task 4, sub-requirement: "At least three different join types among INNER, LEFT, RIGHT, FULL OUTER"

-- (a) INNER JOIN
SELECT s.full_name, c.course_code, c.title
FROM students s
INNER JOIN enrollments e ON e.student_id = s.student_id
INNER JOIN courses c ON c.course_id = e.course_id
WHERE e.status = 'active';

-- (b) LEFT JOIN
SELECT c.course_code, c.title, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_code, c.title;

-- (c) FULL OUTER JOIN (supported natively in SQLite 3.39+; no substitution needed)
SELECT s.full_name, e.enrollment_id, e.course_id
FROM students s
FULL OUTER JOIN enrollments e ON e.student_id = s.student_id;


-- Task 4, sub-requirement: "One scalar subquery, one correlated subquery, and one query using EXISTS"

-- (a) Scalar subquery
SELECT course_code, title, credits
FROM courses
WHERE credits > (SELECT AVG(credits) FROM courses);

-- (b) Correlated subquery
SELECT s.full_name,
       (SELECT COUNT(*) FROM enrollments e WHERE e.student_id = s.student_id) AS my_enrollment_count
FROM students s
WHERE (SELECT COUNT(*) FROM enrollments e WHERE e.student_id = s.student_id)
      > (SELECT CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT student_id) FROM enrollments);

-- (c) EXISTS
SELECT i.full_name
FROM instructors i
WHERE EXISTS (
    SELECT 1 FROM courses c
    WHERE c.instructor_id = i.instructor_id AND c.seats_total > 50
);


-- Task 4, sub-requirement: "One query using a set operation (UNION, UNION ALL, INTERSECT, or EXCEPT)"
SELECT e.student_id
FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
JOIN instructors i ON i.instructor_id = c.instructor_id
WHERE i.department = 'CSE'
UNION
SELECT e.student_id
FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
JOIN instructors i ON i.instructor_id = c.instructor_id
WHERE i.department = 'Mathematics';


-- Task 4, sub-requirement: "One query using a window function (ROW_NUMBER(), RANK(), or an aggregate window function with PARTITION BY)"
SELECT i.full_name,
       c.course_code,
       c.seats_taken,
       RANK() OVER (PARTITION BY c.instructor_id ORDER BY c.seats_taken DESC) AS seat_rank
FROM courses c
JOIN instructors i ON i.instructor_id = c.instructor_id;
