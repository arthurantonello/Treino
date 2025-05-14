-- Aula 13
-- Preciso saber quantas pessoas tem o mesmo nome do meio, agrupadas pelo nome do meio
SELECT MiddleName, COUNT(MiddleName) as 'Contagem de aparição'
FROM Person.Person
GROUP BY MiddleName;

-- Preciso saber em média qual a quantidade que cada produto é vendido na loja.
SELECT ProductID, AVG(OrderQty) as 'Média quantidade'
FROM Sales.SalesOrderDetail
GROUP BY ProductID;

-- Eu quero saber quais foram as 10 vendas que no total tiveram os maiores valores de venda por produto do maior para o menor valor
SELECT TOP 10 ProductID, SUM(LineTotal) AS 'Soma'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY Soma DESC;

-- Quantos produtos e qual a quantidade média de produtos temos cadastrados nas nossas ordem de serviço, agrupadas por ProductID
SELECT ProductID, COUNT(ProductID) AS 'Contagem',
AVG(OrderQty) AS 'Média'
FROM Production.WorkOrder
GROUP BY ProductID;