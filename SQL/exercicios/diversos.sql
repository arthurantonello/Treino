-- Objetivo: Mostre CustomerID, CompanyName e City dos clientes brasileiros
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE Country = 'Brazil'


-- Objetivo: Exiba ProductName e UnitPrice dos produtos entre 10 e 50
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 10 AND 50
ORDER BY UnitPrice

-- Objetivo: Liste OrderID e Freight dos pedidos com frete caro
SELECT OrderID, Freight
FROM Orders
WHERE Freight > 100
ORDER BY Freight DESC

-- Objetivo: Encontre ProductName dos produtos descontinuados
SELECT ProductName, Discontinued
FROM Products
WHERE Discontinued = 1

-- Objetivo: Mostre CompanyName de clientes sem número de fax
SELECT *
FROM Customers
WHERE Fax is NULL

-- Objetivo: Liste os 5 produtos com maior UnitPrice
SELECT TOP 5 *
FROM Products
ORDER BY UnitPrice DESC