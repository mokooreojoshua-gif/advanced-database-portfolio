# University Results Portal - Portfolio 1

## Case study
This is a fictional university results portal used consistently as the portfolio case study. It supports students, lecturers, and administrators with course registration, assessment score entry, result calculation, and transcript retrieval.

## Scope of this draft
The PostgreSQL schema separates departments, programmes, students, lecturers, courses, semesters, course offerings, enrollments, assessments, and scores. Composite foreign keys ensure a score belongs to an assessment in the same offering in which the student is enrolled. Final results can be calculated from weighted assessment scores rather than stored as duplicate data. Grade points and GPA are derived from the mark bands, course credits, and GPA formula documented below rather than stored as duplicate result fields.

## Assumptions to confirm
- One or more sections of a course may run in a semester.
- A student can enroll in a course offering once.
- Assessment weights for an offering should total 100% before results are published.
- Assessment and examination weights follow Miva's published 40% continuous-assessment / 60% examination split; confirm any course-specific LMS instructions before relying on it.
- The semester labels and admission year range are draft rules and should be reviewed against local practice.

## Published grading and GPA policy
Miva's official learner support guide states that continuous assessments contribute 40% and the final examination 60%. Its mark bands are A: 70–100 (5 points), B: 60–69 (4), C: 50–59 (3), D: 45–49 (2), E: 40–44 (1), and F: 0–39 (0). Course GPA is total quality points divided by total registered credit units; quality points equal grade points multiplied by course credit units. Degree classifications use CGPA: 4.50–5.00 First Class; 3.50–4.49 Second Class Upper; 2.40–3.49 Second Class Lower; 1.50–2.39 Third Class; and 1.00–1.49 Pass. The synthetic 82.50 result maps to A / 5 points under this scale; it is not a real student result. Course-specific grading instructions shown in the LMS should also be checked. Source: [Miva grading system and grade point scale](https://support.miva.university/portal/en/kb/articles/understanding-the-grading-system-and-grade-point-scale).

## Normalisation
- 1NF: each field contains one value; assessments and scores are separate rows.
- 2NF: enrollment attributes depend on the full student/offering key.
- 3NF: programme, department, course, lecturer, and semester details are stored once in their respective tables, avoiding transitive dependencies and repeated descriptive data.

## Running the draft locally
Create an empty PostgreSQL database, run `schema.sql`, then run `seed-demo.sql` once. The demo seed uses invented data. Review the admission-year and semester rules before relying on them.

## Evidence and review status
- The ER diagram source and image are in the repository and `../evidence/`.
- Schema and synthetic seed execution were completed locally; weighted-result and foreign-key outputs are captured. A separate schema execution screenshot is optional additional evidence.
- Review the small sample dataset and query output against the included scripts before submission.
- Student review of assumptions and course-specific LMS rules, plus personalization of the technical reflection, remains the student's final review step.




