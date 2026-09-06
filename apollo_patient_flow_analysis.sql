-- ============================================================
-- PROJECT: Apollo Hospitals Patient Flow Analysis
-- DOMAIN: Healthcare Analytics / Hospital Operations
-- DATABASE: apollo_patient_flow
-- TOOL: MySQL
--
-- OBJECTIVE:
-- Analyze patient admissions, waiting times, length of stay,
-- readmissions, bed utilization, and operational bottlenecks.
--
-- DATASET:
-- Synthetic educational dataset provided for SQL analysis.
-- ============================================================


USE apollo_patient_flow;


-- ============================================================
-- QUESTION 1: DATABASE EXPLORATION
-- Explore database tables and understand the schema.
-- ============================================================

SHOW TABLES;

DESCRIBE hospitals;
DESCRIBE departments;
DESCRIBE patients;
DESCRIBE doctors;
DESCRIBE admissions;
DESCRIBE bed_occupancy;


-- ============================================================
-- QUESTION 2: HOSPITAL ADMISSION ANALYSIS
-- Calculate admissions handled by each hospital and identify
-- the hospital with the highest number of admissions.
-- ============================================================

SELECT
    h.hospital_name,
    COUNT(a.admission_id) AS total_admissions
FROM hospitals h
JOIN admissions a
    ON h.hospital_id = a.hospital_id
GROUP BY
    h.hospital_id,
    h.hospital_name
ORDER BY total_admissions DESC;


-- Hospital with highest admissions

SELECT
    h.hospital_name,
    COUNT(a.admission_id) AS total_admissions
FROM hospitals h
JOIN admissions a
    ON h.hospital_id = a.hospital_id
GROUP BY
    h.hospital_id,
    h.hospital_name
ORDER BY total_admissions DESC
LIMIT 1;


-- ============================================================
-- QUESTION 3: DEPARTMENT PERFORMANCE
-- Calculate total admissions for each department and identify
-- the Top 5 departments by patient volume.
-- ============================================================

SELECT
    h.hospital_name,
    d.department_id,
    d.department_name,
    COUNT(a.admission_id) AS total_admissions
FROM departments d
JOIN hospitals h
    ON d.hospital_id = h.hospital_id
JOIN admissions a
    ON d.department_id = a.department_id
GROUP BY
    h.hospital_name,
    d.department_id,
    d.department_name
ORDER BY total_admissions DESC;

-- Top 5 departments by patient volume

SELECT
    h.hospital_name,
    d.department_id,
    d.department_name,
    COUNT(a.admission_id) AS total_admissions
FROM departments d
JOIN hospitals h
    ON d.hospital_id = h.hospital_id
JOIN admissions a
    ON d.department_id = a.department_id
GROUP BY
    h.hospital_name,
    d.department_id,
    d.department_name
ORDER BY total_admissions DESC
LIMIT 5;


-- ============================================================
-- QUESTION 4: PATIENT WAITING TIME
-- Calculate average, minimum, and maximum patient waiting time
-- for each department and identify the department with the
-- highest average waiting time.
-- ============================================================

SELECT
    h.hospital_name,
    d.department_name,
    MIN(a.wait_time_minutes) AS min_wait_time,
    MAX(a.wait_time_minutes) AS max_wait_time,
    ROUND(AVG(a.wait_time_minutes), 2) AS avg_wait_time
FROM departments d
JOIN hospitals h
    ON d.hospital_id = h.hospital_id
JOIN admissions a
    ON d.department_id = a.department_id
GROUP BY
    d.department_id,
    h.hospital_name,
    d.department_name
ORDER BY avg_wait_time DESC;

-- Department with highest average waiting time

SELECT
    h.hospital_name,
    d.department_name,
    MIN(a.wait_time_minutes) AS min_wait_time,
    MAX(a.wait_time_minutes) AS max_wait_time,
    ROUND(AVG(a.wait_time_minutes), 2) AS avg_wait_time
FROM departments d
JOIN hospitals h
    ON d.hospital_id = h.hospital_id
JOIN admissions a
    ON d.department_id = a.department_id
GROUP BY
    d.department_id,
    h.hospital_name,
    d.department_name
ORDER BY avg_wait_time DESC
LIMIT 1;


-- ============================================================
-- QUESTION 5: WAITING-TIME BOTTLENECKS
-- Classify patients into waiting-time categories and identify
-- the department with the highest number of Critical cases.
-- ============================================================

SELECT
    h.hospital_name,
    d.department_name,

    CASE
        WHEN a.wait_time_minutes < 30 THEN 'Low'
        WHEN a.wait_time_minutes < 60 THEN 'Moderate'
        WHEN a.wait_time_minutes < 90 THEN 'High'
        ELSE 'Critical'
    END AS waiting_time_category,

    COUNT(*) AS total_patient_count

FROM admissions a

JOIN departments d
    ON a.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

GROUP BY
    h.hospital_name,
    d.department_id,
    d.department_name,
    waiting_time_category

ORDER BY
    h.hospital_name,
    d.department_name,
    total_patient_count DESC;


-- Department with highest Critical waiting-time cases

SELECT
    h.hospital_name,
    d.department_name,
    COUNT(*) AS critical_cases
FROM admissions a
JOIN departments d
    ON a.department_id = d.department_id
JOIN hospitals h
    ON d.hospital_id = h.hospital_id
WHERE a.wait_time_minutes >= 90
GROUP BY
    h.hospital_name,
    d.department_id,
    d.department_name
ORDER BY critical_cases DESC
LIMIT 1;


-- ============================================================
-- QUESTION 6: LENGTH OF STAY ANALYSIS
-- Calculate average length of stay for each department and
-- identify the department with the longest average stay.
-- ============================================================

SELECT
    h.hospital_name,
    d.department_name,

    ROUND(
        AVG(
            DATEDIFF(
                a.discharge_date,
                a.admission_date
            )
        ),
        2
    ) AS avg_length_of_stay

FROM admissions a

JOIN departments d
    ON a.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

WHERE a.discharge_date IS NOT NULL

GROUP BY
    d.department_id,
    h.hospital_name,
    d.department_name

ORDER BY avg_length_of_stay DESC;


-- Department with longest average length of stay

SELECT
    h.hospital_name,
    d.department_name,

    ROUND(
        AVG(
            DATEDIFF(
                a.discharge_date,
                a.admission_date
            )
        ),
        2
    ) AS avg_length_of_stay

FROM admissions a

JOIN departments d
    ON a.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

WHERE a.discharge_date IS NOT NULL

GROUP BY
    d.department_id,
    h.hospital_name,
    d.department_name

ORDER BY avg_length_of_stay DESC
LIMIT 1;



-- ============================================================
-- QUESTION 7: READMISSION RATE ANALYSIS
-- Calculate overall hospital readmission rate and compare
-- readmission rates across departments.
-- ============================================================

-- Overall hospital readmission rate


SELECT
    ROUND(
        AVG(readmission_flag) * 100,
        2
    ) AS overall_readmission_rate
FROM admissions;


-- Department-wise readmission rate

SELECT
    h.hospital_name,
    d.department_name,

    COUNT(a.admission_id) AS total_admissions,

    SUM(a.readmission_flag) AS readmitted_patients,

    ROUND(
        AVG(a.readmission_flag) * 100,
        2
    ) AS readmission_rate

FROM admissions a

JOIN departments d
    ON a.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

GROUP BY
    d.department_id,
    h.hospital_name,
    d.department_name

ORDER BY readmission_rate DESC;



-- ============================================================
-- QUESTION 8: PATIENT READMISSION ANALYSIS
-- Identify patients admitted multiple times and rank them
-- based on total number of admissions.
-- ============================================================

SELECT
    p.patient_name,
    COUNT(a.admission_id) AS total_admissions,

    RANK() OVER (
        ORDER BY COUNT(a.admission_id) DESC
    ) AS admission_rank

FROM patients p
JOIN admissions a
    ON p.patient_id = a.patient_id

GROUP BY
    p.patient_id,
    p.patient_name

HAVING COUNT(a.admission_id) > 1

ORDER BY
    total_admissions DESC;


-- ============================================================
-- QUESTION 9: BED UTILIZATION ANALYSIS
-- Calculate bed utilization percentage for each department
-- and identify departments with Critical utilization above 90%.
-- ============================================================

-- Department-wise bed utilization

SELECT
    h.hospital_name,
    d.department_name,

    ROUND(
        AVG(
            (bo.occupied_beds / d.total_beds) * 100
        ),
        2
    ) AS bed_utilization_percentage

FROM bed_occupancy bo

JOIN departments d
    ON bo.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

WHERE d.total_beds > 0

GROUP BY
    d.department_id,
    h.hospital_name,
    d.department_name

ORDER BY bed_utilization_percentage DESC;

-- Departments with Critical utilization above 90%

SELECT
    h.hospital_name,
    d.department_name,

    ROUND(
        AVG(
            (bo.occupied_beds / d.total_beds) * 100
        ),
        2
    ) AS bed_utilization_percentage

FROM bed_occupancy bo

JOIN departments d
    ON bo.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

WHERE d.total_beds > 0

GROUP BY
    d.department_id,
    h.hospital_name,
    d.department_name

HAVING bed_utilization_percentage > 90

ORDER BY bed_utilization_percentage DESC;


-- ============================================================
-- QUESTION 10: HOSPITAL AND DEPARTMENT ANALYSIS USING JOINS
-- Create a department-level report containing hospital name,
-- department name, total beds, total admissions, average
-- waiting time, and average bed utilization.
-- ============================================================

WITH admission_metrics AS (
    SELECT
        department_id,
        COUNT(admission_id) AS total_admissions,
        ROUND(AVG(wait_time_minutes), 2) AS avg_wait_time
    FROM admissions
    GROUP BY department_id
),

bed_metrics AS (
    SELECT
        bo.department_id,
        ROUND(
            AVG(
                bo.occupied_beds / d.total_beds * 100
            ),
            2
        ) AS avg_bed_utilization
    FROM bed_occupancy bo
    JOIN departments d
        ON bo.department_id = d.department_id
    WHERE d.total_beds > 0
    GROUP BY bo.department_id
)

SELECT
    h.hospital_name,
    d.department_name,
    d.total_beds,
    am.total_admissions,
    am.avg_wait_time,
    bm.avg_bed_utilization

FROM departments d

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

LEFT JOIN admission_metrics am
    ON d.department_id = am.department_id

LEFT JOIN bed_metrics bm
    ON d.department_id = bm.department_id

ORDER BY am.total_admissions DESC;


-- ============================================================
-- QUESTION 11: HIGH-PERFORMING AND LOW-PERFORMING DEPARTMENTS
-- USING SUBQUERIES
-- Identify departments whose average waiting time is higher
-- than the overall hospital average waiting time.
-- ============================================================

SELECT
    h.hospital_name,
    d.department_name,
    ROUND(AVG(a.wait_time_minutes), 2) AS department_avg_wait_time

FROM admissions a

JOIN departments d
    ON a.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

GROUP BY
    d.department_id,
    h.hospital_name,
    d.department_name

HAVING AVG(a.wait_time_minutes) > (
    SELECT AVG(wait_time_minutes)
    FROM admissions
)

ORDER BY department_avg_wait_time DESC;

-- ============================================================
-- QUESTION 12: DEPARTMENT PERFORMANCE USING CTE
-- Calculate department-level admission volume, average waiting
-- time, average length of stay, and readmission rate.
-- Identify departments requiring operational attention.
-- ============================================================

WITH department_performance AS (

    SELECT
        h.hospital_name,
        d.department_name,

        COUNT(a.admission_id) AS total_admissions,

        ROUND(
            AVG(a.wait_time_minutes),
            2
        ) AS avg_wait_time,

        ROUND(
            AVG(
                DATEDIFF(
                    a.discharge_date,
                    a.admission_date
                )
            ),
            2
        ) AS avg_length_of_stay,

        ROUND(
            AVG(a.readmission_flag) * 100,
            2
        ) AS readmission_rate

    FROM departments d

    JOIN hospitals h
        ON d.hospital_id = h.hospital_id

    JOIN admissions a
        ON d.department_id = a.department_id

    GROUP BY
        d.department_id,
        h.hospital_name,
        d.department_name
)

SELECT
    *,

    CASE
        WHEN avg_wait_time > 80
          OR readmission_rate > 70
          OR avg_length_of_stay > 5
        THEN 'Requires Attention'

        ELSE 'Normal'
    END AS operational_status

FROM department_performance

ORDER BY
    avg_wait_time DESC,
    readmission_rate DESC;

--- ============================================================
-- QUESTION 13: DEPARTMENT RANKING USING WINDOW FUNCTIONS
-- Rank departments based on average waiting time,
-- readmission rate, and bed utilization.
-- ============================================================

WITH department_metrics AS (

    SELECT
        d.department_id,
        h.hospital_name,
        d.department_name,

        ROUND(AVG(a.wait_time_minutes), 2) AS avg_wait_time,

        ROUND(
            AVG(a.readmission_flag) * 100,
            2
        ) AS readmission_rate

    FROM departments d

    JOIN hospitals h
        ON d.hospital_id = h.hospital_id

    JOIN admissions a
        ON d.department_id = a.department_id

    GROUP BY
        d.department_id,
        h.hospital_name,
        d.department_name
),

bed_metrics AS (

    SELECT
        bo.department_id,

        ROUND(
            AVG(
                (bo.occupied_beds / d.total_beds) * 100
            ),
            2
        ) AS bed_utilization

    FROM bed_occupancy bo

    JOIN departments d
        ON bo.department_id = d.department_id

    WHERE d.total_beds > 0

    GROUP BY bo.department_id
)

SELECT
    dm.hospital_name,
    dm.department_name,
    dm.avg_wait_time,
    dm.readmission_rate,
    bm.bed_utilization,

    RANK() OVER (
        ORDER BY dm.avg_wait_time DESC
    ) AS waiting_time_rank,

    RANK() OVER (
        ORDER BY dm.readmission_rate DESC
    ) AS readmission_rank,

    RANK() OVER (
        ORDER BY bm.bed_utilization DESC
    ) AS bed_utilization_rank

FROM department_metrics dm

JOIN bed_metrics bm
    ON dm.department_id = bm.department_id

ORDER BY waiting_time_rank;


-- ============================================================
-- QUESTION 14: PATIENT-FLOW BOTTLENECK ANALYSIS
-- Combine waiting time, length of stay, readmission rate,
-- and bed utilization to identify Top 5 departments with
-- the greatest patient-flow bottlenecks.
-- ============================================================

WITH admission_metrics AS (

    SELECT
        department_id,

        ROUND(AVG(wait_time_minutes), 2) AS avg_wait_time,

        ROUND(
            AVG(
                DATEDIFF(discharge_date, admission_date)
            ),
            2
        ) AS avg_length_of_stay,

        ROUND(
            AVG(readmission_flag) * 100,
            2
        ) AS readmission_rate

    FROM admissions

    GROUP BY department_id
),

bed_metrics AS (

    SELECT
        bo.department_id,

        ROUND(
            AVG(
                (bo.occupied_beds / bo.available_beds) * 100
            ),
            2
        ) AS bed_utilization

    FROM bed_occupancy bo

    WHERE bo.available_beds > 0

    GROUP BY bo.department_id
)

SELECT
    h.hospital_name,
    d.department_name,
    am.avg_wait_time,
    am.avg_length_of_stay,
    am.readmission_rate,
    bm.bed_utilization,

    ROUND(
        am.avg_wait_time
        + (am.avg_length_of_stay * 10)
        + am.readmission_rate
        + bm.bed_utilization,
        2
    ) AS bottleneck_score

FROM departments d

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

JOIN admission_metrics am
    ON d.department_id = am.department_id

JOIN bed_metrics bm
    ON d.department_id = bm.department_id

ORDER BY bottleneck_score DESC

LIMIT 5;


-- ============================================================
-- QUESTION 15: QUERY OPTIMIZATION USING EXPLAIN
-- Analyze query performance and identify optimization
-- opportunities.
-- ============================================================


-- Step 1: Analyze execution plan

EXPLAIN

SELECT
    h.hospital_name,
    d.department_name,
    AVG(a.wait_time_minutes) AS avg_wait_time

FROM admissions a

JOIN departments d
    ON a.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

GROUP BY
    h.hospital_name,
    d.department_id,
    d.department_name

HAVING AVG(a.wait_time_minutes) > 80;


-- Step 2: Check available indexes

SHOW INDEX FROM admissions;


-- Optimization Analysis:
--
-- 1. idx_admissions_department is used for joining
--    admissions with departments.
--
-- 2. departments contains only 20 rows, so a full table scan
--    is not a significant performance concern.
--
-- 3. "Using temporary" is caused by aggregation and GROUP BY.
--    Given the small dataset size (2,500 admissions), creating
--    additional indexes would provide minimal benefit.
--
-- 4. No redundant index was created because the existing
--    department_id index is already used by the query.


-- Final optimized query

SELECT
    h.hospital_name,
    d.department_name,
    ROUND(AVG(a.wait_time_minutes), 2) AS avg_wait_time

FROM admissions a

JOIN departments d
    ON a.department_id = d.department_id

JOIN hospitals h
    ON d.hospital_id = h.hospital_id

GROUP BY
    h.hospital_name,
    d.department_id,
    d.department_name

HAVING AVG(a.wait_time_minutes) > 80

ORDER BY avg_wait_time DESC;