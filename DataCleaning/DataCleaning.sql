------------------------------- DATA CLEANING ------------------------------
DROP TABLE IF EXISTS #DataCleaningTotalAccidents

WITH CTE_TotalAccidents As (
SELECT *
	FROM Accidents..datatran2017$
	UNION
	SELECT *
	FROM Accidents..datatran2018$
	UNION
	SELECT *
	FROM Accidents..datatran2019$
	UNION
	SELECT *
	FROM Accidents..datatran2020$
)
SELECT *
INTO #DataCleaningTotalAccidents
FROM CTE_TotalAccidents

SELECT *
FROM #DataCleaningTotalAccidents

-- DATA_INVERSA
SELECT data_inversa, CONVERT(DATE,data_inversa)
FROM #DataCleaningTotalAccidents

ALTER TABLE #DataCleaningTotalAccidents
ADD Data_Inversa2 DATE;

UPDATE #DataCleaningTotalAccidents
SET data_inversa2 = CONVERT(DATE,data_inversa)

-- Separate Data_inversa in Day, Month and Year

SELECT data_inversa2,
DATEPART(DAY, data_inversa2) As Day,
DATEPART(MONTH, data_inversa2) As Month,
DATEPART(YEAR, data_inversa2) As Year
FROM #DataCleaningTotalAccidents

------------- Day----------------------
ALTER TABLE #DataCleaningTotalAccidents
ADD Day INT;

UPDATE #DataCleaningTotalAccidents
SET Day = DATEPART(DAY, data_inversa2)

-------------Month-------------------
ALTER TABLE #DataCleaningTotalAccidents
ADD Month INT;

UPDATE #DataCleaningTotalAccidents
SET Month = DATEPART(MONTH,data_inversa2)

----------------Year-----------------
ALTER TABLE #DataCleaningTotalAccidents
ADD Year INT;

UPDATE #DataCleaningTotalAccidents
SET Year = DATEPART(YEAR,data_inversa2)

------- NULL Verification ----------------
SELECT Day,Month,Year
FROM #DataCleaningTotalAccidents
WHERE Day IS NULL OR
Month IS NULL OR
Year IS NULL

-- HORARIO

SELECT PARSENAME(CONVERT(nvarchar,CAST(horario AS TIME)), 2) AS newHour
FROM #DataCleaningTotalAccidents

SELECT  DISTINCT(PARSENAME(CONVERT(nvarchar,CAST(horario AS TIME)), 2))
FROM #DataCleaningTotalAccidents
ORDER BY 1 ASC

---
ALTER TABLE #DataCleaningTotalAccidents
ADD newHour nvarchar(10)

UPDATE #DataCleaningTotalAccidents
SET newHour = PARSENAME(CONVERT(nvarchar,CAST(horario AS TIME)), 2)

--FASE-DIA

SELECT horario, newHour
FROM #DataCleaningTotalAccidents
