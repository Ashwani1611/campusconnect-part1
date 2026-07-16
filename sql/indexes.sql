-- Run: sqlite3 campusconnect.db < sql/indexes.sql
-- Task 5: choose at least two columns used in WHERE/JOIN/ORDER BY clauses of Task 4's queries and create indexes for them, including one composite
-- index on two columns used together. Full justification for each index, plus the deliberately-unindexed column, is in README.md under "Indexing".

-- Speeds up the students -> enrollments join used in the INNER JOIN query
-- (active enrollments per student) and the correlated subquery counting
-- enrollments per student.
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);

-- Speeds up the courses -> enrollments join used in the LEFT JOIN query
-- (enrollment count per course) and the FULL OUTER JOIN query.
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);

-- Speeds up the instructors -> courses join used in the GROUP BY/HAVING
-- query, the EXISTS query, the UNION set-operation query, and the
-- window-function ranking query.
CREATE INDEX idx_courses_instructor_id ON courses(instructor_id);

-- Composite index: speeds up a roster-style lookup for a specific course's
-- active enrollments, e.g. WHERE course_id = ? AND status = 'active'.
-- course_id is listed first as the more selective/commonly filtered column.
CREATE INDEX idx_enrollments_course_status ON enrollments(course_id, status);
