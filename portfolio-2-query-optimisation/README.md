# Portfolio 2 - Query Processing and Optimisation

## Queries
`queries.sql` contains a transcript query, an offering roster summary, and a plan-capture exercise.

## Record from your own run
- PostgreSQL version:
- Dataset size (rows per relevant table):
- Query used:
- Before-index plan and actual time:
- After-index plan and actual time:
- Observed change and explanation:

Do not enter estimated or invented timings. PostgreSQL may choose a sequential scan for a small table; explain the measured plan rather than assuming an index must be used.

## Local PostgreSQL run (15 November 2026)

- Environment: PostgreSQL 18.7, x86_64 Windows, 64-bit; database `university_results_portfolio`.
- Dataset used for this experiment: `enrollments` = 1 row; `scores` = 2 rows.
- Query: `SELECT student_id, status FROM enrollments WHERE offering_id = 1` with `EXPLAIN (ANALYZE, BUFFERS)`.
- Baseline: dropped `idx_enrollments_offering`, ran `ANALYZE enrollments`, then explained the query. PostgreSQL chose a sequential scan. It returned 1 row; node actual time 0.025–0.026 ms, planning time 0.689 ms, execution time 0.042 ms, shared buffer hit=1.
- After index: recreated `idx_enrollments_offering ON enrollments(offering_id)`, ran `ANALYZE enrollments`, then repeated the same query. PostgreSQL still chose a sequential scan. It returned 1 row; node actual time 0.029–0.030 ms, planning time 0.271 ms, execution time 0.051 ms, shared buffer hit=1.
- Interpretation: the index did not improve this one-row workload, and the measured execution time was slightly higher on the second run. This is not evidence that the index is harmful: the table is too small for a stable comparison, and timing variation at sub-millisecond scale is expected. PostgreSQL correctly preferred scanning the tiny table. A larger, representative synthetic dataset is needed to assess index benefit.
- The index was recreated after the baseline and remains available for the final database state.
- Evidence to capture for submission: screenshots of both `EXPLAIN (ANALYZE, BUFFERS)` outputs and the row-count/version query. These are local measurements from this run, not general performance claims.
