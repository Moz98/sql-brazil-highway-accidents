--=========== DF_EDA ========================

SELECT *
FROM Accidents..DF_Sample 

---------- N�mero de Acidentes ------------------

-- Ano

SELECT Year, COUNT(Year) as YearNumber
FROM Accidents..DF_Sample
GROUP BY Year
ORDER BY 2 DESC

-- M�s
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

-- Distribui��o da quantidade de acidente ao longo do dia
SELECT newHour, COUNT (newHour)
FROM Accidents..DF_Sample 
GROUP BY newHour
ORDER BY newHour

---------- LOCALIDADE COM MAIOR N�MERO DE ACIDENTES ----------------

-- BR 020 e 070 s�o as estradas mais perigosas de Bras�lia
-- A Estrada mais mortal de Bras�lia � a BR 020
-- N�o houve uma diferen�a significativa nas mortes durantes os anos analidos
-- As maiores causas de acidentes mortais s�o: Falta de aten��o � condu��o, Falta de Aten��o do Pedestre e Velocidade Incompat�vel 


SELECT br, COUNT (br)
FROM Accidents..DF_Sample 
WHERE br IS NOT NULL
GROUP BY br 
ORDER BY 2 DESC

-- Estrada Mortal

SELECT br, COUNT (br)
FROM Accidents..DF_Sample 
WHERE br IS NOT NULL
AND classificacao_acidente = 'Com V�timas Fatais'
GROUP BY br 
ORDER BY 2 DESC

-- Ano mais mortal

SELECT Year, COUNT (Year)
FROM Accidents..DF_Sample 
WHERE br IS NOT NULL
AND classificacao_acidente = 'Com V�timas Fatais'
GROUP BY Year 
ORDER BY 2 DESC

-- Causa de Acidente Mais Mortal 

SELECT causa_acidente, COUNT (causa_acidente)
FROM Accidents..DF_Sample 
WHERE br IS NOT NULL
AND classificacao_acidente = 'Com V�timas Fatais'
GROUP BY causa_acidente
ORDER BY 2 DESC

-- Pior acidente 

SELECT *
FROM Accidents..DF_Sample
WHERE mortos <> 0
ORDER BY mortos DESC