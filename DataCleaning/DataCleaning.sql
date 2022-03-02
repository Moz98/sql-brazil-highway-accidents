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

SELECT data_inversa2
FROM #DataCleaningTotalAccidents

-- Separate Data_inversa in Day, Month and Year



-- HORARIO


--FASE-DIA