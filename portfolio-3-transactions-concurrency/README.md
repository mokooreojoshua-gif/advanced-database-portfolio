# Portfolio 3 - Transactions and Concurrency

`transactions-concurrency.sql` contains commit, rollback, and two-session row-lock exercises.

Record the PostgreSQL isolation level, session order, which statement waited, and what values were visible before and after commit. Capture genuine output from two pgAdmin sessions. The sample identifiers are placeholders; replace them with rows in your dataset.

## Local PostgreSQL run (15 November 2026)

- Environment: PostgreSQL 18.7, pgAdmin 4, database `university_results_portfolio`; two Query Tool sessions were used for the concurrency exercise.
- Isolation level observed with `current_setting('transaction_isolation')`: `read committed`.
- Commit exercise: changed the invented CA score from 25.50 to 28.00 inside a transaction and committed; the following rollback exercise attempted 29.00 then rolled back. The persisted value remained 28.00.
- Concurrency order: Session A began a transaction, selected the score row `FOR UPDATE`, and changed it to 28.50 without committing. Session B began an update of the same row to 29.50 and visibly waited. Session A committed; Session B's update then completed after about 7.344 seconds and was committed. This demonstrates row locking serializing conflicting writes under Read Committed.
- Cleanup: restored the synthetic CA score to its original 25.50 and verified it. The final weighted demo result therefore remains 82.50.
- Evidence still needed for submission: save screenshots showing the commit/rollback values, Session B waiting, its completion after Session A commit, and the isolation/result check. Do not present the timing as a general performance measure; it is the observed wait in this local session.
