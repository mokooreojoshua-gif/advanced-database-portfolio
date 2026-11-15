# Portfolio 4 - NoSQL and Advanced Data Models

The example embeds a student's courses and assessment breakdown in a term-result document. This can make a term transcript read efficient because related data is retrieved together. It also duplicates course labels and derived totals; updates must be coordinated so summaries do not become stale. The normalized SQL database remains the authoritative model in this design.

Files: `sample-student-term-result.json` and `student-term-results.mongodb.js`.

The example uses fictional demonstration values only. Run it in MongoDB and capture your own output before describing it as implemented evidence.

## Model comparison and local JSON demonstration (15 November 2026)

The MongoDB example embeds a student's term and course summary so a transcript lookup can return the related courses and assessment breakdown together. This read path is simple and can use the compound key `{ studentId: 1, academicYear: 1, term: 1 }`. The trade-off is duplicated course labels and a stored `finalPercent`: changes to the source course or scores must also refresh the embedded document. The relational PostgreSQL design remains the authoritative record because its foreign keys and score constraints protect cross-record integrity and support updates across students, courses, offerings, assessments, and scores.

A separate local PostgreSQL JSONB query was run against the same fictional nested document. It returned two assessment rows for student 1001 / MIT8103 / 2026/2027 First: CA score 25.5 and Examination score 57, with the document's finalPercent 82.5. The executable query is in `postgres-jsonb-comparison.sql`. This demonstrates nested JSON access in PostgreSQL; it is not MongoDB evidence.

### Local MongoDB implementation (15 November 2026)

MongoDB Server 9.0.4, MongoDB Shell 2.14.2, and MongoDB Compass 1.53.2 were installed locally. Compass connected to `mongodb://localhost:27017`. In database `university_results_portfolio`, collection `student_term_results`, the fictional document in `sample-student-term-result.json` was inserted. A filter on `studentId: 1001`, `academicYear: "2026/2027"`, and `term: "First"` returned one document. The collection also has a unique ascending compound index on `{ studentId: 1, academicYear: 1, term: 1 }`.

The same operations are represented in `student-term-results.mongodb.js`; they were carried out in Compass rather than by running that script in the shell. Save screenshots of the connected collection, query result, and index before submission. The local MongoDB evidence is separate from the PostgreSQL JSONB comparison above.
