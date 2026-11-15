-- Portfolio 2: University Results Portal queries (PostgreSQL)
-- Do not report timings until you run this on a documented dataset.

-- Q1. Course results for one student. Only complete offerings whose
-- assessment weights total 100 and for which every assessment has a score.
-- Change 1001 to a student_id present in your own synthetic dataset.
WITH offering_results AS (
    SELECT
        e.student_id,
        co.offering_id,
        c.course_id,
        c.title AS course_title,
        s.academic_year,
        s.term,
        SUM((sc.score_value / a.max_score) * a.weight_percent) AS final_percent,
        COUNT(DISTINCT a.assessment_id) AS assessment_count,
        COUNT(sc.assessment_id) AS recorded_score_count,
        SUM(a.weight_percent) AS total_weight
    FROM enrollments AS e
    JOIN course_offerings AS co ON co.offering_id = e.offering_id
    JOIN courses AS c ON c.course_id = co.course_id
    JOIN semesters AS s ON s.semester_id = co.semester_id
    JOIN assessments AS a ON a.offering_id = co.offering_id
    LEFT JOIN scores AS sc
      ON sc.student_id = e.student_id
     AND sc.offering_id = e.offering_id
     AND sc.assessment_id = a.assessment_id
    WHERE e.student_id = 1001
      AND e.status IN ('Enrolled', 'Completed')
    GROUP BY e.student_id, co.offering_id, c.course_id, c.title,
             s.academic_year, s.term
)
SELECT student_id, academic_year, term, course_id, course_title,
       ROUND(final_percent, 2) AS final_percent
FROM offering_results
WHERE assessment_count = recorded_score_count
  AND total_weight = 100
ORDER BY academic_year, term, course_id;

-- Q2. Class roster and enrollment count for one offering.
SELECT co.offering_id, c.course_id, c.title,
       COUNT(*) FILTER (WHERE e.status = 'Enrolled') AS active_students
FROM course_offerings AS co
JOIN courses AS c ON c.course_id = co.course_id
LEFT JOIN enrollments AS e ON e.offering_id = co.offering_id
GROUP BY co.offering_id, c.course_id, c.title
ORDER BY c.course_id;

-- Q3. Before/after plan investigation for Q2.
-- Remove the schema index for the baseline, save the actual plan and note
-- dataset row counts. Then add the index, run ANALYZE, and capture again.
-- Small datasets may correctly use a sequential scan; explain what you observe.
DROP INDEX IF EXISTS idx_enrollments_offering;
ANALYZE enrollments;

EXPLAIN (ANALYZE, BUFFERS)
SELECT student_id, status
FROM enrollments
WHERE offering_id = 1;

-- Recreate the index after the baseline plan for the comparison.
CREATE INDEX IF NOT EXISTS idx_enrollments_offering
    ON enrollments(offering_id);
ANALYZE enrollments;

-- Re-run the EXPLAIN above and compare real plans and timings.
-- Add screenshots/output and environment details to README.md.


