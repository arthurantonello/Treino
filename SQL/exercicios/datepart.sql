-- Banco de dados Adventure Works 2017
-- Calcule o total de valor de vendas (TotalDue) agrupado por ano do OrderDate da tabela Sales.SalesOrderHeader.
SELECT DATEPART(YEAR, OrderDate), SUM(TotalDue) AS TotalVendas
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(YEAR, OrderDate)
ORDER BY DATEPART(YEAR, OrderDate) ASC;