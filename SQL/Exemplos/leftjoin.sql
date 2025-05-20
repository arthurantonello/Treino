-- Banco de dados Adventure Works 2017

-- Descobrir quais pessoas tem um cartão de crédito registrado, tabelas person.person e sales.PersonCreditCard
SELECT *
FROM Person.Person AS PP
LEFT JOIN Sales.PersonCreditCard AS PCC
ON pp.BusinessEntityID = pcc.BusinessEntityID
WHERE pcc.CreditCardID IS NULL;


-- Banco de dados Northwind

-- Identifique clientes que não fizeram nenhum pedido após 1º de janeiro de 1997
SELECT C.*, O.OrderDate
FROM Customers AS C 
	LEFT JOIN Orders AS O
	ON C.CustomerID = O.CustomerID
	AND O.OrderDate > '1997-01-01' 
WHERE O.OrderID is NULL

-- Objetivo: Soma de Freight agrupado por país do cliente
SELECT C.Country, 
		SUM(O.Freight) AS 'Soma'
FROM Customers AS C
LEFT JOIN Orders AS O --Incluindo país sem pedido com left
ON  C.CustomerID = O.CustomerID
GROUP BY C.Country
ORDER BY Soma DESC

-- Objetivo: Liste ProductName dos produtos sem vendas
SELECT P.ProductID, P.ProductName
FROM Products AS P
	LEFT JOIN [Order Details] AS OD 
	ON P.ProductID = OD.ProductID
WHERE OD.ProductID IS NULL;

-- Para funcionar nessa tabela, inserir um produto sem venda
INSERT INTO Products (ProductName, Discontinued) 
VALUES ('Produto Teste Sem Vendas', 0);

SELECT 
	Customers.CompanyName, 
	Orders.OrderID
FROM Customers
	LEFT JOIN Orders
	ON Customers.CustomerID = Orders.CustomerID
ORDER BY Orders.OrderID

--

SELECT Employees.FirstName, Orders.OrderID
FROM Employees
	LEFT JOIN Orders
	ON Employees.EmployeeID = Orders.EmployeeID
ORDER BY Orders.OrderID

--

SELECT 
	Categories.CategoryName,
	Products.ProductName
FROM Categories
	LEFT JOIN Products
	ON Categories.CategoryID = Products.CategoryID

SELECT Products.ProductName
FROM Products

--

SELECT
	CONCAT(Employees1.FirstName, ' ', Employees1.LastName) Funcionario,
	CONCAT(Employees2.FirstName, ' ', Employees2.LastName) Supervisor
FROM Employees Employees1
	LEFT JOIN Employees Employees2
	ON Employees1.ReportsTo = Employees2.EmployeeID

--

SELECT
	Products.ProductName,
	Categories.CategoryName,
	Suppliers.CompanyName
FROM Products
	LEFT JOIN Categories
	ON Products.CategoryID = Categories.CategoryID
	LEFT JOIN Suppliers
	ON Products.SupplierID = Suppliers.SupplierID

--

SELECT *
FROM Customers
	LEFT JOIN Orders
	ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL
ORDER BY Customers.CustomerID

--

SELECT 
	Products.ProductName,
	COUNT(ODETAILS.ProductID) TotalPedidos
FROM Products
	LEFT JOIN [Order Details] ODETAILS
	ON Products.ProductID = ODETAILS.ProductID
GROUP BY Products.ProductName
ORDER BY TotalPedidos

--

SELECT Employees.FirstName
FROM Employees
	LEFT JOIN Orders
	ON Employees.EmployeeID = Orders.EmployeeID
WHERE Orders.OrderID IS NULL

--

SELECT 
	Categories.CategoryName,
	COUNT(Products.CategoryID) Quantidade
FROM Categories
	LEFT JOIN Products
	ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName

--

SELECT 
	Orders.OrderID,
	Orders.OrderDate,
	Customers.CompanyName,
	STRING_AGG(Products.ProductName, ',') Products
FROM Orders
	INNER JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID
	INNER JOIN [Order Details] ODETAILS
	ON Orders.OrderID = ODETAILS.OrderID
	INNER JOIN Products
	ON ODETAILS.ProductID = Products.ProductID
GROUP BY 
	Orders.OrderID,
	Orders.OrderDate,
	Customers.CompanyName

SELECT *
FROM [Order Details]

-- Liste os nomes dos clientes e os nomes dos funcionários responsáveis pelos pedidos realizados, com a data do pedido.
SELECT 
	Customers.CompanyName,
	Employees.FirstName Responsavel,
	Orders.OrderDate
FROM Orders
	INNER JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID
	INNER JOIN Employees
	ON Orders.EmployeeID = Employees.EmployeeID;

-- Exiba todos os produtos e, quando disponíveis, os nomes dos fornecedores.

SELECT 
	Products.*,
	Suppliers.CompanyName Fornecedor
FROM Products
	LEFT JOIN Suppliers
	ON Products.SupplierID = Suppliers.SupplierID

-- Mostre os nomes das categorias e a quantidade de produtos que pertencem a cada categoria.

SELECT 
	Categories.CategoryName,
	COUNT(Products.CategoryID) Quantidade
FROM Categories
	LEFT JOIN Products
	ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName

-- Liste os nomes dos clientes e os nomes das cidades onde ocorreram pedidos. Se o cliente nunca tiver feito pedido, ainda assim mostre seu nome.

SELECT
	Customers.CompanyName,
	Orders.ShipCity
FROM Customers
	LEFT JOIN Orders
	ON Customers.CustomerID = Orders.CustomerID

--

-- Mostre os nomes dos funcionários e os nomes das regiões associadas aos seus territórios.

SELECT
	CONCAT(Employees.FirstName, ' ', Employees.LastName) Funcionario,
	STRING_AGG( Region.RegionDescription, ', ')
FROM Employees
	LEFT JOIN EmployeeTerritories
	ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
	LEFT JOIN Territories
	ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
	LEFT JOIN Region
	ON Territories.RegionID = Region.RegionID
GROUP BY 
	CONCAT(Employees.FirstName, ' ', Employees.LastName)

-- Mostre os nomes dos funcionários e quantos pedidos cada um participou, incluindo os que ainda não fizeram nenhum pedido.

SELECT 
	CONCAT(Employees.FirstName, ' ', Employees.LastName) Funcionario,
	COUNT(Orders.OrderID)
FROM Employees
	LEFT JOIN Orders
	ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY 
	CONCAT(Employees.FirstName, ' ', Employees.LastName)

-- Liste todos os clientes que fizeram pedidos, com o nome da empresa transportadora usada em cada entrega.

SELECT 
	Customers.CompanyName Cliente,
	Shippers.CompanyName Transportadora
FROM Orders
	INNER JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID
	LEFT JOIN Shippers -- LEFT aqui pois não necessariamente o Customer enviou o produto, por exemplo
	ON Orders.ShipVia = Shippers.ShipperID

-- Para cada categoria, exiba o nome da categoria e a média de preços dos produtos associados.

SELECT 
	Categories.CategoryName,
	STRING_AGG(Products.ProductName, ', ') Produtos,
	AVG(Products.UnitPrice) MediaPreço
FROM Categories
	LEFT JOIN Products
	ON Categories.CategoryID = Products.CategoryID
GROUP BY 
	Categories.CategoryName
ORDER BY Categories.CategoryName

-- Mostre os nomes dos produtos que ainda não foram vendidos.

SELECT 
	Products.ProductName
FROM Products
	LEFT JOIN [Order Details]
	ON [Order Details].ProductID = Products.ProductID
WHERE [Order Details].ProductID IS NULL

-- Liste o nome de todos os clientes e o total de pedidos que fizeram, incluindo aqueles que não fizeram nenhum.

SELECT
	Customers.CompanyName,
	Orders.OrderID
FROM Customers
	LEFT JOIN Orders
	ON Customers.CustomerID = Orders.CustomerID
ORDER BY Orders.OrderID