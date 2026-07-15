-- Engine: SQLite 3.45
PRAGMA foreign_keys = ON;

CREATE TABLE students (
    student_id   INTEGER PRIMARY KEY,
    full_name    TEXT NOT NULL,
    email        TEXT NOT NULL UNIQUE,
    enrolled_on  TEXT NOT NULL DEFAULT (date('now'))
);

CREATE TABLE instructors (
    instructor_id INTEGER PRIMARY KEY,
    full_name     TEXT NOT NULL,
    email         TEXT NOT NULL UNIQUE,
    department    TEXT NOT NULL
);

CREATE TABLE courses (
    course_id     INTEGER PRIMARY KEY,
    course_code   TEXT NOT NULL UNIQUE,
    title         TEXT NOT NULL,
    credits       INTEGER NOT NULL CHECK (credits > 0),
    instructor_id INTEGER NOT NULL,
    seats_total   INTEGER NOT NULL CHECK (seats_total >= 0),
    seats_taken   INTEGER NOT NULL DEFAULT 0 CHECK (seats_taken >= 0),
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id    INTEGER NOT NULL,
    course_id     INTEGER NOT NULL,
    enrolled_at   TEXT NOT NULL DEFAULT (current_timestamp),
    status        TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','dropped','completed')),
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)
);