CREATE DATABASE iom_displacement;
USE iom_displacement;

-- ------------------------ Cleaning --------------------------------
-- 1. View all columns
SELECT * FROM iom_dtm LIMIT 10;
-- 2. Remove rows with missing country names
DELETE FROM iom_dtm
WHERE admin0Name IS NULL OR admin0Name = '';
-- 3. Convert number columns (if they’re text) to integers
ALTER TABLE iom_dtm
MODIFY COLUMN numPresentIdpInd INT;
-- 4. Standardize displacement causes
UPDATE iom_dtm
SET displacementReason = TRIM(LOWER(displacementReason));
-- 5. Verify the year range available
SELECT MIN(yearReportingDate), MAX(yearReportingDate)
FROM iom_dtm;
-- 6. Check column names and data types
DESCRIBE iom_dtm;
-- 7. Normalize country and cause names
UPDATE iom_dtm
SET admin0Name = TRIM(UPPER(admin0Name)),
    displacementReason = TRIM(LOWER(displacementReason));
-- 8. Fixing numeric columns set as TEXT or VARCHAR
ALTER TABLE iom_dtm MODIFY COLUMN numPresentIdpInd INT;
ALTER TABLE iom_dtm MODIFY COLUMN yearReportingDate INT;
ALTER TABLE iom_dtm MODIFY COLUMN monthReportingDate INT;
ALTER TABLE iom_dtm MODIFY COLUMN roundNumber INT;

-- 9. Create a new cleaned date column
ALTER TABLE iom_dtm ADD COLUMN cleanReportingDate DATE;

-- 10. Extract only the date part before the 'T'
UPDATE iom_dtm
SET cleanReportingDate = STR_TO_DATE(SUBSTRING_INDEX(reportingDate, 'T', 1), '%Y-%m-%d');



-- Delete first because dtnumPresentIdpInd data type is not correct
-- DELETE FROM iom_dtm
-- WHERE id = "#id+code";


-- ----------------------- Analysis ---------------------------
-- Total IDPs by country
SELECT admin0Name AS Country,
       SUM(numPresentIdpInd) AS Total_IDPs
FROM iom_dtm
GROUP BY Country
ORDER BY Total_IDPs DESC
LIMIT 10;

-- Displacement by cause
SELECT displacementReason AS Cause,
       SUM(numPresentIdpInd) AS Total_IDPs
FROM iom_dtm
GROUP BY Cause
ORDER BY Total_IDPs DESC;

-- Displacement trend by year
SELECT yearReportingDate AS Year,
       SUM(numPresentIdpInd) AS Total_IDPs
FROM iom_dtm
GROUP BY Year
ORDER BY Year;

-- Gender breakdown (if data available)
SELECT SUM(numberMales) AS Males,
       SUM(numberFemales) AS Females
FROM iom_dtm;


-- ---------------------------- Creating new table-------------------------------

CREATE TABLE iom_dtm_cleaned AS
SELECT 
  admin0Name AS Country,
  admin1Name AS Region,
  admin2Name AS District,
  cleanReportingDate AS ReportDate,
  yearReportingDate AS Year,
  monthReportingDate AS Month,
  displacementReason AS Cause,
  numPresentIdpInd AS IDPs,
  numberMales AS Males,
  numberFemales AS Females,
  assessmentType AS Assessment,
  operationStatus AS Status
FROM iom_dtm
WHERE numPresentIdpInd IS NOT NULL;

-- --------------------Sanity check of cleaned table ------------------------------------

-- Preview the cleaned data
SELECT * FROM iom_dtm_cleaned;

-- Confirm record count
SELECT COUNT(*) AS total_cleaned FROM iom_dtm_cleaned;

-- Check unique countries
SELECT DISTINCT Country FROM iom_dtm_cleaned ORDER BY Country;

-- Verify data range
SELECT MIN(Year), MAX(Year) FROM iom_dtm_cleaned;

-- --------------------------- Export for Tableau -------------------------------

SELECT * FROM iom_dtm_cleaned;

-- SELECT admin0Name, yearReportingDate, displacementReason, SUM(numPresentIdpInd) AS total_idps
-- FROM iom_dtm
-- GROUP BY admin0Name, yearReportingDate, displacementReason;


