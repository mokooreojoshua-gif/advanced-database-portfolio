-- MIT 8103 Advanced Database Systems
-- University Results Portal - Portfolio 1 relational schema draft
-- PostgreSQL. Review and adapt before submission.

CREATE TABLE departments (
    department_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE programmes (
    programme_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id BIGINT NOT NULL REFERENCES departments(department_id),
    name VARCHAR(150) NOT NULL,
    award_level VARCHAR(40) NOT NULL,
    UNIQUE (department_id, name)
);

CREATE TABLE students (
    student_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    programme_id BIGINT NOT NULL REFERENCES programmes(programme_id),
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    admission_year SMALLINT NOT NULL CHECK (admission_year >= 2000)
);

CREATE TABLE lecturers (
    lecturer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id BIGINT NOT NULL REFERENCES departments(department_id),
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE courses (
    course_id VARCHAR(20) PRIMARY KEY,
    department_id BIGINT NOT NULL REFERENCES departments(department_id),
    title VARCHAR(160) NOT NULL,
    credit_units SMALLINT NOT NULL CHECK (credit_units > 0)
);

CREATE TABLE semesters (
    semester_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    academic_year VARCHAR(9) NOT NULL,
    term VARCHAR(20) NOT NULL CHECK (term IN ('First', 'Second', 'Summer')),
    UNIQUE (academic_year, term)
);

CREATE TABLE course_offerings (
    offering_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id VARCHAR(20) NOT NULL REFERENCES courses(course_id),
    semester_id BIGINT NOT NULL REFERENCES semesters(semester_id),
    lecturer_id BIGINT NOT NULL REFERENCES lecturers(lecturer_id),
    section_code VARCHAR(10) NOT NULL DEFAULT 'A',
    UNIQUE (course_id, semester_id, section_code),
    UNIQUE (offering_id, course_id)
);

CREATE TABLE enrollments (
    student_id BIGINT NOT NULL REFERENCES students(student_id),
    offering_id BIGINT NOT NULL REFERENCES course_offerings(offering_id),
    registered_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'Enrolled'
        CHECK (status IN ('Enrolled', 'Withdrawn', 'Completed')),
    PRIMARY KEY (student_id, offering_id)
);

CREATE TABLE assessments (
    assessment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    offering_id BIGINT NOT NULL REFERENCES course_offerings(offering_id),
    title VARCHAR(120) NOT NULL,
    max_score NUMERIC(6,2) NOT NULL CHECK (max_score > 0),
    weight_percent NUMERIC(5,2) NOT NULL
        CHECK (weight_percent > 0 AND weight_percent <= 100),
    UNIQUE (offering_id, title),
    UNIQUE (assessment_id, offering_id)
);

CREATE TABLE scores (
    student_id BIGINT NOT NULL,
    offering_id BIGINT NOT NULL,
    assessment_id BIGINT NOT NULL,
    score_value NUMERIC(6,2) NOT NULL CHECK (score_value >= 0),
    PRIMARY KEY (student_id, offering_id, assessment_id),
    FOREIGN KEY (student_id, offering_id)
        REFERENCES enrollments(student_id, offering_id),
    FOREIGN KEY (assessment_id, offering_id)
        REFERENCES assessments(assessment_id, offering_id)
);

-- Cross-table rule: a score cannot exceed its assessment's maximum.
CREATE FUNCTION enforce_score_maximum() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
    allowed_max NUMERIC(6,2);
BEGIN
    SELECT max_score INTO allowed_max
    FROM assessments
    WHERE assessment_id = NEW.assessment_id
      AND offering_id = NEW.offering_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Assessment % does not belong to offering %',
            NEW.assessment_id, NEW.offering_id;
    END IF;

    IF NEW.score_value > allowed_max THEN
        RAISE EXCEPTION 'Score % exceeds assessment maximum %',
            NEW.score_value, allowed_max;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER scores_check_assessment_maximum
BEFORE INSERT OR UPDATE OF score_value, assessment_id, offering_id ON scores
FOR EACH ROW EXECUTE FUNCTION enforce_score_maximum();

-- Helpful indexes for common roster and transcript lookups.
CREATE INDEX idx_enrollments_offering ON enrollments(offering_id);
CREATE INDEX idx_offerings_semester ON course_offerings(semester_id);
CREATE INDEX idx_scores_offering_assessment ON scores(offering_id, assessment_id);

-- Check assessment weights before publishing results; expected total is 100.
SELECT offering_id, SUM(weight_percent) AS total_weight
FROM assessments
GROUP BY offering_id
HAVING SUM(weight_percent) <> 100;

-- Check offerings that have no assessments (also need attention).
SELECT co.offering_id
FROM course_offerings AS co
LEFT JOIN assessments AS a ON a.offering_id = co.offering_id
GROUP BY co.offering_id
HAVING COUNT(a.assessment_id) = 0;
