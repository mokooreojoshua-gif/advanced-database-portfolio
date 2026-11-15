// Portfolio 4: MongoDB document-model example
// Run in mongosh after replacing the demonstration data as needed.
// This is a read-optimized term-summary document, not a replacement for
// the authoritative normalized PostgreSQL records.

use university_results_portfolio;

db.student_term_results.insertOne({
  _id: "student-1001-term-2026-27-first",
  studentId: 1001,
  academicYear: "2026/2027",
  term: "First",
  courses: [
    {
      courseId: "MIT8103",
      title: "Advanced Database Systems",
      creditUnits: 3,
      finalPercent: 82.5,
      assessments: [
        { name: "CA", score: 25.5, maxScore: 30, weightPercent: 30 },
        { name: "Examination", score: 57, maxScore: 70, weightPercent: 70 }
      ]
    }
  ]
});

// Retrieve one student's term summary.
db.student_term_results.findOne(
  { studentId: 1001, academicYear: "2026/2027", term: "First" }
);

// Useful access path for a transcript lookup.
db.student_term_results.createIndex(
  { studentId: 1, academicYear: 1, term: 1 },
  { unique: true }
);
