-- Objetivo: Pedidos para Brazil com >10 dias de atraso (RequiredDate - ShippedDate)
SELECT *
FROM Orders
WHERE ShipCountry = 'Brazil'
AND DATEDIFF(DAY, RequiredDate,ShippedDate) > 10

-- Objetivo: Calcule a média de dias entre OrderDate e ShippedDate
SELECT OrderID, CAST(OrderDate AS DATE) AS OrderDate,
				CAST(ShippedDate AS DATE) AS ShippedDate,
				AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) AS 'MediaDias'
FROM Orders
GROUP BY OrderID, CAST(OrderDate AS DATE), CAST(ShippedDate AS DATE)