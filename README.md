# MIT 8103 Advanced Database Systems Portfolio

**Case study:** a fictional university results portal for student transcript reads, course registration, assessment scoring, and result publication. All sample identities and results are invented.

## Current progress

- **Portfolio 1 - Relational design:** PostgreSQL schema and demo seed ran successfully in `university_results_portfolio`. A query returned the sample weighted total 82.50 for MIT8103.
- **Portfolio 2 - Query optimisation:** Captured local before/after `EXPLAIN (ANALYZE, BUFFERS)` measurements. With one enrollment row, PostgreSQL chose sequential scans in both runs; the README records the observed timings and limitations.
- **Portfolio 3 - Transactions:** Demonstrated commit, rollback, and a two-session row-lock wait under Read Committed. The demo score was restored to 25.50 afterward.
- **Portfolio 4 - NoSQL:** Installed MongoDB Server 9.0.4, MongoDB Shell 2.14.2, and Compass 1.53.2 locally. Inserted the fictional term-result document through Compass, queried it by student/year/term (one match), and created the unique compound index. A separate nested JSONB query was also run in PostgreSQL; it is documented as PostgreSQL evidence only.
- **Portfolio 5 - Distributed/cloud:** Architecture and consistency trade-offs are documented as a proposal. No replica, shard, or cloud service was deployed.

## Files

- `portfolio-1-database-design/`
- `portfolio-2-query-optimisation/`
- `portfolio-3-transactions-concurrency/`
- `portfolio-4-nosql/`
- `portfolio-5-distributed-cloud/`
- `FINAL-SUMMARY-TEMPLATE.md`
- `SUBMISSION-CHECKLIST.md`

## Academic integrity and evidence

This portfolio is a working draft. The student should verify the grading/GPA rules against the university's official policy, review the SQL, save genuine screenshots from their own PostgreSQL/MongoDB runs, complete the reflection and AI-use statement, and confirm repository access before submission. Never include passwords, tokens, or live student records.
