-- Objetivo: Conte pedidos agrupados por mês/ano
SELECT MONTH(OrderDate) AS Mes,
		YEAR(OrderDate) AS Ano,
		COUNT(OrderID) AS TotalPedidos
FROM Orders
GROUP BY MONTH(OrderDate), YEAR(OrderDate)
ORDER BY Ano, Mes