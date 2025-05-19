-- ========================
-- NÍVEL BÁSICO (DIFICULDADE MÉDIA)
-- ========================

-- 1. Total de Vendas por Ano
-- Calcule o total de valor de vendas (TotalDue) agrupado por ano do OrderDate da tabela Sales.SalesOrderHeader.
SELECT DATEPART(YEAR, OrderDate), SUM(TotalDue) AS TotalVendas
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(YEAR, OrderDate)
ORDER BY DATEPART(YEAR, OrderDate) ASC;


-- 2. Clientes com Mais de 10 Pedidos
-- Liste os CustomerID da tabela Sales.SalesOrderHeader que realizaram mais de 10 pedidos, exibindo também a contagem total de pedidos.
SELECT CustomerID, COUNT(CustomerID) as TotalPedido
FROM sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(CustomerID) > 5
ORDER BY COUNT(CustomerID) DESC;

-- 3. Produtos Mais Caros por Categoria
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
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    WHERE p.ListPrice > 0
) AS ProdutosComRanking
WHERE rn = 1
ORDER BY Categoria;

-- ==============================
-- EXERCÍCIOS SQL “ÚTEIS” E DIDÁTICOS
-- Banco: AdventureWorks 2017 (SSMS)
-- Foco: SELECT, filtros, JOINs, subqueries, agregações básicas, modelagem de dados
-- ==============================

-- 1. Listar Produtos por Categoria e Preço
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


-- 2. Clientes e Quantidade de Pedidos
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


-- 3. Pedidos antigos: 
--		Liste os 10 pedidos mais antigos registrados
--    • Mostre SalesOrderID, CustomerID, OrderDate, TotalDue
SELECT TOP 10 SalesOrderID, CustomerID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY OrderDate DESC;


-- 4. Valor Médio de Pedido por Cliente
--   • Para cada CustomerID, mostre o total médio de TotalDue em pedidos
--   • Use subconsulta (ou CTE) para calcular o AVG(TotalDue)
--   • Exiba apenas clientes cujo AVG(TotalDue) > 500

SELECT CustomerID, 
		AVG(TotalDue) AS Media
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING AVG(TotalDue) > (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader)
ORDER BY Media DESC;

-- 5. Inventário Atual vs. Ponto de Reposição
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

SELECT *
FROM Production.Product

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
	Orders.OrderID,
	Customers.CompanyName,
	Orders.ShipCountry
FROM Orders
	INNER JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID

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

INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country)
VALUES ('XXXX1', 'Cliente sem pedido', 'Fulano', 'Brazil');

INSERT INTO Products( ProductName)
VALUES ('Produto sem categoria')

INSERT INTO Employees(LastName, FirstName, Title, HireDate)
VALUES ('Silva', 'Roberto', 'Assistente', GETDATE())

INSERT INTO Categories(CategoryName)
VALUES ('Categoria nova')

SELECT *
FROM Employees

SELECT *
FROM Products

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



-- 6. Metadados: Chaves Estrangeiras de uma Tabela
--   • Liste todas as FKs da tabela Sales.SalesOrderDetail
--   • Use a visão INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS  
--     e INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE

SELECT INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
FROM Sales.SalesOrderDetail

-- 7. Criar VIEW Simples (prática de modelagem)
--   • Crie uma VIEW chamada vw_CustomerOrders com colunas:
--       CustomerID, FullName (First + ' ' + Last), SalesOrderID, OrderDate, TotalDue
--   • Use JOIN entre Sales.Customer → Person.Person → Sales.SalesOrderHeader

-- 8. UNION ALL: Vendas e Devoluções (exercício de união)
--   • Combine resultados de SalesOrderHeader (Status = 5 → cancelado)  
--     e status normal em um só SELECT, indicando “Tipo” = 'Ativo' ou 'Cancelado'
--   • Exiba SalesOrderID, OrderDate, TotalDue, Tipo

-- 9. CASE Simples: Faixas de Preço
--   • Liste ProductID, Name, ListPrice e uma coluna PriceRange:
--       CASE 
--         WHEN ListPrice < 100 THEN 'Baixo'
--         WHEN ListPrice BETWEEN 100 AND 1000 THEN 'Médio'
--         ELSE 'Alto'
--       END
--   • Ordene por ListPrice desc

-- 10. Subquery Correlacionada: Último Pedido de Cada Cliente
--    • Para cada CustomerID, recupere:
--        SalesOrderID e OrderDate do pedido mais recente  
--      Use subquery correlacionada em WHERE or SELECT

-- ====================================================================
-- Esses exercícios cobrem tarefas cotidianas de SQL — não são “absurdos”, mas
-- treinam SELECT simples, filtros, JOINs, subqueries, agregações, modelagem e uso
-- de metadados. Bom treino!
-- ====================================================================

-- ###################################################################### --
-- ========= SE PREPARANDO PARA UMA PROVA P/ ANALISTA DE DADOS SQL =========
-- ###################################################################### --


-- Exercício 1. Você é Analista de Customer Experience (Experiência do Cliente) e precisa criar um relatório com os 100 primeiros clientes da história da empresa. Esses clientes receberão uma placa em reconhecimento à confiança dada.

-- Você precisa levantar essa lista de clientes dentro do banco de dados, em 10 minutos, pois o seu gestor solicitou essa informação para apresentar em uma reunião.

SELECT TOP (100)*
FROM DimCustomer
WHERE CustomerType = 'Person'
ORDER BY DateFirstPurchase

-- Exercício 2. Você é Analista de Produtos e precisa levantar algumas informações sobre os produtos, como:
-- Quantidade de Produtos
-- Soma total de peso dos produtos
-- Preço Médio dos Produtos
-- Maior Preço
-- Menor Preço

-- Utilize seus conhecimentos em SQL para fazer essas análises dentro do Banco de Dados.
SELECT 
	COUNT(ProductKey) Quantidade,
	SUM(Weight) Soma,
	AVG(UnitPrice) Media,
	MIN(UnitPrice) Minimo,
	MAX(UnitPrice) Maximo
FROM DimProduct

SELECT ROUND(CAST(AVG(UnitPrice) AS FLOAT), 3) FROM DimProduct


-- 3. Você agora é um Analista de RH da empresa e precisa saber a quantidade total de funcionários de cada departamento pois o Financeiro depende desse entendimento para dimensionar gastos para cada um dos departamentos, como bonificações, computadores, equipamentos de forma geral. Utilize seus conhecimentos para dar suporte à área financeira.

SELECT DepartmentName, COUNT(DepartmentName) Quantidade
FROM DimEmployee
GROUP BY DepartmentName



