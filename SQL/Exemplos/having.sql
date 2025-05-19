-- Aula 14
-- Estamos querendo identificar as provincias com o maior numero de cadastros no nosso sistema, então é preciso encontrar quais províncias estão registraads no banco de dados mais que 1000 vezes.
SELECT StateProvinceID, COUNT(StateProvinceID) AS 'Contagem'
FROM Person.Address
GROUP BY StateProvinceID
HAVING COUNT(StateProvinceID) > 1000;

-- Sendo que se trata de uma multinacional, os gerentes querem saber quais produtos não estão trazendo no mínimo 1 milhão no total de vendas em média
SELECT ProductID, AVG(LineTotal) AS 'Total de vendas'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(LineTotal) < 1000000;