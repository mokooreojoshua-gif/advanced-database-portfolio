# Submission checklist

## Case study and relational database
- [x] State the fictional university results portal case study and its users.
- [x] Run the PostgreSQL schema and synthetic seed data; verify the sample weighted total (82.50).
- [ ] Save screenshots of schema execution and the verification result.
- [ ] Review grading/GPA rules against the university's official policy.
- [ ] Export or render the labelled ER diagram and capture foreign-key evidence.

## Query processing and transactions
- [x] Capture and document genuine before/after query plans, timings, and the small-data limitation.
- [ ] Save screenshots of both query-plan outputs and the row-count/version evidence.
- [x] Run commit, rollback, and two-session row-lock exercises; document Read Committed and the observed wait.
- [x] Restore the demo score to 25.50 after the concurrency exercise.
- [ ] Save screenshots of commit/rollback, the blocked Session B, and the final isolation/value query.

## NoSQL and distributed/cloud
- [x] Prepare the nested MongoDB document model and mongosh insert/read/index script.
- [x] Run a separate PostgreSQL JSONB example and document that it is not MongoDB evidence.
- [x] Run the MongoDB document insert, student/year/term lookup, and unique compound index on a local MongoDB instance through Compass; one matching document was returned.
- [ ] Save screenshots of the MongoDB document, lookup result, and compound index.
- [x] Write the distributed/cloud architecture and discuss replication, consistency, partitioning, and sharding.
- [x] Clearly state that no cloud resources, replicas, or shards were deployed.

## Report and submission
- [x] Prepare the summary draft with observed results, references, and an AI-use declaration.
- [ ] Add the student's name and personalize/review the individual technical reflection.
- [ ] Save screenshots of PostgreSQL schema/results, query plans, transactions/concurrency, and MongoDB document/query/index evidence.
- [x] Create the local portfolio repository and make an initial snapshot commit.
- [ ] Create a private GitHub repository, continue with progressive commits, and verify assessor access.
- [ ] Upload the required files through the LMS yourself and confirm the submission.

Never include database passwords, tokens, or live student information in the repository.
