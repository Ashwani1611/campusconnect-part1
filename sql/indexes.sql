-- Run: sqlite3 campusconnect.db < sql/indexes.sql
-- Justifications for each index are in README.md under "Indexing".

CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_courses_instructor_id ON courses(instructor_id);
CREATE INDEX idx_enrollments_course_status ON enrollments(course_id, status);
