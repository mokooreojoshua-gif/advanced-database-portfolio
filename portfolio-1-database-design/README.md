# University Results Portal - Portfolio 1

## Case study
This is a fictional university results portal used consistently as the portfolio case study. It supports students, lecturers, and administrators with course registration, assessment score entry, result calculation, and transcript retrieval.

## Scope of this draft
The PostgreSQL schema separates departments, programmes, students, lecturers, courses, semesters, course offerings, enrollments, assessments, and scores. Composite foreign keys ensure a score belongs to an assessment in the same offering in which the student is enrolled. Final results can be calculated from weighted assessment scores rather than stored as duplicate data.

## Assumptions to confirm
- One or more sections of a course may run in a semester.
- A student can enroll in a course offering once.
- Assessment weights for an offering should total 100% before results are published.
- The institution's grading bands and GPA rules are not assumed; add them after confirming the official policy.
- The semester labels and admission year range are draft rules and should be reviewed against local practice.

## Normalisation
- 1NF: each field contains one value; assessments and scores are separate rows.
- 2NF: enrollment attributes depend on the full student/offering key.
- 3NF: programme, department, course, lecturer, and semester details are stored once in their respective tables, avoiding transitive dependencies and repeated descriptive data.

## Running the draft locally\nCreate an empty PostgreSQL database, run `schema.sql`, then run `seed-demo.sql` once. The demo seed uses invented data. Review the admission-year and semester rules before relying on them.\n\n## Evidence still to add
- Final ER diagram image or source.
- Database creation and schema execution evidence from pgAdmin.
- Small sample dataset and query outputs.
- Student review of the assumptions, constraints, and grading policy.

