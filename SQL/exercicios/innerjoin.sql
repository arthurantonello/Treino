-- Banco de dados Adventure Works 2017

-- Juntar as informações BusinessEntityId, Name, PhoneNumberTypeID e PhoneNumber da tabela person.PhoneNumberType e person.PersonPhone
SELECT TOP 10 pp.BusinessEntityId, pnt.Name, pnt.PhoneNumberTypeID, pp.PhoneNumber
FROM Person.PhoneNumberType AS PNT
INNER JOIN Person.PersonPhone AS PP 
ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;

-- Juntar o AdressId, City, StateProvinceId e o Name das tabelas person.StateProvince e person.Adress
SELECT a.AddressID, a.City, st.StateProvinceID, st.Name
FROM Person.StateProvince AS ST
INNER JOIN Person.Address AS A
ON st.StateProvinceID = a.StateProvinceID;

-- Retorne todos os endereços que estão no estado de 'Alberta'
SELECT PA.*
FROM Person.Address AS PA
INNER JOIN Person.StateProvince AS SP
ON PA.StateProvinceID = SP.StateProvinceID
AND SP.Name = 'Alberta'

    -- Daria para fazer esse mesmo utilizando SUBQUERY
    SELECT *
    FROM Person.Address
    WHERE StateProvinceID = (
        SELECT StateProvinceID
        FROM Person.StateProvince
        WHERE Name = 'Alberta')

-- Retorne o nome dos funcionários que tem o cargo de 'Design Engineer'
SELECT p.FirstName
FROM Person.Person AS P
INNER JOIN HumanResources.Employee AS E
ON p.BusinessEntityID = e.BusinessEntityID
AND e.JobTitle = 'Design Engineer'

    -- Daria para fazer esse mesmo utilizando SUBQUERY
    SELECT FirstName
    FROM Person.Person
    WHERE BusinessEntityID in (
        SELECT BusinessEntityID 
        FROM HumanResources.Employee 
        WHERE JobTitle = 'Design Engineer');

-- Para cada categoria de produto (ProductCategory), exiba o nome do produto mais caro (baseado em ListPrice da Product).
SELECT Categoria, Produto, ListPrice
FROM (
    SELECT 
        pc.Name AS Categoria,
        p.Name AS Produto, p.ListPrice,
        ROW_NUMBER() OVER (
            PARTITION BY pc.ProductCategoryID
            ORDER BY p.ListPrice DESC
        ) AS rn
    FROM Production.Product p
    INNER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    INNER JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    WHERE p.ListPrice > 0
) AS ProdutosComRanking
WHERE rn = 1
ORDER BY Categoria;


-- Banco de dados Northwind

-- Objetivo: Liste produtos com estoque < 20 da categoria "Beverages"
SELECT P.ProductName, P.UnitsInStock
FROM Products AS P
	INNER JOIN Categories as C
	ON C.CategoryName = 'Beverages'
WHERE P.UnitsInStock < 20

-- Calcule o total de vendas (em valor monetário) por funcionário em 1996, ordenado do maior para o menor
SELECT 
    E.EmployeeID,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalSales
FROM 
    Orders AS O
    INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
    INNER JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
WHERE 
    O.OrderDate BETWEEN '1996-01-01' AND '1996-12-31'
GROUP BY 
    E.EmployeeID, E.FirstName, E.LastName
ORDER BY 
    TotalSales DESC;

-- Objetivo: Conte quantos produtos existem em cada categoria
SELECT P.CategoryID, C.CategoryName, COUNT(P.CategoryID) AS Count
FROM Products AS P
	INNER JOIN Categories AS C
	ON P.CategoryID = C.CategoryID
GROUP BY P.CategoryID, C.CategoryName

-- Objetivo: Calcule a média de UnitPrice por SupplierID
SELECT S.SupplierID, S.CompanyName AS Fornecedor,
		ROUND(AVG(P.UnitPrice), 2) AS MediaPreco,
		COUNT(P.ProductID) AS QtdProdutos
FROM Products P
    INNER JOIN Suppliers AS S
	ON P.SupplierID = S.SupplierID
GROUP BY S.SupplierID, S.CompanyName
ORDER BY MediaPreco DESC

-- Objetivo: Pedidos que têm mais de 2 tipos de produtos
SELECT O.OrderID, COUNT(OD.ProductID) AS QtdProdutos,
		SUM(OD.UnitPrice * OD.Quantity) AS TotalPedido
FROM Orders AS O
	INNER JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
GROUP BY O.OrderID
HAVING (COUNT(OD.ProductID) >= 2)
ORDER BY QtdProdutos DESC

-- Objetivo: Mostre EmployeeID e lista de TerritoryIDs associados
SELECT E.EmployeeID, E.FirstName + ' ' + E.LastName AS EmployeeName, 
	STRING_AGG(CAST(ET.TerritoryID AS VARCHAR), ',') AS Territories
FROM Employees AS E
	INNER JOIN EmployeeTerritories AS ET
	ON E.EmployeeID = ET.EmployeeID
GROUP BY 
    E.EmployeeID, E.FirstName, E.LastName

    -- Objetivo: Soma de (UnitPrice*Quantity) agrupada por CategoryName
SELECT C.CategoryName, 
		SUM(OD.UnitPrice * Quantity) AS TotalVendas
FROM [Order Details] AS OD
	INNER JOIN Products AS P
	ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS C
	ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName
ORDER BY TotalVendas DESC

-- Listar Produtos por Categoria e Preço
--   • Exiba o nome da categoria, nome do produto e ListPrice
--   • Filtre apenas produtos com ListPrice ≥ 1000
--   • Use JOIN entre Production.Product → ProductSubcategory → ProductCategory
SELECT Categoria, Produto, Preco
FROM (
	SELECT pc.Name AS Categoria,
	p.Name AS Produto, p.ListPrice AS Preco
	FROM Production.Product AS p
    INNER JOIN Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    INNER JOIN Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID
    WHERE p.ListPrice > 0
) AS Subquery
WHERE Preco >= 1000;


-- Clientes e Quantidade de Pedidos
--   • Mostre FirstName, LastName e total de pedidos feitos
--   • Considere apenas clientes com pelo menos 1 pedido
--   • Use JOIN Sales.Customer → Sales.SalesOrderHeader e GROUP BY

SELECT CONCAT(p.FirstName,' ', p.LastName) AS Cliente,
		COUNT(sh.SalesOrderID) AS TotalPedidos
FROM Sales.Customer c
	INNER JOIN Person.Person p
	ON C.PersonID = p.BusinessEntityID
	INNER JOIN Sales.SalesOrderHeader sh
	ON c.CustomerID = sh.CustomerID
GROUP BY CONCAT(p.FirstName,' ', p.LastName)
ORDER BY TotalPedidos DESC;

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

--

SELECT Orders.OrderID, Customers.CompanyName, Orders.OrderDate 
FROM Orders
	INNER JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID

--

SELECT Products.ProductName, Categories.CategoryName
FROM Products
	INNER JOIN Categories
	ON Products.CategoryID = Categories.CategoryID

--

SELECT
	Orders.OrderID, 
	CONCAT(Employees.FirstName, ' ', Employees.LastName) AS 'Nome Completo', 
	Orders.OrderDate
FROM Orders
	INNER JOIN Employees
	ON Orders.EmployeeID = Employees.EmployeeID
--

SELECT 
	ODETAILS.OrderID,
	Products.ProductName, 
	ODETAILS.Quantity
FROM [Order Details] AS ODETAILS
	INNER JOIN Products
	ON ODETAILS.ProductID = Products.ProductID

--

SELECT 
	Orders.OrderID,
	Customers.CompanyName,
	Orders.ShipCountry
FROM Orders
	INNER JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID

-- Para cada produto que já foi vendido, exiba o nome do produto, o nome do funcionário que participou do pedido e a data da venda.

SELECT 
	Products.ProductName,
	CONCAT(Employees.FirstName, ' ', Employees.LastName) Funcionario,
	Orders.OrderDate
FROM [Order Details]
	INNER JOIN Products
	ON [Order Details].ProductID = Products.ProductID
	INNER JOIN Orders
	ON [Order Details].OrderID = Orders.OrderID
	INNER JOIN Employees
	ON Orders.EmployeeID = Employees.EmployeeID
ORDER BY OrderDate

-- Liste os nomes de todos os produtos, juntamente com o nome da categoria e o nome do fornecedor correspondente (apenas produtos com categoria e fornecedor cadastrados).

SELECT
	Products.ProductName,
	Categories.CategoryName,
	Suppliers.CompanyName
FROM Products
	INNER JOIN Categories
	ON Products.CategoryID = Categories.CategoryID
	INNER JOIN Suppliers
	ON Products.SupplierID = Suppliers.SupplierID

-- Liste todos os clientes que fizeram pedidos, com o nome da empresa transportadora usada em cada entrega.

SELECT 
	Customers.CompanyName Cliente,
	Shippers.CompanyName Transportadora
FROM Orders
	INNER JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID
	LEFT JOIN Shippers -- LEFT aqui pois não necessariamente o Customer enviou o produto, por exemplo
	ON Orders.ShipVia = Shippers.ShipperID

--Liste os nomes das categorias que têm pelo menos um produto com o estoque abaixo de 10 unidades.

SELECT *
FROM Products
	INNER JOIN Categories
	ON Products.CategoryID = Categories.CategoryID
WHERE Products.UnitsInStock < 10
ORDER BY Products.UnitsInStock DESC

--Mostre os fornecedores que oferecem ao menos um produto com preço superior a R$100.

SELECT
	Suppliers.CompanyName,
	Products.ProductName,
	Products.UnitPrice
FROM Products
	INNER JOIN Suppliers
	ON Products.SupplierID = Suppliers.SupplierID
WHERE Products.UnitPrice > 100
ORDER BY Products.UnitPrice


--Liste os funcionários que trabalham em territórios com mais de 5 caracteres no nome.

SELECT 
	Employees.FirstName,
	Territories.TerritoryDescription
FROM Employees
	INNER JOIN EmployeeTerritories
	ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
	INNER JOIN Territories
	ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
WHERE LEN(Territories.TerritoryDescription) > 5
ORDER BY LEN(Territories.TerritoryDescription) ASC

-- Liste os nomes dos clientes que tiveram ao menos um pedido em 1997, com a data do primeiro pedido nesse ano.

SELECT
	Customers.CompanyName,
	MIN(Orders.OrderID) OrderID,
	MIN(CAST(Orders.OrderDate AS date)) PrimeiroPedido
FROM Orders
	INNER JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID
WHERE YEAR(Orders.OrderDate) >= 1997
GROUP BY 
	Customers.CompanyName
ORDER BY PrimeiroPedido

--  Funcionários ativos em 1998
-- Liste os funcionários que realizaram pelo menos um pedido em 1998, com a quantidade de pedidos feitos nesse ano.

SELECT 
	CONCAT(Employees.FirstName, ' ', Employees.LastName) Funcionario,
	COUNT(Orders.EmployeeID) AS Quantidade
FROM Orders
	INNER JOIN Employees
	ON Orders.EmployeeID = Employees.EmployeeID
WHERE YEAR(Orders.OrderDate) = 1998
GROUP BY CONCAT(Employees.FirstName, ' ', Employees.LastName)


-- Liste o nome do país e a quantidade total de pedidos feitos por clientes de cada país,
-- considerando apenas países com mais de 10 pedidos.

SELECT
	Customers.Country,
	COUNT(Orders.OrderID) AS TotalPedidos
FROM 
	Customers
	INNER JOIN Orders
		ON Customers.CustomerID = Orders.CustomerID
GROUP BY 
	Customers.Country
HAVING 
	COUNT(Orders.OrderID) > 10

-- Exiba o CustomerID e a quantidade de produtos diferentes que cada cliente já pediu,
-- considerando apenas os clientes que pediram mais de 3 produtos distintos.

SELECT
	Orders.CustomerID,
	COUNT(DISTINCT [Order Details].ProductID) TotalDiferentes
FROM
	Orders
	INNER JOIN [Order Details]
		ON Orders.OrderID = [Order Details].OrderID
GROUP BY 
	Orders.CustomerID
HAVING COUNT(DISTINCT [Order Details].ProductID) > 3
ORDER BY
	TotalDiferentes
	

-- Liste o nome do produto e o nome do fornecedor para todos os produtos
-- fornecidos por empresas dos EUA.

--Inverti a ordem e agrupei produtos

SELECT
	Suppliers.CompanyName Fornecedor,
	STRING_AGG(Products.ProductName,', ') Produto
FROM Products
	INNER JOIN Suppliers
		ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.Country = 'USA'
GROUP BY
	Suppliers.CompanyName

-- Exiba o ID do pedido e o nome do produto para todos os pedidos feitos
-- em outubro de 1996.

SELECT
	[Order Details].OrderID,
	STRING_AGG([Order Details].ProductID,', ') AS Produtos
FROM 
	[Order Details]
	INNER JOIN Orders
		ON [Order Details].OrderID = Orders.OrderID
WHERE YEAR(Orders.OrderDate) = 1996
	AND MONTH(Orders.OrderDate) = 10
GROUP BY
	[Order Details].OrderID


-- Liste o nome do produto, o nome do fornecedor e o preço unitário dos produtos
-- fornecidos por empresas localizadas no Reino Unido.

SELECT
	Products.ProductName,
	Suppliers.CompanyName,
	Products.UnitPrice
FROM 
	Products
	INNER JOIN Suppliers
		ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.Country = 'UK'


-- Exiba o nome do produto e o nome da categoria para produtos cujo preço seja maior
-- do que a média de preços da categoria a que pertencem.

SELECT
	Products.ProductName,
	Categories.CategoryName
FROM 
	Products
	INNER JOIN Categories
		ON Products.CategoryID = Categories.CategoryID
WHERE
	Products.UnitPrice > (
			SELECT
				AVG(Products.UnitPrice)
			FROM 
				Products
			WHERE Products.CategoryID = Categories.CategoryID)


-- Ver a média de preço por categoria para entender melhor
SELECT
    CategoryID,
    AVG(UnitPrice) AS MediaPreco
FROM
    Products
GROUP BY
    CategoryID;


-- Ver os produtos com seu preço e a média da categoria ao lado
SELECT
    Products.ProductName,
    Products.UnitPrice,
    Products.CategoryID,
    (
        SELECT AVG(UnitPrice)
        FROM Products
        WHERE CategoryID = Products.CategoryID
    ) AS MediaDaCategoria
FROM Products;

-- Liste o nome do produto e o nome do fornecedor para todos os produtos
-- fornecidos por empresas dos EUA.

--Inverti a ordem e agrupei produtos

SELECT
	Suppliers.CompanyName Fornecedor,
	STRING_AGG(Products.ProductName,', ') Produto
FROM Products
	INNER JOIN Suppliers
		ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.Country = 'USA'
GROUP BY
	Suppliers.CompanyName

-- Liste o CustomerID e o país de envio (ShipCountry) de todos os pedidos
-- cujo ShipCountry seja diferente do Country do cliente.

SELECT
	Orders.CustomerID,
	Orders.ShipCountry
FROM 
	Orders
	INNER JOIN Customers
		ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.ShipCountry = Customers.Country


-- Exiba o nome da categoria e a média de UnitPrice dos produtos de cada categoria,
-- mostrando apenas as categorias cuja média de preço seja maior do que a média geral de todos os produtos.

SELECT
	Categories.CategoryName,
	AVG(Products.UnitPrice) MediaCategoria
FROM
	Products
	INNER JOIN Categories
		ON Products.CategoryID = Categories.CategoryID
GROUP BY Categories.CategoryName
HAVING AVG(Products.UnitPrice) > (
	SELECT 
		AVG(UnitPrice)
	FROM 
		Products)

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


