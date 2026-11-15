# MIT 8103 Advanced Database Systems Portfolio

**Case study:** a fictional university results portal for student transcript reads, course registration, assessment scoring, and result publication. All sample identities and results are invented.

## Current progress

- **Portfolio 1 - Relational design:** PostgreSQL schema and demo seed ran successfully in `university_results_portfolio`. A query returned the sample weighted total 82.50 for MIT8103.
- **Portfolio 2 - Query optimisation:** Captured local before/after `EXPLAIN (ANALYZE, BUFFERS)` measurements. With one enrollment row, PostgreSQL chose sequential scans in both runs; the README records the observed timings and limitations.
- **Portfolio 3 - Transactions:** Demonstrated commit, rollback, and a two-session row-lock wait under Read Committed. The demo score was restored to 25.50 afterward.
- **Portfolio 4 - NoSQL:** Installed MongoDB Server 9.0.4, MongoDB Shell 2.14.2, and Compass 1.53.2 locally. Inserted the fictional term-result document through Compass, queried it by student/year/term (one match), and created the unique compound index. A separate nested JSONB query was also run in PostgreSQL; it is documented as PostgreSQL evidence only.
- The final synthetic grade example follows the published 40/60 split: CA 25.50/30 contributes 34.00 points, exam 56.58/70 contributes 48.50 points after rounding, for a displayed total of 82.50. The PostgreSQL weighted-total screenshot reflects this correction. The current MongoDB record was verified in Compass, although its saved document screenshot is collapsed and does not show the nested assessment values.
- **Portfolio 5 - Distributed/cloud:** Architecture and consistency trade-offs are documented as a proposal. No replica, shard, or cloud service was deployed.

## Files

- `portfolio-1-database-design/`
- `portfolio-2-query-optimisation/`
- `portfolio-3-transactions-concurrency/`
- `portfolio-4-nosql/`
- `portfolio-5-distributed-cloud/`
- `STUDY-GUIDE.md` - explains the schema, query, transaction, document, and distributed-system concepts and gives a review path.
- `FINAL-SUMMARY-TEMPLATE.md`
- `SUBMISSION-CHECKLIST.md`

## Academic integrity and evidence

This portfolio is a working draft. The student should review the SQL and assumptions, personalize the technical reflection, verify course-specific instructions in the LMS, and confirm assessor access before submission. A schema-execution screenshot is optional additional evidence; the implementation was run successfully and the existing screenshots are genuine local captures. Never include passwords, tokens, or live student records.
