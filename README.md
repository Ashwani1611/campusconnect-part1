# CampusConnect - Part 1: Relational Database Design

**Database used:** SQLite 3.51.0

## 1. Normalization

### How the database could look without normalization

If we did not normalize the database, we could store all the information in one table like `enrollments_raw`.

For example:

| enrollment_id | student_name | student_email | course_code | course_title | course_credits | instructor_name | instructor_dept |
|---|---|---|---|---|---|---|---|
| 1 | Aditi Rao | aditi.rao@campusconnect.edu | CS101 | Introduction to Computer Science | 4 | Dr. Rakesh Mehta | CSE |
| 2 | Aditi Rao | aditi.rao@campusconnect.edu | CS201 | Database Systems | 3 | Dr. Rakesh Mehta | CSE |
| 3 | Rohan Das | rohan.das@campusconnect.edu | CS101 | Introduction to Computer Science | 4 | Dr. Rakesh Mehta | CSE |         |

The main problem here is that the same data gets repeated.

For example, if Aditi enrolls in multiple courses, her name and email will be stored again and again. The same thing can happen with course and instructor information.

This creates duplicate data and makes the database harder to maintain.

### 1NF - First Normal Form

For 1NF, each column should contain one single value.

The raw table already has single values in the columns, but it is still mixing information about students, courses, and instructors in one table.

So, I separated them into different tables:

* `students`
* `instructors`
* `courses`
* `enrollments`

Each table now has its own purpose and primary key. This makes the structure easier to understand and maintain.

### 2NF - Second Normal Form

2NF is mainly related to composite keys.

For example, suppose the `enrollments` table used `(student_id, course_id)` as a composite primary key. If we also stored `student_email` in this table, the email would depend only on `student_id`, not on the complete key.

This would be a partial dependency.

In my design, `enrollments` stores only details related to the enrollment, such as:

* `student_id`
* `course_id`
* `enrolled_at`
* `status`

The table uses `enrollment_id` as its primary key.

Student email is kept in the `students` table because it belongs to the student, not to a particular enrollment.

### 3NF - Third Normal Form

3NF means that a non-key column should not depend on another non-key column.

In the original single table, the data could be connected like this:

`enrollment_id -> course_code -> instructor_name -> instructor_dept`

This means the instructor's department is indirectly connected to the enrollment.

To avoid this, I created a separate `instructors` table.

Now, the instructor's department is directly related to `instructor_id`.

This removes the unnecessary dependency and keeps the database structure cleaner.

### Why I kept `seats_taken` in the `courses` table

Normally, we could calculate the number of enrolled students using `COUNT(*)` from the `enrollments` table.

But for this project, I have intentionally kept `seats_taken` in the `courses` table.

The reason is that one of the tasks is about concurrent enrollment and the lost update problem.

By storing `seats_taken`, I can update the seat count and insert the enrollment as part of the same transaction.

So, this is a deliberate denormalization for the purpose of the task.

---

## 2. Indexing

Indexes help the database find records faster.

I added the following indexes:

| Index                           | Column(s)                        | Why I added it                                                 |
| ------------------------------- | -------------------------------- | -------------------------------------------------------------- |
| `idx_enrollments_student_id`    | `enrollments(student_id)`        | Helps when finding enrollments for a student.                  |
| `idx_enrollments_course_id`     | `enrollments(course_id)`         | Helps when finding students enrolled in a course.              |
| `idx_courses_instructor_id`     | `courses(instructor_id)`         | Helps when finding courses taught by an instructor.            |
| `idx_enrollments_course_status` | `enrollments(course_id, status)` | Helps when finding active enrollments for a particular course. |

For example, the `student_id` index is useful when joining `students` with `enrollments`.

The `course_id` index is useful when checking how many students are enrolled in a course.

The `instructor_id` index helps when joining instructors and courses, such as finding instructors who teach multiple courses.

I also added a composite index on `course_id` and `status`.

This is useful for a query like:

```sql
WHERE course_id = ? AND status = 'active'
```

I placed `course_id` first because it is the main column used to find the course.

### Why I did not create an index on `status`

I did not create a separate index on `enrollments.status`.

There are only three possible values:

* `active`
* `dropped`
* `completed`

Since there are very few different values, the database may still have to check many rows even with an index.

Also, every time a row is inserted or updated, the database would have to maintain this extra index.

So, I felt a separate index on `status` was not useful here.

Instead, I used `status` as the second column in the composite index `(course_id, status)`.

---

## 3. Transactions and Isolation

### Example of a concurrent enrollment problem

I used the `CS401` course, which is **Distributed Systems**, as an example.

This course has:

* `30` total seats
* `29` seats already taken

So, only one seat is left.

Now imagine Yusuf Khan and Neha Kapoor both try to enroll at almost the same time.

Both requests first run:

```sql
SELECT seats_taken, seats_total
FROM courses
WHERE course_id = 11;
```

Because both requests happen very close to each other, both may read:

```text
seats_taken = 29
seats_total = 30
```

So, both requests think that one seat is available.

After that, both try to update the course:

```sql
UPDATE courses
SET seats_taken = seats_taken + 1
WHERE course_id = 11;
```

Then both insert their enrollment records.

The problem is that both transactions made their decision using the same old value.

As a result, both students may think that they successfully enrolled even though only one seat was available.

This is an example of a **lost update problem**.

In simple words, two transactions are trying to update the same data at the same time, and one update can interfere with the other.

### Isolation level that can prevent this

The best isolation level for this situation is **Serializable**.

Serializable makes concurrent transactions behave as if they are running one after another.

For example:

1. Yusuf's transaction runs first.
2. The seat count becomes `30`.
3. Neha's transaction runs after that.
4. Neha sees that the course is full, so the enrollment is rejected.

The second transaction may either wait for the first transaction to finish or fail and need to be retried, depending on how the database handles it.

### Why Read Committed is not enough

Read Committed prevents a transaction from reading uncommitted data.

However, two transactions can still read the same committed value at almost the same time.

In this example, both transactions could read `seats_taken = 29`.

So, both may try to enroll for the same last seat.

That is why Read Committed is not enough for this problem.

**Serializable isolation is better here because it makes sure that the two transactions cannot incorrectly process the same last seat at the same time.**
