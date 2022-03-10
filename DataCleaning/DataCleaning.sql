--================ DATA CLEANING ======================---
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

---=---= Separate Data_inversa in Day, Month and Year ---=---= 

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

----- Year With Most Accidents -------
SELECT Year, COUNT(Year)
FROM #DataCleaningTotalAccidents
GROUP BY Year
ORDER BY 2 DESC

----- Month With Most Accidents -------
SELECT Month, COUNT(Month)
FROM #DataCleaningTotalAccidents
GROUP BY Month
ORDER BY 2 DESC

----- Day With Most Accidents -------
SELECT Day, COUNT(Day)
FROM #DataCleaningTotalAccidents
GROUP BY Day
ORDER BY 2 DESC


--=---=---=---= HORARIO =---=---=---=---= 

SELECT PARSENAME(CONVERT(nvarchar,CAST(horario AS TIME)), 2) AS newHour
FROM #DataCleaningTotalAccidents

SELECT  DISTINCT(PARSENAME(CONVERT(nvarchar,CAST(horario AS TIME)), 2))
FROM #DataCleaningTotalAccidents
ORDER BY 1 ASC

--- Common hour of accidents
ALTER TABLE #DataCleaningTotalAccidents
ADD newHour nvarchar(10)

UPDATE #DataCleaningTotalAccidents
SET newHour = PARSENAME(CONVERT(nvarchar,CAST(horario AS TIME)), 2)

SELECT newHour, COUNT(*) AS CommonHour
FROM #DataCleaningTotalAccidents
GROUP BY newHour
ORDER BY 2 DESC


---=---=---=---=  FASE-DIA = ---=---=---=---= 

--> Plena Noite : Between 20:00:00 and 04:00:00
--> Pleno dia : Between 07:00:00 and 16:00:00
--> Anoitecer : Between 17:00:00 and 19:00:00
--> Amanhecer : Between 05:00:00 and 06:00:00

SELECT DISTINCT(fase_dia)
FROM #DataCleaningTotalAccidents

SELECT newHour, COUNT(DISTINCT(fase_dia)) AS DifferentFase
FROM #DataCleaningTotalAccidents
GROUP BY newHour
HAVING COUNT(DISTINCT(fase_dia)) <> 1
ORDER BY 2

SELECT newHour, fase_dia -- Sample 
FROM #DataCleaningTotalAccidents
WHERE newHour = '16:40:00'


-------  Cleaning --------------

--Amanhecer
SELECT newHour
FROM #DataCleaningTotalAccidents
WHERE newHour LIKE '05%'
OR newHour LIKE '06%'
ORDER BY newHour

--Pleno dia
SELECT newHour
FROM #DataCleaningTotalAccidents
WHERE newHour LIKE '07%'
OR newHour LIKE '08%'
OR newHour LIKE '09%'
OR newHour LIKE '10%'
OR newHour LIKE '11%'
OR newHour LIKE '12%'
OR newHour LIKE '13%'
OR newHour LIKE '14%'
OR newHour LIKE '15%'
OR newHour LIKE '16%'
ORDER BY newHour


--Anoitecer
SELECT newHour
FROM #DataCleaningTotalAccidents
WHERE newHour LIKE '17%'
OR newHour LIKE '18%'
ORDER BY newHour

--Pleno noite
SELECT newHour
FROM #DataCleaningTotalAccidents
WHERE newHour LIKE '19%'
OR newHour LIKE '20%'
OR newHour LIKE '21%'
OR newHour LIKE '22%'
OR newHour LIKE '23%'
OR newHour LIKE '00%'
OR newHour LIKE '01%'
OR newHour LIKE '02%'
OR newHour LIKE '03%'
OR newHour LIKE '04%'
ORDER BY newHour


------ UPDATING THE DATA -----------
ALTER TABLE #DataCleaningTotalAccidents
ADD newFase_dia nvarchar (20)

-- New Amanhecer
UPDATE #DataCleaningTotalAccidents
SET newFase_dia = 'Amanhecer'
WHERE newHour LIKE '05%'
OR newHour LIKE '06%'

-- New Pleno dia
UPDATE #DataCleaningTotalAccidents
SET newFase_dia = 'Pleno dia'
WHERE newHour LIKE '07%'
OR newHour LIKE '08%'
OR newHour LIKE '09%'
OR newHour LIKE '10%'
OR newHour LIKE '11%'
OR newHour LIKE '12%'
OR newHour LIKE '13%'
OR newHour LIKE '14%'
OR newHour LIKE '15%'
OR newHour LIKE '16%'

-- New Anoitecer
UPDATE #DataCleaningTotalAccidents
SET newFase_dia = 'Anoitecer'
WHERE newHour LIKE '17%'
OR newHour LIKE '18%'

-- New Plena noite
UPDATE #DataCleaningTotalAccidents
SET newFase_dia = 'Plena noite'
WHERE newHour LIKE '19%'
OR newHour LIKE '20%'
OR newHour LIKE '21%'
OR newHour LIKE '22%'
OR newHour LIKE '23%'
OR newHour LIKE '00%'
OR newHour LIKE '01%'
OR newHour LIKE '02%'
OR newHour LIKE '03%'
OR newHour LIKE '04%'

-- NULL & Inconsistences VERIFICATION --

SELECT *
FROM #DataCleaningTotalAccidents
WHERE newFase_dia IS NULL

SELECT newHour, COUNT(DISTINCT(newHour)) AS DifferentFase
FROM #DataCleaningTotalAccidents
GROUP BY newHour
HAVING COUNT(DISTINCT(newHour)) <> 1
ORDER BY 2

---=---=---=---=  Condica_metereologica = ---=---=---=---= --
SELECT DISTINCT(condicao_metereologica )
FROM #DataCleaningTotalAccidents

SELECT * 
FROM #DataCleaningTotalAccidents
WHERE condicao_metereologica = 'Neve'


SELECT newFase_dia, condicao_metereologica, horario
FROM #DataCleaningTotalAccidents
WHERE newFase_dia = 'Plena noite'
AND condicao_metereologica = 'Sol'
ORDER BY 3 

SELECT newFase_dia, condicao_metereologica, horario
FROM #DataCleaningTotalAccidents
WHERE newFase_dia = 'Anoitecer'
AND condicao_metereologica = 'Sol'
ORDER BY 3 DESC












SELECT * 
FROM #DataCleaningTotalAccidents