-- Retorne o EmployeeID e o número de territórios associados a cada funcionário,
-- listando também funcionários que não estejam associados a nenhum território.

SELECT
	Employees.EmployeeID,
	COUNT(EmployeeTerritories.TerritoryID) TotalTerritorios
FROM Employees
	LEFT JOIN EmployeeTerritories
		ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
GROUP BY
	Employees.EmployeeID


-- Exiba o CustomerID e a quantidade de pedidos cujo valor total (UnitPrice * Quantity) exceda 1000,
-- considerando apenas clientes que tenham ao menos um pedido assim.
SELECT
	Total.CustomerID,
	COUNT(*) TotalPedidos
FROM (
	SELECT
		Orders.OrderID,
		Orders.CustomerID,
		SUM([Order Details].UnitPrice * [Order Details].Quantity) ValorTotal
	FROM 
		[Order Details]
		INNER JOIN Orders
			ON [Order Details].OrderID = Orders.OrderID
	GROUP BY
		Orders.OrderID,
		Orders.CustomerID
	HAVING
		SUM([Order Details].UnitPrice * [Order Details].Quantity) > 1000) Total
GROUP BY
	Total.CustomerID



-- Liste o CustomerID e o número de anos distintos em que cada cliente fez pedidos,
-- exibindo apenas aqueles com pedidos em mais de 2 anos diferentes.

SELECT DISTINCT
	Orders.CustomerID,
	COUNT(DISTINCT YEAR(Orders.OrderDate)) AnosDistintos
FROM 
	Orders
GROUP BY
	Orders.CustomerID
HAVING 
	COUNT(DISTINCT YEAR(Orders.OrderDate)) > 2


-- Mostre o ProductName e o nome do fornecedor para produtos da categoria 'Beverages'
-- cujo UnitPrice seja maior que a média de UnitPrice de todos os produtos dessa categoria.

SELECT
	Products.ProductName,
	Suppliers.CompanyName Fornecedor
FROM 
	Products
	INNER JOIN Categories
		ON Products.CategoryID = Categories.CategoryID
	INNER JOIN Suppliers
		ON Products.SupplierID = Suppliers.SupplierID
WHERE 
	Categories.CategoryName = 'Beverages'
	AND Products.UnitPrice > (
		SELECT
			AVG(Products.UnitPrice)
		FROM
			Products
		WHERE 
			Products.CategoryID = Categories.CategoryID)


-- Para cada cliente, apresente o CustomerID e o número de produtos distintos que ele já encomendou,
-- incluindo apenas clientes com mais de 10 produtos distintos.

SELECT
	Orders.CustomerID,
	COUNT(DISTINCT [Order Details].ProductID) QtdEncomendado
FROM 
	Orders
	INNER JOIN [Order Details]
		ON Orders.OrderID = [Order Details].OrderID
GROUP BY
	Orders.CustomerID
HAVING
	COUNT(DISTINCT [Order Details].ProductID) > 10
	
