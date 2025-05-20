-- Banco de dados Adventure Works 2017
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

-- Liste os CustomerID da tabela Sales.SalesOrderHeader que realizaram mais de 10 pedidos, exibindo também a contagem total de pedidos.
SELECT CustomerID, COUNT(CustomerID) as TotalPedido
FROM sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(CustomerID) > 5
ORDER BY COUNT(CustomerID) DESC;


-- Banco de dados Northwind
-- Objetivo: Calcule a média de UnitPrice por SupplierID
SELECT SupplierID, AVG(UnitPrice) AS Média
FROM Products
GROUP BY SupplierID