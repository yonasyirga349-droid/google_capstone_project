
# 📑 Cyclistic Capstone Project Report

## Introduction

 The data sources and business are all simulated.  I used SQL for most of data manipulation and transformation processes, due to the large number of records, and Excel for quick insight to the structure of the database, and ChatGPT for visualization. 

Capstone project report instructions:

1. A clear statement of the business task
2. A description of all data sources used
3. Documentation of any cleaning or manipulation of data
4. A summary of your analysis
5. Supporting visualizations and key findings
6. Your top three recommendations based on your analysis

## 1. Business Task

Cyclistic aims to increase revenue and long-term customer retention by **converting casual riders into annual members**. To achieve this, we must:

- Compare how casual and annual members use Cyclistic’s services.
- Identify key differences in riding behavior.
- Propose actionable strategies to encourage casual riders to upgrade.

---

## 2. Data Sources

- **Cyclistic trip data**: Monthly ride logs spanning from August 2024 through July 2025.
    - Each dataset contained ride-level information such as `ride_id`, `started_at`, `ended_at`, `member_casual`, `rideable_type`, start_lat, start_lng, end_lat, and end_lng.
- Data was provided in split monthly tables (`tripdata_YYYYMM_split`).
- Data validation steps confirmed:
    - No duplicate ride IDs.
    - No missing critical records aside from occasional null station names.
    - Single day from the previous month was included across all month tables.

---

## 3. Data Cleaning & Manipulation

- **Member column transformation**:
    - Converted `member_casual` to a Boolean (TRUE = annual member, FALSE = casual).
- **Handling null station names**:
    - Created lookup CTEs with latitude/longitude.
    - Attempted mapping station coordinates to names but found values were approximate and not unique.
    - Imputation using station ID was not possible (no ID field available).
    - Decision: Null station names remain excluded from analysis.
- **Data consolidation**:
    - Unified monthly tables into one `all_tripdata` table using `UNION ALL` and segmented each table to correctly represent  the month.
- **Ride duration filtering**:
    - Excluded extreme outliers: only trips between **60 seconds (1 min)** and **72,000 seconds (20 hours)** were retained.
- **New columns created**:
    - Ride length in seconds.
    - Day of week (`EXTRACT(DOW)`).
    - Aggregations for `MIN`, `MAX`, `MEAN`, `MEDIAN`, and ride counts.
- Top 10 stations with large casual rides

---

## 4. Summary of Analysis

- **User Distribution**:
    - Members = **63.9%** of rides.
    - Casuals = **36.1%** of rides.
- **Ride Duration**:
    - Casual riders: **longer and more variable trips**, especially in summer and weekends.
    - Members: **shorter, consistent trips**, typically weekday commutes.
- **Seasonality**:
    - Casual users’ ride times **peak in spring/summer** and drop sharply in winter.
    - Members ride year-round with only slight winter declines.
- **Day of Week**:
    - Casuals: Active on **weekends**, also take longer weekday trips in winter (likely leisure).
    - Members: Consistent weekday use, overlapping with casuals in winter for short commutes.
- **Rideable Types**:
    - Both groups show **similar modal preferences** for bike type.

---

## 5. Supporting Visualizations & Key Findings

![visual.png](attachment:9f5f5de0-c5f2-432a-974a-8341b62b50ea:visual.png)
<img width="657" height="394" alt="visual" src="https://github.com/user-attachments/assets/0e642b4d-69f6-45ee-9953-2a1aca6ab48f" />

**Key findings:**

1. Casuals = leisure/entertainment driven behavior.
2. Members = commuter driven, weekday heavy use.
3. Conversion opportunity lies in aligning offers with **casual riding habits** (weekend + seasonal).

---

## 6. Recommendations (Top 3 Proposals)

### 🔹 1. Weekend & Leisure Memberships

- Create **low-cost “Weekend Pass” or “Leisure Memberships”** offering unlimited weekend rides.
- Directly targets casuals who primarily ride for leisure.

---

### 🔹 2. Seasonal / Summer Membership Packages

- Offer **3-month, 6-month, or summer-only memberships**.
- Fits casual riders’ strong seasonal usage patterns.
- Option to pause membership in winter months, lowers entry barrier

---

### 🔹 3. Station-Based Promotions

- Identify **casual-heavy stations** (tourist hubs, parks, waterfronts. (using more data sets)
