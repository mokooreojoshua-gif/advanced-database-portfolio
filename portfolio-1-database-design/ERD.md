# ER model - University Results Portal

```mermaid
erDiagram
    DEPARTMENT ||--o{ PROGRAMME : offers
    PROGRAMME ||--o{ STUDENT : includes
    DEPARTMENT ||--o{ LECTURER : employs
    DEPARTMENT ||--o{ COURSE : owns
    COURSE ||--o{ COURSE_OFFERING : scheduled_as
    SEMESTER ||--o{ COURSE_OFFERING : contains
    LECTURER ||--o{ COURSE_OFFERING : teaches
    COURSE_OFFERING ||--o{ ENROLLMENT : has
    STUDENT ||--o{ ENROLLMENT : registers
    COURSE_OFFERING ||--o{ ASSESSMENT : includes
    ENROLLMENT ||--o{ SCORE : receives
    ASSESSMENT ||--o{ SCORE : records
```

## Relationship notes
- A course offering is one delivery of a course in a semester and section.
- Enrollment links one student to one offering; the pair is unique.
- Assessment belongs to one offering. Score connects an enrolled student and an assessment within the same offering.
- This model can calculate weighted results from the score records. It does not yet encode the university's grade bands or GPA rules.
