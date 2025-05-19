-- Objetivo: Calcule a média de dias entre OrderDate e ShippedDate

SELECT OrderID, CAST(OrderDate AS DATE) AS OrderDate,
				CAST(ShippedDate AS DATE) AS ShippedDate,
				AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) AS 'MediaDias'
FROM Orders
GROUP BY OrderID, CAST(OrderDate AS DATE), CAST(ShippedDate AS DATE)