# Portfolio 2 - Query Processing and Optimisation

## Queries
`queries.sql` contains a transcript query, an offering roster summary, and a plan-capture exercise.

## Local PostgreSQL run and recapture (15 November 2026)

- Environment: PostgreSQL 18.7, x86_64 Windows, database `university_results_portfolio`.
- Dataset: `enrollments` = 1 row; `scores` = 2 rows.
- Query: `SELECT student_id, status FROM enrollments WHERE offering_id = 1` with `EXPLAIN (ANALYZE, BUFFERS)`.
- Baseline: dropped `idx_enrollments_offering`, ran `ANALYZE enrollments`, and repeated the query. PostgreSQL chose a sequential scan, returning 1 row. Captured plan: node actual time 0.019–0.020 ms, planning time 0.523 ms, execution time 0.044 ms, shared buffer hit=1; planning used shared hit=15 and dirtied=1.
- After index: recreated `idx_enrollments_offering ON enrollments(offering_id)`, ran `ANALYZE enrollments`, and repeated the query. PostgreSQL still chose a sequential scan, returning 1 row. Captured plan: node actual time 0.021–0.022 ms, planning time 0.595 ms, execution time 0.038 ms, shared buffer hit=1; planning used shared hit=26.
- Interpretation: on this one-row table, PostgreSQL preferred scanning the table even with the index. The observed execution time differed by only a few thousandths of a millisecond across repeated captures, so it is not evidence of a meaningful performance improvement. A larger representative synthetic dataset is needed to evaluate index benefit.
- The index was recreated and remains available in the final database state.

## Evidence
- `../evidence/MIT8103-07-PostgreSQL-Baseline-Plan.png`
- `../evidence/MIT8103-08-PostgreSQL-After-Index-Plan.png`
- `../evidence/MIT8103-06-PostgreSQL-Query-Plan.png` is an additional example using a different filter (`student_id = 1001`); it is not the before/after comparison above.

Never enter estimated or invented timings. These are local measurements from this run, not general performance claims.
