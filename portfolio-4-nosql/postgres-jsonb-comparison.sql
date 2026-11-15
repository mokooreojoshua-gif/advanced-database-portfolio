-- PostgreSQL JSONB comparison for the NoSQL portfolio.
-- This demonstrates a nested term-result document in PostgreSQL only;
-- it is not a MongoDB execution or replacement for the mongosh exercise.
WITH term_result AS (
    SELECT '{
      "studentId": 1001,
      "academicYear": "2026/2027",
      "term": "First",
      "courses": [{
        "courseId": "MIT8103",
        "title": "Advanced Database Systems",
        "creditUnits": 3,
        "finalPercent": 82.5,
        "assessments": [
          {"name": "CA", "score": 25.5, "maxScore": 30, "weightPercent": 40},
          {"name": "Examination", "score": 56.58, "maxScore": 70, "weightPercent": 60}
        ]
      }]
    }'::jsonb AS doc
)
SELECT
    doc->>'studentId' AS student_id,
    doc->>'academicYear' AS academic_year,
    doc->>'term' AS term,
    course->>'courseId' AS course_id,
    course->>'title' AS course_title,
    (course->>'finalPercent')::numeric AS final_percent,
    assessment->>'name' AS assessment_name,
    (assessment->>'score')::numeric AS score
FROM term_result
CROSS JOIN LATERAL jsonb_array_elements(doc->'courses') AS course
CROSS JOIN LATERAL jsonb_array_elements(course->'assessments') AS assessment
ORDER BY assessment->>'name';

