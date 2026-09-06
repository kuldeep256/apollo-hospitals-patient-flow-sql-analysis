# 🏥 Apollo Hospitals Patient Flow Analysis | SQL Project

## 📌 Project Overview

This project analyzes hospital patient-flow operations using SQL to identify operational bottlenecks related to patient admissions, waiting time, length of stay, readmissions, and bed utilization.

The analysis was performed on a synthetic relational hospital database containing hospitals, departments, patients, doctors, admissions, and bed occupancy data.

The objective was to simulate a real-world healthcare analytics workflow and transform raw operational data into actionable business insights.

---

# 🎯 Business Problem

Hospitals need to efficiently manage patient flow to reduce waiting times, optimize bed utilization, minimize unnecessary readmissions, and improve overall operational performance.

This project answers questions such as:

* Which hospitals handle the highest patient volume?
* Which departments experience the longest patient waiting times?
* Where are critical patient-flow bottlenecks occurring?
* Which departments have high readmission rates?
* Are hospital beds being efficiently utilized?
* Which departments should be prioritized for operational improvement?

---

# 🛠️ Tools & Technologies

* MySQL
* MySQL Workbench
* SQL
* Window Functions
* Common Table Expressions (CTEs)
* Subqueries
* Aggregate Functions
* JOINs
* CASE Statements
* EXPLAIN
* Index Analysis

---

# 🗂️ Database

**Database Name:** `apollo_patient_flow`

## Tables Used

| Table         | Description                            |
| ------------- | -------------------------------------- |
| hospitals     | Hospital information                   |
| departments   | Department details                     |
| patients      | Patient information                    |
| doctors       | Doctor information                     |
| admissions    | Patient admission records              |
| bed_occupancy | Department-level bed occupancy records |

---

# 📊 Dataset Overview

The dataset contains approximately:

* 4 Hospitals
* 20 Departments
* 500 Patients
* 60 Doctors
* 2,500 Admissions
* 7,300 Bed Occupancy Records

> Note: This dataset is synthetic and created for educational purposes. It does not contain real patient information.

---

# 🔗 Database Relationships

### Key Relationships

* One Hospital → Multiple Departments
* One Department → Multiple Doctors
* One Patient → Multiple Admissions
* One Department → Multiple Admissions
* One Department → Multiple Bed Occupancy Records

## Entity Relationship Diagram

![Entity Relationship Diagram](images/ER_Diagram.png)

---

# 📈 Analysis Performed

The project consists of 15 SQL analysis questions.

### 1. Database Exploration

Explored tables, columns, primary keys, foreign keys, and relationships.

### 2. Hospital Admission Analysis

Calculated total patient admissions handled by each hospital.

### 3. Department Performance

Identified departments with the highest patient admission volume.

### 4. Patient Waiting Time Analysis

Calculated average, minimum, and maximum waiting time across departments.

### 5. Waiting-Time Bottleneck Analysis

Classified patients into Low, Moderate, High, and Critical waiting-time categories.

### 6. Length of Stay Analysis

Calculated average patient length of stay for each department.

### 7. Readmission Analysis

Calculated overall and department-level readmission rates.

### 8. Patient Readmission Patterns

Identified patients admitted multiple times and ranked them using window functions.

### 9. Bed Utilization Analysis

Calculated average bed utilization and identified high-capacity departments.

### 10. Hospital & Department Performance Report

Created a multi-table report combining admissions, waiting time, beds, and hospitals.

### 11. Subquery Analysis

Identified departments with above-average waiting times.

### 12. Department Performance using CTE

Created department-level operational metrics using Common Table Expressions.

### 13. Department Ranking using Window Functions

Ranked departments based on waiting time, readmission rate, and bed utilization.

### 14. Patient-Flow Bottleneck Analysis

Created a composite bottleneck score to prioritize departments requiring attention.

### 15. Query Optimization

Used `EXPLAIN` and index analysis to evaluate query performance.

---

# 💡 Key Business Insights

## 1. Apollo Hyderabad Handled the Highest Patient Volume

**Finding:** Apollo Hyderabad recorded the highest number of patient admissions.

**Evidence:**

| Hospital         | Total Admissions |
| ---------------- | ---------------: |
| Apollo Hyderabad |              654 |
| Apollo Mumbai    |              631 |
| Apollo Delhi     |              630 |
| Apollo Bangalore |              585 |

**Business Impact:** Higher patient volume can increase pressure on hospital resources, staff, and bed availability.

---

## 2. Emergency Departments Are the Primary Waiting-Time Bottleneck

**Finding:** Emergency departments consistently recorded the highest average waiting times.

**Evidence:** Emergency department average waiting times ranged from **99.63 to 106.71 minutes**.

**Business Impact:** Long emergency waiting times may indicate capacity constraints, triage inefficiencies, or staffing shortages.

---

## 3. Apollo Bangalore Emergency Had the Highest Average Waiting Time

**Finding:** Apollo Bangalore's Emergency department recorded the highest average patient waiting time.

**Evidence:** **106.71 minutes average waiting time**.

**Business Impact:** This department should be prioritized for operational review and potential improvements in patient triage and staffing.

---

## 4. Critical Waiting Cases Were Concentrated in Emergency Departments

**Finding:** Emergency departments recorded the highest number of Critical waiting-time cases.

**Evidence:** The highest department-level Critical waiting count was **90 cases**.

**Business Impact:** A large number of critical waiting cases may affect treatment responsiveness and patient satisfaction.

---

## 5. Highest Observed Length of Stay

**Finding:** The highest department-level average patient length of stay was observed in an Emergency department.

**Evidence:** Apollo Delhi Emergency recorded an average length of stay of **4.82 days**.

**Business Impact:** Longer stays can reduce patient turnover and increase pressure on hospital capacity.

---

## 6. Readmission Rates Were High Across the Hospital Network

**Finding:** The overall hospital readmission rate was high.

**Evidence:**

* Overall Readmission Rate: **66.72%**
* Highest Department-Level Readmission Rate: **72.65%**

**Business Impact:** High readmission rates may indicate potential gaps in discharge planning, follow-up care, or treatment outcomes.

---

## 7. No Department Crossed the Critical Bed Utilization Threshold

**Finding:** No department exceeded the project's critical utilization threshold of 90%.

**Evidence:** The highest observed average bed utilization was **89.82%** in Apollo Bangalore Emergency.

**Business Impact:** Although below the critical threshold, Emergency departments are operating close to capacity and require continuous monitoring.

---

## 8. Apollo Bangalore Emergency Was the Highest Patient-Flow Bottleneck

**Finding:** Apollo Bangalore Emergency recorded the highest overall bottleneck score.

**Evidence:**

| Metric                 |          Value |
| ---------------------- | -------------: |
| Average Waiting Time   | 106.71 minutes |
| Average Length of Stay |      4.54 days |
| Readmission Rate       |         71.55% |
| Bed Utilization        |89.82% (Highest)|
| Bottleneck Score       |313.48 (Highest)|

**Business Impact:** This department should be prioritized for operational intervention.

---

## 9. Emergency Departments Dominated the Top Bottleneck Rankings

**Finding:** All four Emergency departments occupied the Top 4 positions in the patient-flow bottleneck analysis.

**Evidence:** Emergency department bottleneck scores ranged from **297.74 to 313.48**.

**Business Impact:** The bottleneck appears to be systemic across Emergency operations rather than isolated to a single hospital.

---

## 10. General Medicine Also Showed Significant Operational Pressure

**Finding:** General Medicine appeared in the Top 5 bottleneck departments.

**Evidence:**

* Average Waiting Time: 65.75 minutes
* Readmission Rate: 69.63%
* Bed Utilization: 76.96%
* Bottleneck Score: 255.84

**Business Impact:** Operational bottlenecks are influenced by multiple factors and cannot be evaluated using waiting time alone.

---


# 🚨 Top Patient-Flow Bottlenecks

| Rank | Hospital          | Department       | Avg Wait Time | Avg LOS   | Readmission Rate | Bed Utilization | Bottleneck Score |
|------|-------------------|------------------|--------------:|--------:  |-----------------:|----------------:|-----------------:|
|   1  | Apollo Bangalore  | Emergency        | 106.71 min    | 4.54 days |      71.55%      |      89.82%     |       313.48     |
|   2  | Apollo Delhi      | Emergency        | 103.78 min    | 4.82 days |      62.28%      |      89.00%     |       303.26     |
|   3  | Apollo Hyderabad  | Emergency        | 103.84 min    | 4.53 days |      62.60%      |      88.71%     |       300.45     |
|   4  | Apollo Mumbai     | Emergency        | 99.63 min     | 4.27 days |      66.39%      |      89.02%     |       297.74     |
|   5  | Apollo Hyderabad  | General Medicine | 65.75 min     | 4.35 days |      69.63%      |      76.96%     |       255.84     |
> The composite bottleneck score was created for analytical prioritization by combining waiting time, length of stay, readmission rate, and bed utilization. It is not an official hospital KPI.

---

# ⚡ Query Optimization

Query performance was analyzed using the `EXPLAIN` command.

The analysis showed that the admissions table used an existing index:

```sql
idx_admissions_department
```

The index supports joins between:

```text
admissions.department_id
        ↓
departments.department_id
```

### Optimization Approach

* Examined execution plans using `EXPLAIN`
* Checked existing indexes using `SHOW INDEX`
* Avoided unnecessary duplicate indexes
* Aggregated large tables before joining them
* Reduced potential row multiplication in complex multi-table analysis

---

# 🧠 SQL Concepts Demonstrated

```text
✔ SELECT
✔ WHERE
✔ ORDER BY
✔ LIMIT
✔ GROUP BY
✔ HAVING
✔ Aggregate Functions
✔ CASE Statements
✔ INNER JOIN
✔ LEFT JOIN
✔ Subqueries
✔ Common Table Expressions
✔ Window Functions
✔ RANK()
✔ DATEDIFF()
✔ EXPLAIN
✔ Index Analysis
✔ Query Optimization
```

---

# 📂 Project Structure

```text
apollo-hospitals-patient-flow-sql-analysis/
│
├── README.md
│
├── sql/
│   ├── Apollo_Patient_Flow_Analysis.sql
│   └── Apollo_Hospitals_Patient_Flow_SQL_Lab.sql
│
├── images/
│   └── ER_Diagram.png
│
└── presentation/
    └── Apollo_Patient_Flow_Presentation.pptx
```

---

# 📌 Key Takeaways

This project demonstrates how SQL can be used to analyze complex hospital operations and identify patient-flow bottlenecks.

The analysis highlighted that:

* Emergency departments require the highest operational attention.
* Long waiting times are a major patient-flow issue.
* Readmission rates are consistently high across departments.
* Bed utilization is approaching critical levels in some Emergency departments.
* Combining multiple operational metrics provides better prioritization than analyzing individual KPIs separately.

---

# 🚀 Conclusion

The analysis identified Emergency departments as the primary patient-flow bottleneck across the hospital network.

The most critical case was Apollo Bangalore Emergency, which recorded the highest average waiting time, high readmission rates, near-critical bed utilization, and the highest composite bottleneck score.

These findings demonstrate how SQL-based analytics can support hospital operations by identifying departments that should be prioritized for capacity planning, staffing optimization, and patient-flow improvements.