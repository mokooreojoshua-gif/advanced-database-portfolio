# Submission checklist

## Case study and relational database
- [x] State the fictional university results portal case study and its users.
- [x] Run the PostgreSQL schema and synthetic seed data; verify the sample weighted total (82.50).
- [ ] Optional: add a schema execution screenshot if time permits. The schema and seed were run successfully; existing evidence includes the weighted result, foreign keys, and ERD.
- [x] Review grading/GPA rules against Miva's published 40/60 split, grade bands, GPA formula, and degree classifications; documented in Portfolio 1.
- [x] Prepare the labelled ER diagram and capture genuine ERD and foreign-key screenshots in `evidence/`.

## Query processing and transactions
- [x] Capture and document genuine before/after query plans, timings, and the small-data limitation.
- [x] Save screenshots of both query-plan outputs and the row-count/version evidence in `evidence/`.
- [x] Run commit, rollback, and two-session row-lock exercises; document Read Committed and the observed wait.
- [x] Restore the demo score to 25.50 after the concurrency exercise.
- [x] Save screenshots of commit/rollback, the blocked Session B, and the final isolation/value query in `evidence/`.

## NoSQL and distributed/cloud
- [x] Prepare the nested MongoDB document model and mongosh insert/read/index script.
- [x] Run a separate PostgreSQL JSONB example and document that it is not MongoDB evidence.
- [x] Run the MongoDB document insert, student/year/term lookup, and unique compound index on a local MongoDB instance through Compass; one matching document was returned.
- [x] Save screenshots of the MongoDB document, lookup result, and compound index in `evidence/`. The current document was verified with the corrected 40/60 values, but its saved screenshot is collapsed and does not show those nested values; no extra capture is being requested.
- [x] Write the distributed/cloud architecture and discuss replication, consistency, partitioning, and sharding.
- [x] Clearly state that no cloud resources, replicas, or shards were deployed.

## Report and submission
- [x] Prepare the summary draft with observed results, references, and an AI-use declaration.
- [ ] Review and approve the individual technical reflection draft; edit any wording that does not match the student's experience.
- [ ] Optional: add a PostgreSQL schema execution screenshot. Current evidence already covers the ERD, weighted result, foreign keys, transaction/concurrency, query plans, and MongoDB work; no additional screenshot is needed to continue preparing the draft.
- [x] Create the local portfolio repository and make an initial snapshot commit.
- [ ] Create a private GitHub repository, continue with progressive commits, and verify assessor access.
- [ ] Upload the required files through the LMS yourself and confirm the submission.

Never include database passwords, tokens, or live student information in the repository.




