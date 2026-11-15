# MIT 8103 Advanced Database Systems: University Results Portal

**Working summary draft - add your name and personalize the reflection before submission**  
**Student:** Oluwasola Mokoore Joshua  
**Student email:** m.oluwasola1098@miva.edu.ng  
**Date:** 15 November 2026

## Case study and purpose

This portfolio models a fictional university results portal used by students, lecturers, and academic administrators. Students need to view course results and term summaries. Lecturers submit assessment scores. Administrators maintain programmes, course offerings, registrations, and result publication. Because assessment records affect academic progression, the design prioritizes reliable relationships, validation, and controlled score changes. All names, email addresses, identifiers, and marks used in the sample are invented.

The work uses PostgreSQL as the relational system of record. A local PostgreSQL 18.7 database named `university_results_portfolio` was created. Its schema includes departments, programmes, students, lecturers, courses, semesters, course offerings, enrollments, assessments, and scores. Primary keys identify records; foreign keys connect the related academic entities; uniqueness and check constraints reject inconsistent values such as duplicate email addresses or nonpositive course credits. The schema and synthetic seed scripts ran successfully. The seed uses the published 40% continuous-assessment / 60% examination split. A weighted-result query returned 82.50 for the invented Amina Demo record in MIT8103. Under Miva's published five-point scale, that synthetic mark maps to A (5 points); it is not an official student grade. GPA is calculated as total quality points divided by total registered credit units. [Miva grading and GPA guidance](https://support.miva.university/portal/en/kb/articles/understanding-the-grading-system-and-grade-point-scale).

## Query processing and optimisation

The query portfolio includes a student's term results and an offering roster. For the measured index exercise, the same filter query was explained before and after creating `idx_enrollments_offering` on `enrollments(offering_id)`. The measured dataset had only one enrollment row and two score rows. Without the index PostgreSQL chose a sequential scan, with a reported execution time of 0.042 ms. After the index was created and the table analyzed, PostgreSQL still chose a sequential scan, with a reported execution time of 0.051 ms. These sub-millisecond values are the observed local results, not a general benchmark. Since the table contained only one row, the index could not provide a meaningful performance gain; PostgreSQL's scan choice was appropriate. A larger representative dataset would be needed to assess index benefit. The plan details and caveats are recorded in the Portfolio 2 README. PostgreSQL's `EXPLAIN` documentation describes how to inspect chosen plans and actual execution statistics.

## Transactions and concurrency

The transaction exercise used two pgAdmin Query Tool sessions and PostgreSQL's observed `read committed` isolation level. In the commit example, the sample continuous-assessment score was changed from 25.50 to 28.00 and committed. A later attempted change to 29.00 was rolled back, leaving 28.00 persisted.

For the concurrency exercise, Session A selected the score row `FOR UPDATE` and changed it to 28.50 while leaving its transaction open. Session B attempted to update that same row to 29.50 and waited. After Session A committed, Session B's update completed after about 7.344 seconds and was then committed. This demonstrated how a row lock serializes conflicting writes. The original sample score was restored to 25.50 after the exercise, so the weighted demo result remained 82.50. The observed isolation level, order of operations, and wait are described in the Portfolio 3 README.

## NoSQL and advanced data models

A MongoDB term-result document embeds a student's courses and assessment breakdown in one document. This can serve a transcript read efficiently because related information is returned together. It duplicates course labels and stores a derived final percentage, however, so changes to source scores or course details would need to update the embedded summary as well. MongoDB Server 9.0.4, MongoDB Shell 2.14.2, and Compass 1.53.2 were installed locally. Compass connected to `mongodb://localhost:27017`; the fictional document was inserted into `university_results_portfolio.student_term_results`, and a filter for student 1001 / 2026/2027 / First returned one match. A unique ascending compound index on student ID, academic year, and term was created. The final synthetic document uses the 40% CA / 60% exam split: CA 25.50/30 and exam 56.58/70 produce 82.50 after rounding. PostgreSQL remains the authoritative model in this design because its relational constraints help maintain consistency among the underlying academic records.

A separate PostgreSQL JSONB query was also run against the same nested fictional document and returned the CA and examination rows with the stored 82.5 total. This is evidence of PostgreSQL JSON handling only. The MongoDB insert, lookup, and index were carried out through Compass rather than by running the `.js` script in `mongosh`; the script remains as the repeatable command-line version. The two implementations should not be represented as interchangeable.

## Distributed and cloud design

The proposed architecture has one PostgreSQL primary for grade writes and immediate confirmations, a warm standby for ordinary transcript reads, and separate encrypted backups for recovery. With asynchronous replication, a recent write may not yet be visible on the standby, so reads that must immediately reflect a score update should go to the primary. Synchronous replication can reduce the risk of losing acknowledged writes but may add latency and depend on the standby's availability. PostgreSQL documents these streaming-replication trade-offs in its [warm standby guidance](https://www.postgresql.org/docs/current/warm-standby.html).

Read replicas are the first proposed scaling step for periods when transcript traffic rises. Table partitioning by academic year or semester may help manage a very large scores table, while sharding across separate servers should be considered only if a primary, replicas, and partitioning cannot meet the workload. PostgreSQL's [partitioning documentation](https://www.postgresql.org/docs/current/ddl-partitioning.html) distinguishes partitioned tables within a database from distribution across independent nodes. No replica, shard, or cloud service was deployed for this portfolio; this section is an architecture proposal only.

## Technical reflection - personalize before submitting

The plan comparison showed me that adding an index does not automatically make every query faster. With a one-row table, PostgreSQL correctly kept the sequential scan, and the tiny timing difference was too small to support a broad claim. The transaction exercise made the effect of a row lock concrete: the second update could not proceed until the first transaction committed. I also saw the value of resetting the synthetic score after experimenting, so the original example remained consistent. Finally, the relational and document examples highlighted a trade-off between enforcing consistency across related records and returning a pre-assembled transcript quickly. Before submitting, I will personalize this reflection and verify any course-specific instructions in the LMS.

## Evidence, references, and AI-use declaration

The SQL, schema, document example, measurements, and architecture files are included in the accompanying portfolio folders. Screenshots of PostgreSQL results, transaction exercises, ERD, foreign keys, and MongoDB document, lookup, and index are in the `evidence/` folder. The PostgreSQL schema execution screenshot is optional additional evidence; the schema and seed were run successfully. No cloud deployment was required or performed. The distributed design references the official PostgreSQL documentation linked above. Query-plan interpretation used PostgreSQL's [`EXPLAIN` documentation](https://www.postgresql.org/docs/current/using-explain.html).

**AI use:** OpenAI Codex was used to help draft SQL, the MongoDB document example, the architecture discussion, and this summary; to guide operation of local PostgreSQL and MongoDB Compass; and to interpret query plans and transaction behavior. The schema and demo seed were run locally, and the PostgreSQL query, transaction, JSONB, and MongoDB outcomes stated above were observed in pgAdmin or Compass. No cloud deployment was performed. The student should review all generated work, correct it to match course and university requirements, and personalize this reflection before submission.



