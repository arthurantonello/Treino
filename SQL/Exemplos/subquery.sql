-- Banco de dados Adventure Works 2017

-- Monte um relatório de todos os produtos cadastrados que tem um preço de venda acima da média
SELECT *
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product)

-- Retorne todos os endereços que estão no estado de 'Alberta'
SELECT *
FROM Person.Address
WHERE StateProvinceID = (
	SELECT StateProvinceID
	FROM Person.StateProvince
	WHERE Name = 'Alberta')

-- Daria para fazer esse mesmo utilizando INNER JOIN
SELECT PA.*
FROM Person.Address AS PA
INNER JOIN Person.StateProvince AS SP
ON PA.StateProvinceID = SP.StateProvinceID
AND SP.Name = 'Alberta'

-- Retorne o nome dos funcionários que tem o cargo de 'Design Engineer'
SELECT FirstName
FROM Person.Person
WHERE BusinessEntityID in (
	SELECT BusinessEntityID 
	FROM HumanResources.Employee 
	WHERE JobTitle = 'Design Engineer');

-- Daria para fazer esse mesmo utilizando INNER JOIN
SELECT p.FirstName
FROM Person.Person AS P
INNER JOIN HumanResources.Employee AS E
ON p.BusinessEntityID = e.BusinessEntityID
AND e.JobTitle = 'Design Engineer'

-- Relatório de todos produtos cadastrados que possui o preço acima da média
SELECT *
FROM Production.Product
WHERE ListPrice > (
	SELECT AVG(ListPrice)
	FROM Production.Product)
	ORDER BY ListPrice

-- Banco de dados Northwind

-- Produtos acima da média de preço
-- Liste o ProductName e UnitPrice dos produtos cujo preço está acima da média de todos os produtos.
SELECT 
	Products.ProductName,
	Products.UnitPrice
FROM Products
WHERE UnitPrice > (
	SELECT 
		AVG(Products.UnitPrice)
	FROM Products)



-- Clientes que nunca fizeram pedidos
-- Encontre os CustomerID e CompanyName dos clientes que nunca realizaram um pedido.
SELECT 
	Customers.CustomerID,
	Customers.CompanyName
FROM Customers
WHERE Customers.CustomerID NOT IN (
	SELECT DISTINCT
		Orders.CustomerID
	FROM Orders)


-- Produtos que nunca foram vendidos
-- Liste os ProductID e ProductName dos produtos que nunca foram incluídos em um pedido (não aparecem em OrderDetails).
SELECT 
	Products.ProductID,
	Products.ProductName
FROM Products
WHERE Products.ProductID NOT IN (
	SELECT DISTINCT
		[Order Details].ProductID
	FROM [Order Details])


-- Fornecedores com os produtos mais caros
-- Encontre os CompanyName dos fornecedores (Suppliers) que vendem ao menos um produto com o maior preço unitário do banco de dados.

SELECT DISTINCT 
	Suppliers.CompanyName
FROM Suppliers
	JOIN Products 
	ON Suppliers.SupplierID = Products.SupplierID
WHERE Products.UnitPrice = (
    SELECT 
		MAX(Products.UnitPrice) 
	FROM Products
);


-- Funcionários que lidaram com pedidos para o cliente "ALFKI"
-- Liste o EmployeeID, FirstName e LastName dos funcionários que já processaram pedidos feitos pelo cliente de ID "ALFKI".

SELECT
	Employees.EmployeeID,
	CONCAT(Employees.FirstName, ' ', Employees.LastName) Employee
FROM Employees
WHERE Employees.EmployeeID IN (
	SELECT Orders.EmployeeID
	FROM Orders
	WHERE Orders.CustomerID = 'ALFKI')


-- Produtos com o mesmo preço que o produto "Tofu"
-- Liste o ProductName e UnitPrice dos produtos que têm exatamente o mesmo preço que o produto "Sasquatch Ale".


SELECT 
	Products.ProductName,
	Products.UnitPrice
FROM Products
WHERE Products.UnitPrice = (
	SELECT 
		UnitPrice
	FROM Products
	WHERE Products.ProductName = 'Sasquatch Ale')

--8. Clientes com pedidos acima da média geral de valores
--Liste os CustomerID e CompanyName dos clientes que fizeram pelo menos um pedido com valor total (soma de UnitPrice * Quantity) acima da média de todos os pedidos.

--9. Produtos cujo fornecedor vende apenas esse produto
--Encontre os ProductName e SupplierID dos produtos cujo fornecedor vende apenas esse único produto.

--10. Categorias cujos produtos nunca foram vendidos
--Liste os CategoryID e CategoryName das categorias cujos produtos nunca apareceram em um pedido.