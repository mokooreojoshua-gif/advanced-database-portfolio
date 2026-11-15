-- Portfolio 3: Transactions and concurrency exercise
-- Run each labeled session in a separate pgAdmin Query Tool window.
-- Replace IDs with rows that exist in your local synthetic data.

-- Exercise A: commit a valid score correction (Session A)
BEGIN;
UPDATE scores
SET score_value = 28.00
WHERE student_id = 1001
  AND offering_id = 1
  AND assessment_id = 1;
-- Inspect the affected row in this session before committing.
COMMIT;

-- Exercise B: demonstrate rollback (Session A)
BEGIN;
UPDATE scores
SET score_value = 29.00
WHERE student_id = 1001
  AND offering_id = 1
  AND assessment_id = 1;
-- The correction is intentionally discarded:
ROLLBACK;

-- Concurrency exercise, step 1 (Session A): acquire a row lock and keep the
-- transaction open while performing step 2 in Session B.
BEGIN;
SELECT score_value
FROM scores
WHERE student_id = 1001 AND offering_id = 1 AND assessment_id = 1
FOR UPDATE;
UPDATE scores
SET score_value = 28.50
WHERE student_id = 1001 AND offering_id = 1 AND assessment_id = 1;
-- Leave this transaction open temporarily while Session B attempts its update.
-- After observing the wait, return here and COMMIT.

-- Concurrency exercise, step 2 (Session B; run only after Session A is open)
-- This update should wait for Session A's row lock. Capture the behavior.
BEGIN;
UPDATE scores
SET score_value = 29.50
WHERE student_id = 1001 AND offering_id = 1 AND assessment_id = 1;
-- Once Session A commits, this statement can proceed. Then:
COMMIT;

-- Explain the observed blocking and how the row lock serialized the writes.
-- Capture actual output/screenshots; do not claim a result you did not observe.

