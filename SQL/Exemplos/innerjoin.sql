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