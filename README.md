# 🌍 Global Internal Displacement Dashboard (IOM DTM Data)

This project explores **global internal displacement trends** using publicly available data from the **International Organization for Migration (IOM) Displacement Tracking Matrix (DTM)**.  
It aims to uncover how **conflicts** and **disasters** have affected populations across regions and time — with interactive visualizations and clear insights for humanitarian decision-making.

Some key findings from the analysis include:

- **Conflict remains the main driver of displacement globally**, and data visualization makes it easier to understand where and how these patterns evolve over time.
- Certain countries consistently report the highest levels of internal displacement.
- Conflict and natural disasters are major drivers of population movement.
- Some regions experience persistent displacement patterns across multiple reporting periods.

---

![IOM Global Internal Displacement Dashboard Screenshot](https://github.com/CarlyLouis/Global-Internal-Displacement-IOM-DTM-/blob/main/IOM%20Displacement%20Dashboard.png)
<br><br>

[Link to the Project Interactive Dashboard on Tableau Public](https://public.tableau.com/views/IOM_17609224949540/IOMDisplacementDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---


## 📁 Dataset Overview

**Source:** `global-iom-dtm-from-api-admin-0-to-2.csv`  
**Cleaned data:** `iom_displacement_cleaned.csv`  
**Data Provider:** International Organization for Migration (IOM) – Displacement Tracking Matrix (DTM)  
**Period Covered:** 2011-2025 (global coverage)  
**Geographic Scope:** Country, Region, and Admin Level (0–2)

| Column Name | Description |
|--------------|-------------|
| `Year` | Year of recorded displacement event |
| `Country` | Country name |
| `Region` | Geographic region or subregion |
| `Admin1` / `Admin2` | Administrative levels (if applicable) |
| `Cause` | Primary cause of displacement (`Conflict`, `Disaster`, or `Other`) |
| `Total_Displaced_Persons` | Number of displaced persons recorded |
| `Data_Collection_Method` | DTM or other source method |
| `Last_Update` | Timestamp of most recent data update |

---

## ⚙️ Tools & Technologies

| Tool | Purpose |
|------|----------|
| 🐬 **MySQL Workbench 8.0 CE** | Data import, cleaning, and SQL analysis |
| 📊 **Tableau Public 2025.2** | Data visualization and interactive dashboard |
| 🧮 **Excel / CSV** | Quick verification and initial cleaning |
| 💻 **GitHub** | Version control and portfolio hosting |

---

## 🔧 Data Cleaning & Preparation (MySQL)

The dataset was cleaned and prepared using **SQL queries** in MySQL Workbench.

### Main steps included:
1. **Import CSV file** via GUI (using the Table Data Import Wizard).  
2. **Rename columns** for consistency.  
3. **Handle missing values** (`NULL` and blank fields).  
4. **Standardize text** (country and region names).  
5. **Convert numeric columns** to appropriate data types.  
6. **Aggregate** displacement counts by year, cause, and region.

```sql
-- Example: Check for null or missing data
SELECT *
FROM iom_displacement
WHERE Country IS NULL OR Total_Displaced_Persons IS NULL;

-- Example: Clean region text and convert to uppercase
UPDATE iom_displacement
SET Region = UPPER(TRIM(Region));

-- Example: Aggregate displacement per cause and year
SELECT Year, Cause, SUM(Total_Displaced_Persons) AS Total_Displaced
FROM iom_displacement
GROUP BY Year, Cause
ORDER BY Year;
```
---

# Author

**Carly Louis**

Data Analyst | Data Engineering Enthusiast

LinkedIn  
www.linkedin.com/in/carly-louis-krlification

---
