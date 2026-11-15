# MIT 8103 Study Guide: University Results Portal

This guide explains the ideas behind the portfolio and how the files fit together. It is a study aid for the fictional demonstration system, not a substitute for your lecturer's instructions or Miva's course-specific grading rules. All records and marks used here are invented.

## 1. The system in one picture

The portal stores academic facts in PostgreSQL, where constraints keep related records consistent. A student's result is calculated from assessment scores and configured weights. A nested MongoDB document is an alternate read model for retrieving a ready-made term summary. The distributed design describes how a future deployment could add replicas and backups; it was not deployed.

The central chain is:

`student -> enrollment -> course offering -> course / semester / lecturer`

`course offering -> assessments -> scores`

An offering is a particular course in a particular term and section. The same course can have many offerings over time, and each offering can have many enrolled students. An assessment belongs to one offering; a score ties one enrolled student to one assessment in that offering.

## 2. Relational design: why these tables and constraints exist

Open `portfolio-1-database-design/schema.sql` and follow the entities from the diagram. A primary key gives each row a stable identity. A foreign key requires a referenced row to exist. `NOT NULL` requires a value, `UNIQUE` prevents duplicates, and `CHECK` enforces a rule on a value in the row.

For example, `students.email` is unique so two students cannot share an email address. `courses.credit_units` must be positive. `enrollments` uses `(student_id, offering_id)` as a composite primary key because a student should enroll in a particular offering only once. Composite foreign keys in `scores` also ensure the score's student is enrolled in that offering and that the assessment belongs to the same offering. This prevents a valid-looking ID from linking records from different courses.

The trigger `enforce_score_maximum` checks a rule that depends on another table: a score cannot be greater than that assessment's `max_score`. A normal `CHECK` constraint cannot conveniently look up another row, so a trigger runs this check when a score is inserted or changed.

### Normalization in this design

- **First normal form:** store individual values in columns and represent repeated scores as separate rows, rather than putting a list of scores into one field.
- **Second normal form:** in a table with a composite key, each non-key fact should depend on the whole key. Enrollment status belongs to a student-offering enrollment, not just the student or just the offering.
- **Third normal form:** keep facts about departments, courses, lecturers, programmes, and semesters in their own tables. For example, a course title is stored once in `courses`, rather than copied to every student's score row.

Normalization reduces conflicting copies of the same fact. Queries need joins to assemble a transcript, but changes to a course or lecturer have one authoritative location.

## 3. Weighted marks, grades, and GPA

The portfolio uses Miva's published 40% continuous assessment and 60% final examination split. Check your MIT 8103 LMS instructions in case the course specifies an exception.

For an assessment, its contribution is:

`(score earned / maximum score) * assessment weight`

For the synthetic MIT8103 example:

- CA: `(25.50 / 30) * 40 = 34.00`
- Examination: `(56.58 / 70) * 60 = 48.497...`
- Sum: `82.497...`, displayed as **82.50** to two decimal places.

The code stores the raw score and maximum separately, so a 25.50 out of 30 is converted to the configured 40-point contribution. The sum of weights for an offering should be 100 before the result is published. The schema contains a query that flags offerings whose weights do not sum to 100 and another that finds offerings without assessments.

According to Miva's published guide, 70–100 maps to A / 5 grade points, 60–69 to B / 4, 50–59 to C / 3, 45–49 to D / 2, 40–44 to E / 1, and below 40 to F / 0. Quality points for a course equal `grade points * credit units`. GPA is `sum of quality points / sum of registered credit units`. The 82.50 example is fictional and maps to 5 points under that published scale; it is not an actual student grade.

## 4. Reading the result query

In `portfolio-2-query-optimisation/queries.sql`, Q1 starts with a common table expression named `offering_results`. It joins enrollments to offerings, courses, semesters, assessments, and scores. The `LEFT JOIN` to scores is deliberate: it lets the query count assessments even when a score has not been entered yet.

The query groups records by student, offering, course, and term. It then retains only groups where every assessment has a score and all assessment weights sum to 100. The outer query rounds the calculated total to two decimal places. This is safer than publishing a partial result or a result whose weights are misconfigured.

Q2 counts currently enrolled students in each course offering. `LEFT JOIN` keeps an offering visible even when it has no enrollments. PostgreSQL's `FILTER` clause counts only rows whose enrollment status is `Enrolled`.

## 5. Indexes and query plans

An index is a lookup structure that can help the database find rows without reading a whole table. It consumes disk space and adds work to inserts, updates, and deletes, so it should support a real query pattern.

The portfolio compares this query before and after the index on `enrollments(offering_id)`:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT student_id, status
FROM enrollments
WHERE offering_id = 1;
```

`EXPLAIN` shows the plan PostgreSQL chose. `ANALYZE` actually runs the query and reports observed timings and row counts. `BUFFERS` reports data read from cache or storage. The observed demo table had one enrollment row, so PostgreSQL chose a sequential scan both before and after the index was created. That is reasonable: for a tiny table, scanning every row can cost less than using an index. The measured times are tiny, vary between runs, and do not prove the index makes queries faster or slower in general. A representative larger dataset is needed for a useful performance comparison.

The before/after results and their limits are recorded in `portfolio-2-query-optimisation/README.md`. Never generalize these local timings to a production system.

## 6. Transactions and concurrent changes

A transaction groups database operations into one unit. `COMMIT` makes the changes durable; `ROLLBACK` abandons changes made in the open transaction. A transaction helps prevent partially applied corrections.

The exercise in `portfolio-3-transactions-concurrency/transactions-concurrency.sql` first changes a demo score and commits it, then makes another change and rolls it back. The committed value remains; the rolled-back value does not.

For the two-session exercise, Session A begins a transaction and selects the score row `FOR UPDATE`. That locks the row for a conflicting update. Session B then tries to change the same row and waits. When A commits, B can continue. This is row-level locking: the database serializes the conflicting writes so they do not both silently overwrite the row at the same time. The observed isolation setting was `read committed`; at that level, each statement sees data committed before that statement began. The exact wait time in this local exercise is not a general benchmark.

After experimenting, the demo score was restored to 25.50 and checked. Resetting sample data matters because later portfolio queries depend on known starting values.

## 7. MongoDB document model and PostgreSQL JSONB

The MongoDB example stores one student's term as one document, with a nested course array and assessment array. This can make a transcript read convenient: one lookup returns the related course and assessment details together. It also duplicates course labels and a derived total. If the source course title or scores change, the embedded summary must be updated too, or it can become stale.

The unique compound index is:

```javascript
{ studentId: 1, academicYear: 1, term: 1 }
```

It supports the term lookup and prevents two documents from using the same student/year/term key. The local implementation was performed in MongoDB Compass. The `.mongodb.js` file records the repeatable shell form, but the screenshots show Compass operations.

`portfolio-4-nosql/postgres-jsonb-comparison.sql` accesses nested JSON stored in PostgreSQL JSONB. JSONB is a PostgreSQL data type with operators for querying JSON values. This is useful for flexible document-like data, but it is still PostgreSQL; it does not count as running MongoDB. The MongoDB and JSONB examples demonstrate similar nested-data ideas in separate products.

## 8. Replication, consistency, partitioning, and sharding

`portfolio-5-distributed-cloud/architecture.md` is a proposal. A primary database accepts authoritative score changes. A standby or read replica can serve some read traffic. With asynchronous replication, a newly committed mark may take a short time to reach the replica, so a user who just changed a score should read the confirmation from the primary. Synchronous replication can wait for a replica acknowledgement and reduce the chance of losing an acknowledged write, but it adds latency and ties availability to that replica.

Backups are separate from replicas: a replica can copy accidental deletions or bad updates, while a backup gives a point-in-time recovery path. Partitioning divides a large table into manageable pieces inside one PostgreSQL database, often by date or academic year. Sharding distributes pieces across independent database servers and adds routing and operational complexity. These are different tools for different scale and workload problems.

No replicas, shards, cloud service, or production deployment were created for this coursework portfolio. Describe them as proposed design choices only.

## 9. How to study the project files

1. Read the root `README.md` and inspect the ERD. Explain the case study aloud in your own words.
2. Trace one result from `students` through `enrollments`, `course_offerings`, `assessments`, and `scores` in `schema.sql`.
3. Recalculate 82.50 by hand using the 40/60 formula, then follow Q1 in `queries.sql` to see how SQL aggregates it.
4. Compare the baseline and indexed plans. Explain why the sequential scan is sensible with only one row.
5. Walk through the transaction script. State which values persist after `COMMIT`, disappear after `ROLLBACK`, and why Session B waits.
6. Read the JSON document and its MongoDB lookup/index. Explain when embedding helps and what can become duplicated.
7. Contrast the actual local PostgreSQL/MongoDB work with the cloud architecture proposal.
8. Review the final summary against the evidence and personalize the reflection with what you understood, what surprised you, and what you would change after more testing.

## 10. Before submission

- Check the exact MIT 8103 brief and LMS announcements for course-specific weighting, report format, and required repository visibility.
- Review every SQL script and the synthetic-only data statement. Never add real student records, passwords, or tokens.
- Personalize the technical reflection; do not submit it as a first-person account without confirming that it matches your own experience.
- Check whether the lecturer needs access to the repository. If a GitHub repository is used, confirm the assessor's access method; do not assume public access is required.
- The schema execution screenshot remains optional additional evidence. The schema and seed were run and the existing evidence covers the main results, query plans, transactions, ERD, foreign keys, and MongoDB work.
- Upload the required files yourself through the LMS and verify the final submission receipt. The portfolio has not been uploaded or submitted by Codex.

## References

- [Miva grading system and grade point scale](https://support.miva.university/portal/en/kb/articles/understanding-the-grading-system-and-grade-point-scale)
- [PostgreSQL `EXPLAIN`](https://www.postgresql.org/docs/current/using-explain.html)
- [PostgreSQL warm standby and streaming replication](https://www.postgresql.org/docs/current/warm-standby.html)
- [PostgreSQL table partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
