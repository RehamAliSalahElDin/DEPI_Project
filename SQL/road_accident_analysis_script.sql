/* ================================================================
   UK ROAD ACCIDENT ANALYSIS - MERGED & SIMPLIFIED SQL SCRIPT
   SQL Server | Dataset: road_accident (2021-2022, ~308K records)

   Merged from:
     - road_accident_insights_simple.sql  (data quality + broad EDA)
     - Road accident Script.sql           (CY KPIs + % breakdowns)

   No CASE WHEN / CAST anywhere in this version:
     - Category grouping (vehicle types, Day/Night) is done with several
       simple WHERE ... IN (...) queries instead of one CASE expression.
     - Percentages use "* 100.0" (forces decimal division) instead of CAST.
     - Day-of-week is sorted alphabetically instead of a CASE-based custom order.
   Same insights, just broken into more, simpler queries - stack results
   in Excel/Power BI where you need them combined.

   Structure:
     1. Data Quality & Validation
     2. Overall KPIs
     3. Severity Analysis
     4. Time-Based Trends
     5. Environmental Factors
     6. Location-Based Analysis
     7. Vehicle Analysis
     8. Advanced Insights

   NOTE: @analysis_year controls every "current year" (CY_) query below.
   Update it once here each year instead of hunting for hardcoded 2022s.
   ================================================================ */

DECLARE @analysis_year INT = 2022;


-- ================================================================
-- SECTION 1: DATA QUALITY & VALIDATION
-- ================================================================

-- 1.1 Row count + date range covered by the dataset
SELECT
    COUNT(*)             AS total_records,
    MIN(accident_date)   AS earliest_date,
    MAX(accident_date)   AS latest_date
FROM road_accident;

-- 1.2 Null counts per column
-- COUNT(*) counts all rows; COUNT(column) skips NULLs, so the difference = null count.
SELECT
    COUNT(*) - COUNT(accident_date)           AS null_accident_date,
    COUNT(*) - COUNT(day_of_week)             AS null_day_of_week,
    COUNT(*) - COUNT(junction_control)        AS null_junction_control,
    COUNT(*) - COUNT(junction_detail)         AS null_junction_detail,
    COUNT(*) - COUNT(accident_severity)       AS null_severity,
    COUNT(*) - COUNT(light_conditions)        AS null_light,
    COUNT(*) - COUNT(local_authority)         AS null_authority,
    COUNT(*) - COUNT(carriageway_hazards)     AS null_hazards,
    COUNT(*) - COUNT(number_of_casualties)    AS null_casualties,
    COUNT(*) - COUNT(number_of_vehicles)      AS null_vehicles,
    COUNT(*) - COUNT(police_force)            AS null_police_force,
    COUNT(*) - COUNT(road_surface_conditions) AS null_surface,
    COUNT(*) - COUNT(road_type)               AS null_road_type,
    COUNT(*) - COUNT(speed_limit)             AS null_speed_limit,
    COUNT(*) - COUNT([time])                  AS null_time,
    COUNT(*) - COUNT(urban_or_rural_area)     AS null_urban_rural,
    COUNT(*) - COUNT(weather_conditions)      AS null_weather,
    COUNT(*) - COUNT(vehicle_type)            AS null_vehicle_type
FROM road_accident;

-- 1.3 Duplicate accident_index check (accident_index should be unique - expect 0 rows)
SELECT accident_index, COUNT(*) AS occurrences
FROM road_accident
GROUP BY accident_index
HAVING COUNT(*) > 1;

-- 1.4 Distinct-value sanity checks (catch typos / inconsistent category labels)
SELECT DISTINCT accident_severity FROM road_accident;
SELECT DISTINCT urban_or_rural_area FROM road_accident;
SELECT DISTINCT speed_limit FROM road_accident ORDER BY speed_limit;


-- ================================================================
-- SECTION 2: OVERALL KPIs
-- ================================================================

-- 2.1 Headline numbers, all years
SELECT
    COUNT(*)                                    AS total_accidents,
    SUM(number_of_casualties)                   AS total_casualties,
    SUM(number_of_vehicles)                     AS total_vehicles_involved,
    SUM(number_of_casualties) * 1.0 / COUNT(*)  AS avg_casualties_per_accident,
    SUM(number_of_vehicles) * 1.0 / COUNT(*)    AS avg_vehicles_per_accident
FROM road_accident;

-- 2.2 Current-year (CY) headline numbers
SELECT
    SUM(number_of_casualties)      AS CY_casualties,
    COUNT(DISTINCT accident_index) AS CY_accidents
FROM road_accident
WHERE YEAR(accident_date) = @analysis_year;


-- ================================================================
-- SECTION 3: SEVERITY ANALYSIS
-- ================================================================

-- 3.1 Accident counts by severity (all years)
SELECT accident_severity, COUNT(*) AS accident_count
FROM road_accident
GROUP BY accident_severity
ORDER BY accident_count DESC;

-- 3.2 Casualties by severity, all years
SELECT accident_severity, SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY accident_severity
ORDER BY total_casualties DESC;

-- 3.3 Casualties by severity, current year only
SELECT accident_severity, SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE YEAR(accident_date) = @analysis_year
GROUP BY accident_severity
ORDER BY CY_casualties DESC;

-- 3.4 Each severity's share (%) of total casualties, all-time
-- "* 100.0" forces decimal division instead of CAST, same trick as avg_casualties above
SELECT
    accident_severity,
    SUM(number_of_casualties) * 100.0 /
        (SELECT SUM(number_of_casualties) FROM road_accident) AS pct_of_total_casualties
FROM road_accident
GROUP BY accident_severity
ORDER BY pct_of_total_casualties DESC;

-- 3.5 Severity by speed limit
SELECT speed_limit, accident_severity, COUNT(*) AS accident_count
FROM road_accident
GROUP BY speed_limit, accident_severity
ORDER BY speed_limit, accident_severity;

-- 3.6 Severity by road type
SELECT road_type, accident_severity, COUNT(*) AS accident_count
FROM road_accident
GROUP BY road_type, accident_severity
ORDER BY road_type, accident_severity;


-- ================================================================
-- SECTION 4: TIME-BASED TRENDS
-- ================================================================

-- 4.1 Monthly accidents + casualties, all years
SELECT
    YEAR(accident_date)  AS yr,
    MONTH(accident_date) AS mth,
    COUNT(*)             AS accident_count,
    SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY YEAR(accident_date), MONTH(accident_date)
ORDER BY yr, mth;

-- 4.2 Current-year casualties by month name
SELECT
    DATENAME(MONTH, accident_date) AS month_name,
    SUM(number_of_casualties)      AS CY_casualties
FROM road_accident
WHERE YEAR(accident_date) = @analysis_year
GROUP BY DATENAME(MONTH, accident_date), MONTH(accident_date)
ORDER BY MONTH(accident_date);

-- 4.3 Day-of-week distribution
-- Sorted alphabetically to avoid a CASE-based custom order; reorder Mon->Sun manually
-- in Excel/Power BI if needed (7 rows only, quick to drag into place).
SELECT day_of_week, COUNT(*) AS accident_count
FROM road_accident
GROUP BY day_of_week
ORDER BY day_of_week;

-- 4.4 Weekend vs. weekday accident counts
SELECT COUNT(*) AS weekend_accidents FROM road_accident WHERE day_of_week IN ('Saturday', 'Sunday');
SELECT COUNT(*) AS weekday_accidents FROM road_accident WHERE day_of_week NOT IN ('Saturday', 'Sunday');

-- 4.5 Accidents by hour of day
SELECT DATEPART(HOUR, [time]) AS hour_of_day, COUNT(*) AS accident_count
FROM road_accident
GROUP BY DATEPART(HOUR, [time])
ORDER BY hour_of_day;

-- 4.6 Morning rush (7-9) vs. evening rush (16-19) vs. off-peak
SELECT COUNT(*) AS morning_rush_accidents FROM road_accident WHERE DATEPART(HOUR, [time]) BETWEEN 7 AND 9;
SELECT COUNT(*) AS evening_rush_accidents FROM road_accident WHERE DATEPART(HOUR, [time]) BETWEEN 16 AND 19;
SELECT COUNT(*) AS off_peak_accidents
FROM road_accident
WHERE DATEPART(HOUR, [time]) NOT BETWEEN 7 AND 9
  AND DATEPART(HOUR, [time]) NOT BETWEEN 16 AND 19;


-- ================================================================
-- SECTION 5: ENVIRONMENTAL FACTORS
-- ================================================================

-- 5.1 Weather conditions: accident count + avg casualties
SELECT
    weather_conditions,
    COUNT(*) AS accident_count,
    SUM(number_of_casualties) * 1.0 / COUNT(*) AS avg_casualties
FROM road_accident
GROUP BY weather_conditions
ORDER BY accident_count DESC;

-- 5.2 Road surface conditions by severity
SELECT road_surface_conditions, accident_severity, COUNT(*) AS accident_count
FROM road_accident
GROUP BY road_surface_conditions, accident_severity
ORDER BY road_surface_conditions, accident_severity;

-- 5.3 Light conditions (detailed categories) by severity
SELECT light_conditions, accident_severity, COUNT(*) AS accident_count
FROM road_accident
GROUP BY light_conditions, accident_severity
ORDER BY light_conditions, accident_severity;

-- 5.4 Daylight casualties, current year (raw number + % of CY total)
-- Split into two simple queries (Day / Night) instead of a CASE-based bucket,
-- same pattern as the weekend-vs-weekday split in section 4.4.
SELECT
    SUM(number_of_casualties) AS day_CY_casualties,
    SUM(number_of_casualties) * 100.0 /
        (SELECT SUM(number_of_casualties) FROM road_accident WHERE YEAR(accident_date) = @analysis_year) AS day_pct
FROM road_accident
WHERE light_conditions = 'Daylight'
  AND YEAR(accident_date) = @analysis_year;

-- 5.5 Darkness casualties, current year (raw number + % of CY total)
SELECT
    SUM(number_of_casualties) AS night_CY_casualties,
    SUM(number_of_casualties) * 100.0 /
        (SELECT SUM(number_of_casualties) FROM road_accident WHERE YEAR(accident_date) = @analysis_year) AS night_pct
FROM road_accident
WHERE light_conditions IN (
    'Darkness - lighting unknown', 'Darkness - lights lit',
    'Darkness - lights unlit', 'Darkness - no lighting'
)
AND YEAR(accident_date) = @analysis_year;

-- 5.6 Worst weather + road surface combinations for Fatal accidents
SELECT weather_conditions, road_surface_conditions, COUNT(*) AS fatal_count
FROM road_accident
WHERE accident_severity = 'Fatal'
GROUP BY weather_conditions, road_surface_conditions
ORDER BY fatal_count DESC;

-- 5.7 Carriageway hazards by severity
SELECT carriageway_hazards, accident_severity, COUNT(*) AS accident_count
FROM road_accident
GROUP BY carriageway_hazards, accident_severity
ORDER BY carriageway_hazards, accident_severity;


-- ================================================================
-- SECTION 6: LOCATION-BASED ANALYSIS
-- ================================================================

-- 6.1 Top 10 local authorities by accident count
SELECT TOP 10
    local_authority, COUNT(*) AS accident_count, SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY local_authority
ORDER BY accident_count DESC;

-- 6.2 All local authorities ranked by total casualties (all-time)
SELECT local_authority, SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY local_authority
ORDER BY total_casualties DESC;

-- 6.3 Severity breakdown per local authority
SELECT local_authority, accident_severity, COUNT(*) AS accident_count
FROM road_accident
GROUP BY local_authority, accident_severity
ORDER BY local_authority, accident_severity;

-- 6.4 Urban vs. rural: accident count + avg casualties (all years)
SELECT
    urban_or_rural_area,
    COUNT(*) AS accident_count,
    SUM(number_of_casualties) * 1.0 / COUNT(*) AS avg_casualties
FROM road_accident
GROUP BY urban_or_rural_area;

-- 6.5 Urban vs. rural: total casualties + % share of all-time casualties
SELECT
    urban_or_rural_area,
    SUM(number_of_casualties) AS total_casualties,
    SUM(number_of_casualties) * 100.0 /
        (SELECT SUM(number_of_casualties) FROM road_accident) AS pct_of_total_casualties
FROM road_accident
GROUP BY urban_or_rural_area;

-- 6.6 Accidents by police force
SELECT police_force, COUNT(*) AS accident_count
FROM road_accident
GROUP BY police_force
ORDER BY accident_count DESC;

-- 6.7 Junction detail + control, by severity
SELECT junction_detail, junction_control, accident_severity, COUNT(*) AS accident_count
FROM road_accident
GROUP BY junction_detail, junction_control, accident_severity
ORDER BY accident_count DESC;


-- ================================================================
-- SECTION 7: VEHICLE ANALYSIS
-- ================================================================

-- 7.1 Accidents + casualties per raw vehicle_type
SELECT vehicle_type, COUNT(*) AS accident_count, SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY vehicle_type
ORDER BY accident_count DESC;

-- 7.2 Casualties by simplified vehicle group, current year
-- Instead of one CASE with 6 branches, each group gets its own simple WHERE ... IN (...) query
-- (same style as the weekend/weekday and rush-hour splits above). Run all 6 and stack the
-- results in Excel/Power BI to get the same grouped view the CASE version would have produced.

-- Agricultural
SELECT 'Agricultural' AS vehicle_group, SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE vehicle_type = 'Agricultural vehicle'
  AND YEAR(accident_date) = @analysis_year;

-- Cars
SELECT 'Cars' AS vehicle_group, SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE vehicle_type IN ('Car', 'Taxi/Private hire car')
  AND YEAR(accident_date) = @analysis_year;

-- Bike (motorcycles + pedal cycles)
SELECT 'Bike' AS vehicle_group, SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE vehicle_type IN (
    'Motorcycle 125cc and under', 'Motorcycle 50cc and under',
    'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc', 'Pedal cycle'
)
AND YEAR(accident_date) = @analysis_year;

-- Bus (bus/coach + minibus)
SELECT 'Bus' AS vehicle_group, SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)')
  AND YEAR(accident_date) = @analysis_year;

-- Van (goods vehicles)
SELECT 'Van' AS vehicle_group, SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE vehicle_type IN (
    'Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under'
)
AND YEAR(accident_date) = @analysis_year;

-- Other (everything not covered by the 5 groups above)
SELECT 'Other' AS vehicle_group, SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE vehicle_type NOT IN (
    'Agricultural vehicle', 'Car', 'Taxi/Private hire car',
    'Motorcycle 125cc and under', 'Motorcycle 50cc and under',
    'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc', 'Pedal cycle',
    'Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)',
    'Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under'
)
AND YEAR(accident_date) = @analysis_year;

-- 7.3 Distribution of accidents by number_of_vehicles involved
SELECT number_of_vehicles, COUNT(*) AS accident_count
FROM road_accident
GROUP BY number_of_vehicles
ORDER BY number_of_vehicles;

-- 7.4 Accidents involving 3+ vehicles
SELECT COUNT(*) AS accidents_with_3_or_more_vehicles
FROM road_accident
WHERE number_of_vehicles >= 3;

-- 7.5 Top 20 accidents by casualty count (outliers worth a closer look)
SELECT TOP 20
    accident_index, accident_date, local_authority, number_of_casualties,
    number_of_vehicles, accident_severity, vehicle_type
FROM road_accident
ORDER BY number_of_casualties DESC;


-- ================================================================
-- SECTION 8: ADVANCED INSIGHTS
-- ================================================================

-- 8.1 Speed limit vs. avg casualties
SELECT
    speed_limit,
    COUNT(*) AS accident_count,
    SUM(number_of_casualties) * 1.0 / COUNT(*) AS avg_casualties
FROM road_accident
GROUP BY speed_limit
ORDER BY speed_limit;

-- 8.2 Most common road_type per local authority (highest-count combination)
SELECT r1.local_authority, r1.road_type, r1.accident_count
FROM (
    SELECT local_authority, road_type, COUNT(*) AS accident_count
    FROM road_accident
    GROUP BY local_authority, road_type
) r1
WHERE r1.accident_count = (
    SELECT MAX(r2.accident_count)
    FROM (
        SELECT local_authority, road_type, COUNT(*) AS accident_count
        FROM road_accident
        GROUP BY local_authority, road_type
    ) r2
    WHERE r2.local_authority = r1.local_authority
)
ORDER BY r1.accident_count DESC;

-- 8.3 Casualties by road_type, current year
SELECT road_type, SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE YEAR(accident_date) = @analysis_year
GROUP BY road_type
ORDER BY CY_casualties DESC;

-- 8.4 Daily accident counts (feed a "Running Total" visual directly in Power BI)
SELECT accident_date, COUNT(*) AS daily_count
FROM road_accident
GROUP BY accident_date
ORDER BY accident_date;
