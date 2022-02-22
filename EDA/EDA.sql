--------------------- DATA COPILATION -----------------------------------------

DROP TABLE IF EXISTS #TotalAccidents 

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
INTO #TotalAccidents
FROM CTE_TotalAccidents

SELECT *
FROM #TotalAccidents;

------------------------------------- EDA ----------------------------
-- By Uf
SELECT DISTINCT(uf)
FROM #TotalAccidents
ORDER BY uf

SELECT uf, COUNT(uf) As NumbersOfAccidents
FROM #TotalAccidents
GROUP BY uf
ORDER BY 2 DESC -- DF And ES has a similar number of vehicles and extension and a difference between the accidents


-- By Dates

-- Most Commum Dates of Accidents
SELECT dia_semana, COUNT(dia_semana) As DayOfTheWeek
FROM #TotalAccidents
GROUP BY dia_semana
ORDER BY 2 DESC

SELECT data_inversa,horario
FROM #TotalAccidents
ORDER BY data_inversa, horario -- The day switch on Mid Night

SELECT data_inversa,horario
FROM #TotalAccidents
WHERE dia_semana = 'segunda-feira'
ORDER BY data_inversa, horario -- Cleaning Up to see common hour of accidents 


SELECT uf, dia_semana, COUNT(dia_semana) AS MostCommon
FROM #TotalAccidents
WHERE uf = 'MG'
GROUP BY uf, dia_semana
ORDER BY MostCommon DESC -- Como fazer para retornar o dia mais comum de acidentes em cada Estado ?_?


-- Climate Conditions
SELECT DISTINCT(fase_dia)
FROM #TotalAccidents

SELECT fase_dia, horario
FROM #TotalAccidents
ORDER BY horario -- Cleaning up to adjust fase_dia with horario, has some incosistencies (Partition By)

SELECT DISTINCT(condicao_metereologica)
FROM #TotalAccidents

SELECT fase_dia, condicao_metereologica, horario
FROM #TotalAccidents
WHERE fase_dia = 'Plena noite' AND
condicao_metereologica = 'Sol' -- Cleaning up 

--- TYPES OF ACCIDENTS

-- Type of accidents
SELECT DISTINCT(tipo_acidente)
FROM #TotalAccidents

SELECT tipo_acidente
FROM #TotalAccidents
WHERE tipo_acidente IS NULL -- = 0

--classification of accidents
SELECT DISTINCT(classificacao_acidente)
FROM #TotalAccidents 

SELECT classificacao_acidente
FROM #TotalAccidents
WHERE classificacao_acidente IS NULL -- = 0

SELECT classificacao_acidente, feridos
FROM #TotalAccidents
WHERE classificacao_acidente = 'Com Vítimas Feridas'
ORDER BY Feridos

SELECT classificacao_acidente, feridos_graves, mortos
FROM #TotalAccidents
WHERE classificacao_acidente = 'Com Vítimas Fatais'
ORDER BY 2


-- Major number of accidents	
SELECT classificacao_acidente, COUNT(classificacao_acidente)
FROM #TotalAccidents
GROUP BY classificacao_acidente
ORDER BY 2 DESC

SELECT *
FROM #TotalAccidents