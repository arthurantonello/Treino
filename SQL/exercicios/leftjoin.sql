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

-- Categorias sem produtos
-- Liste os nomes das categorias que não têm nenhum produto associado.

SELECT *
FROM Categories
	LEFT JOIN Products
	ON Categories.CategoryID = Products.CategoryID
WHERE Products.CategoryID IS NULL

--  Regiões com seus funcionários
-- Liste todas as regiões, com os nomes dos funcionários que atuam nelas. Inclua as regiões mesmo que não tenham nenhum funcionário.

SELECT
	Region.RegionDescription,
	CONCAT(Employees.FirstName, ' ', Employees.LastName) Funcionario
FROM Region
	LEFT JOIN Territories
	ON Region.RegionID = Territories.RegionID
	LEFT JOIN EmployeeTerritories
	ON Territories.TerritoryID = EmployeeTerritories.TerritoryID
	LEFT JOIN Employees
	ON EmployeeTerritories.EmployeeID = Employees.EmployeeID
GROUP BY 
	Region.RegionDescription, 
	CONCAT(Employees.FirstName, ' ', Employees.LastName)

-- Produtos com e sem vendas
-- Liste todos os produtos, com o total de unidades vendidas de cada um (se não vendeu nada, mostrar 0 ou NULL).

SELECT
	Products.ProductName,
	SUM([Order Details].Quantity) AS Quantidade
FROM Products
	LEFT JOIN [Order Details]
	ON Products.ProductID = [Order Details].ProductID
GROUP BY Products.ProductName
ORDER BY Quantidade DESC

-- Para cada funcionário, exiba o ID do funcionário e o nome do território associado,
-- incluindo funcionários que não pertençam a nenhum território.

SELECT
	Employees.EmployeeID,
	Territories.TerritoryDescription
FROM 
	Employees
	LEFT JOIN EmployeeTerritories
		ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
	LEFT JOIN Territories
		ON EmployeeTerritories.TerritoryID = Territories.TerritoryID


-- Para o cliente com CustomerID 'ALFKI', liste o ID do pedido, o ID do produto e
-- a soma das quantidades pedidas nos pedidos em que a quantidade total de um mesmo
-- produto seja maior ou igual a 2.


SELECT
	Orders.OrderID,
	[Order Details].ProductID,
	SUM([Order Details].Quantity) AS TotalPedido
FROM 
	Orders
	LEFT JOIN [Order Details]
		ON Orders.OrderID = [Order Details].OrderID
	LEFT JOIN Customers
		ON Orders.CustomerID = Customers.CustomerID
WHERE 
	Customers.CustomerID = 'ALFKI'
GROUP BY 
	Orders.OrderID,
	[Order Details].ProductID
HAVING 
	SUM([Order Details].Quantity) >= 2
ORDER BY 
	TotalPedido

-- Liste o nome da categoria e a quantidade de produtos que pertencem a ela,
-- incluindo categorias sem produtos cadastrados.

SELECT
	Categories.CategoryName,
	COUNT(Products.ProductID) TotalProdutos
FROM 
	Categories
	LEFT JOIN Products
		ON Categories.CategoryID = Products.CategoryID
GROUP BY
	Categories.CategoryName

-- Liste o nome de cada fornecedor e a quantidade de produtos fornecidos,
-- exibindo também fornecedores que não possuam produtos.

SELECT
	Suppliers.CompanyName Fornecedor,
	COUNT(Products.ProductID) TotalProdutos
FROM 
	Suppliers
	LEFT JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
GROUP BY
	Suppliers.CompanyName

-- Para cada produto, mostre o ProductName e o número de pedidos em que ele aparece,
-- incluindo produtos que nunca foram pedidos.

SELECT
	Products.ProductName,
	COUNT([Order Details].ProductID) TotalProduto
FROM
	Products
	LEFT JOIN [Order Details]
		ON Products.ProductID = [Order Details].ProductID
GROUP BY
	Products.ProductName,
	Products.ProductID
ORDER BY
	Products.ProductID


-- Apresente o nome do fornecedor e a quantidade de produtos descontinuados (Discontinued = 1),
-- incluindo fornecedores que não tenham nenhum produto descontinuado.

SELECT
	Suppliers.CompanyName,
	COUNT(Products.ProductID) ProdutosDescontinuados
FROM 
	Suppliers
	LEFT JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
		AND Products.Discontinued = 1
GROUP BY 
	Suppliers.CompanyName
HAVING 
	COUNT(Products.ProductID) >= 1


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



