
# 🚗 UK Road Accidents Data Analysis (2021–2022)
*An End-to-End Data Analytics Project developed for the Digital Egypt Pioneers Initiative (DEPI)*

---

## 📌 Project Overview
Road traffic accidents represent a major socio-economic and public health challenge. This project delivers a comprehensive, multi-tool data analytics pipeline examining **307,973 accident records**, **417,883 casualties**, and **563,302 involved vehicles** across the United Kingdom for the years 2021 and 2022. 

The primary objective is to transform raw government transport data into high-impact, actionable intelligence using **Excel**, **SQL Server**, and **Power BI**, supporting data-driven policymaking and strategic infrastructure interventions.

---

## 👥 Project Team & Supervision
* **Initiative:** Digital Egypt Pioneers Initiative (DEPI) — Data Analytics Track
* **Team Members:**
  * Reham Ali Salah El Din Ali
  * Shahd Saad Abdelsalam Youssef
  * Rahma Galal Ramadan
  * Jana Mohamed Said Abd ElAziz
  * Tervina Atef Fariz
  * Marwa Esmail Abdelghaffar
* **Instructor:** Marwan Mokhtar
* **Submission Date:** July 25, 2026

---

## 🛠️ End-to-End Technical Workflow

| Pipeline Stage | Tool / Technology | Description & Key Activities |
| :--- | :--- | :--- |
| **1. Data Cleaning & Exploration** | **Microsoft Excel** | Initial audit of 19 attributes, missing-value checks, duplicate removal, categorical standardization, and first-pass exploratory pivot tables. |
| **2. Database Architecture & Modeling** | **SQL Server (T-SQL)** | Relational table creation, rigorous null-value and type validation, schema design, and advanced aggregation queries for core KPIs. |
| **3. Interactive Visual Storytelling** | **Power BI & Excel Dashboards** | Design of dual-platform dark-themed executive dashboards featuring dynamic filtering, YoY comparisons, and geographic mapping. |

---

## 📊 Key Analytical Findings & Insights

* **Severity Distribution:** 85.5% of accidents are classified as *Slight*, 13.2% as *Serious*, and 1.3% as *Fatal*. Despite the lower percentage, fatal accidents account for thousands of preventable deaths annually (e.g., 2,855 fatal casualties in 2022).
* **Infrastructure Risk:** **Single carriageways** account for **74.9% of all accidents** and **74.0% of fatal casualties** in 2022, making them the highest-priority target for road safety investment.
* **Weather Reality Check:** Counter to public assumptions, **79.4% of accidents occur in fine weather with no high winds**, indicating that driver behavior and road design are much greater risk drivers than adverse weather.
* **Temporal Patterns:** **Friday** consistently records the highest accident volume, while the hourly distribution confirms a classic dual commuter peak (08:00 morning and 15:00–18:00 evening).
* **Urban vs. Rural Dynamics:** Urban areas host 64.5% of accidents by volume, but rural roads and higher speed-limit zones (60–70 mph) exhibit a disproportionately higher severity rate.

---

## 🖥️ Interactive Dashboards Preview

### 1. Power BI Interactive Dashboard
*Features dynamic KPI cards with YoY change indicators, monthly trend sparklines, road type breakdowns, and an interactive UK geographic fatal casualty map.*

![Power BI Dashboard](Road%20Accident%20project/Media/Power%20Bi.jpeg)

### 2. Excel Executive Dashboard
*Built using advanced Excel tools including Power Query, Power Pivot, and DAX modeling to deliver robust exploratory views across vehicle types, weather conditions, and surface states.*

![Excel Dashboard](Road%20Accident%20project/Media/Dashboard_Excel.jpeg) 

---

## 📂 Repository Structure
```text
├── Road Accident project/
│   ├── Documentation/     # Project documentation & requirements
│   ├── Media/             # Dashboard preview images (Power BI & Excel)
│   ├── Power Bi/          # Power BI dashboard source files (.pbix)
│   ├── Presentation/      # Graduation project presentation deck
│   ├── SQL/               # SQL Server database schema & aggregation queries
│   └── Data.zip           # Raw & cleaned datasets
└── README.md              # Project documentation
```

---

## 🚀 Strategic Recommendations for Policymakers
1. **Prioritize Single Carriageways:** Focus infrastructure funding (median barriers, junction redesigns) on single carriageway routes.
2. **Behavioral Enforcement:** Redirect traffic policing away from weather-contingent assumptions toward driver behavior and speed discipline during peak commute hours.
3. **Temporal Targeting:** Increase visible policing and variable speed enforcement during Friday peak travel windows and evening rush hours.
4. **Rural Safety Gaps:** Address the disproportionate severity rate on rural high-speed roads through enhanced signage, lighting, and speed limits.
5. **Continuous Monitoring:** Maintain live-refreshed BI dashboards to track the positive YoY decline observed between 2021 and 2022 (e.g., 35.6% drop in fatal accidents).
