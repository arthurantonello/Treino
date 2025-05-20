-- Banco de dados Adventure Works 2017
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

-- Banco de dados Northwind

-- Valor Médio de Pedido por Cliente
--   • Para cada CustomerID, mostre o total médio de TotalDue em pedidos
--   • Use subconsulta (ou CTE) para calcular o AVG(TotalDue)
--   • Exiba apenas clientes cujo AVG(TotalDue) > 500

SELECT CustomerID, 
		AVG(TotalDue) AS Media
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING AVG(TotalDue) > (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader)
ORDER BY Media DESC;

-- Inventário Atual vs. Ponto de Reposição
--    • Mostre ProductID, Name, EstoqueAtual e ReorderPoint
--    • EstoqueAtual = SUM(pi.Quantity) em Production.ProductInventory
--    • ReorderPoint está em Production.Product
--    • Filtre apenas produtos cujo EstoqueAtual < ReorderPoint
SELECT p.ProductID, p.Name, SUM(pi.Quantity) EstoqueAtual,
		P.ReorderPoint
FROM Production.ProductInventory pi
	INNER JOIN Production.Product p
	ON pi.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name, p.ReorderPoint
HAVING SUM(pi.Quantity) < p.ReorderPoint
ORDER BY p.Name;