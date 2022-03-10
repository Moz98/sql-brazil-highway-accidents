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

------------------------------------- EDA GERAL ----------------------------
-- UF

SELECT DISTINCT(uf)
FROM #TotalAccidents
ORDER BY uf

SELECT uf, COUNT(uf) As NumbersOfAccidents
FROM #TotalAccidents
GROUP BY uf
ORDER BY 2 DESC -- DF And ES has a similar number of vehicles and extension and a difference between the accidents


-- DATES 
-- Cleaning up to see common day, month, year (Ok)


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
ORDER BY data_inversa, horario 

-- Hour
--- Cleaning Up to see common hour of accidents (Ok)

-- CLIMATE CONDITIONS

SELECT DISTINCT(fase_dia)
FROM #TotalAccidents

-- Most Commmom Conditions

--- Cleaning up to adjust fase_dia with horario (OK)

SELECT fase_dia, COUNT(fase_dia) as MostCommonPhase
FROM #TotalAccidents
GROUP BY fase_dia
ORDER BY 2 DESC

SELECT fase_dia, horario
FROM #TotalAccidents
ORDER BY horario 


-- Most Commmom Conditions
--- Cleaning up fase_dia where has a inconsistence with the hour

SELECT DISTINCT(condicao_metereologica)
FROM #TotalAccidents

SELECT condicao_metereologica, COUNT(condicao_metereologica) As MostCommonCondition
FROM #TotalAccidents
GROUP BY condicao_metereologica
ORDER BY 2 DESC

SELECT fase_dia, condicao_metereologica, horario
FROM #TotalAccidents
WHERE fase_dia = 'Plena noite' AND
condicao_metereologica = 'Sol' -- Cleaning up 

--- TYPES OF ACCIDENTS

-- Type of accidents
SELECT DISTINCT(tipo_acidente)
FROM #TotalAccidents

--classification of accidents
SELECT DISTINCT(classificacao_acidente)
FROM #TotalAccidents 

SELECT classificacao_acidente, feridos
FROM #TotalAccidents
WHERE classificacao_acidente = 'Sem Vítimas' AND
feridos <> 0
ORDER BY Feridos

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

-- NULL VALUES

SELECT *
FROM #TotalAccidents

SELECT uf, municipio, latitude, longitude --Locations
FROM #TotalAccidents
WHERE uf is NULL OR
municipio IS NULL OR
latitude IS NULL OR
longitude IS NULL

SELECT dia_semana,data_inversa,horario -- Dates
FROM #TotalAccidents
WHERE dia_semana IS NULL OR
data_inversa IS NULL or
horario IS NULL

SELECT causa_acidente, tipo_acidente, classificacao_acidente, uop --Type Of Accident
FROM #TotalAccidents
WHERE causa_acidente is NULL OR
tipo_acidente is NULL OR
classificacao_acidente IS NULL

SELECT fase_dia, sentido_via, condicao_metereologica, tipo_pista, tracado_via -- Conditions
FROM #TotalAccidents
WHERE fase_dia IS NULL OR
sentido_via IS NULL OR
condicao_metereologica IS NULL OR
tipo_pista IS NULL OR
tracado_via IS NULL


