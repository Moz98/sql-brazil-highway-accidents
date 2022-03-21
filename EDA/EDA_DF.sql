--=========== DF_EDA ========================

SELECT *
FROM Accidents..DF_Sample 

---------- Número de Acidentes ------------------

-- Ano

SELECT Year, COUNT(Year) as YearNumber
FROM Accidents..DF_Sample
GROUP BY Year
ORDER BY 2 DESC

-- Mês
SELECT Month, COUNT(Month) as MonthNumber
FROM Accidents..DF_Sample
GROUP BY Month
ORDER BY 2 DESC

-- Dia da Semana
SELECT dia_semana, COUNT(dia_semana) as DWeekNumber
FROM Accidents..DF_Sample
GROUP BY dia_semana
ORDER BY 2 DESC

-- Fase do Dia
SELECT newFase_dia, COUNT(newFase_dia) as DWeekNumber
FROM Accidents..DF_Sample
GROUP BY newFase_dia
ORDER BY 2 DESC

-- Distribuição da quantidade de acidente ao longo do dia
SELECT newHour, COUNT (newHour)
FROM Accidents..DF_Sample 
GROUP BY newHour
ORDER BY newHour

---------- LOCALIDADE COM MAIOR NÚMERO DE ACIDENTES ----------------

-- BR 020 e 070 são as estradas mais perigosas de Brasília
-- A Estrada mais mortal de Brasília é a BR 020
-- Não houve uma diferença significativa nas mortes durantes os anos analidos
-- As maiores causas de acidentes mortais são: Falta de atenção à condução, Falta de Atenção do Pedestre e Velocidade Incompatível 


SELECT br, COUNT (br)
FROM Accidents..DF_Sample 
WHERE br IS NOT NULL
GROUP BY br 
ORDER BY 2 DESC

-- Estrada Mortal

SELECT br, COUNT (br)
FROM Accidents..DF_Sample 
WHERE br IS NOT NULL
AND classificacao_acidente = 'Com Vítimas Fatais'
GROUP BY br 
ORDER BY 2 DESC

-- Ano mais mortal

SELECT Year, COUNT (Year)
FROM Accidents..DF_Sample 
WHERE br IS NOT NULL
AND classificacao_acidente = 'Com Vítimas Fatais'
GROUP BY Year 
ORDER BY 2 DESC

-- Causa de Acidente Mais Mortal 

SELECT causa_acidente, COUNT (causa_acidente)
FROM Accidents..DF_Sample 
WHERE br IS NOT NULL
AND classificacao_acidente = 'Com Vítimas Fatais'
GROUP BY causa_acidente
ORDER BY 2 DESC

-- Pior acidente 

SELECT *
FROM Accidents..DF_Sample
WHERE mortos <> 0
ORDER BY mortos DESC