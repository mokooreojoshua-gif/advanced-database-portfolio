-- Synthetic demonstration data for the fictional results portal.
-- Run once, in a fresh database after schema.sql.
-- Every person and address below is invented; never put live student records here.

INSERT INTO departments (name) VALUES ('School of Computing');

INSERT INTO programmes (department_id, name, award_level)
VALUES (1, 'Master of Information Technology', 'Masters');

INSERT INTO students (student_id, programme_id, first_name, last_name, email, admission_year)
OVERRIDING SYSTEM VALUE
VALUES (1001, 1, 'Amina', 'Demo', 'amina.demo@example.invalid', 2026);

INSERT INTO lecturers (department_id, first_name, last_name, email)
VALUES (1, 'Tunde', 'Example', 'tunde.example@example.invalid');

INSERT INTO courses (course_id, department_id, title, credit_units)
VALUES ('MIT8103', 1, 'Advanced Database Systems', 3);

INSERT INTO semesters (academic_year, term)
VALUES ('2026/2027', 'First');

INSERT INTO course_offerings (course_id, semester_id, lecturer_id, section_code)
VALUES ('MIT8103', 1, 1, 'A');

INSERT INTO enrollments (student_id, offering_id, status)
VALUES (1001, 1, 'Enrolled');

INSERT INTO assessments (offering_id, title, max_score, weight_percent)
VALUES (1, 'Continuous Assessment', 30, 40),
       (1, 'Examination', 70, 60);

INSERT INTO scores (student_id, offering_id, assessment_id, score_value)
VALUES (1001, 1, 1, 25.50),
       (1001, 1, 2, 56.58);

-- Expected weighted total for this invented sample: 82.50 out of 100.
-- This is sample data, not a result from a real student or a live system.


