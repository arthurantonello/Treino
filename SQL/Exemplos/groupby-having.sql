-- Banco de dados Adventure Works 2017
-- Preciso saber quantas pessoas tem o mesmo nome do meio, agrupadas pelo nome do meio
SELECT MiddleName, COUNT(MiddleName) as 'Contagem de aparição'
FROM Person.Person
GROUP BY MiddleName;

-- Preciso saber em média qual a quantidade que cada produto é vendido na loja.
SELECT ProductID, AVG(OrderQty) as 'Média quantidade'
FROM Sales.SalesOrderDetail
GROUP BY ProductID;

-- Eu quero saber quais foram as 10 vendas que no total tiveram os maiores valores de venda por produto do maior para o menor valor
SELECT TOP 10 ProductID, SUM(LineTotal) AS 'Soma'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY Soma DESC;

-- Quantos produtos e qual a quantidade média de produtos temos cadastrados nas nossas ordem de serviço, agrupadas por ProductID
SELECT ProductID, COUNT(ProductID) AS 'Contagem',
AVG(OrderQty) AS 'Média'
FROM Production.WorkOrder
GROUP BY ProductID;

-- Liste os CustomerID da tabela Sales.SalesOrderHeader que realizaram mais de 10 pedidos, exibindo também a contagem total de pedidos.
SELECT CustomerID, COUNT(CustomerID) as TotalPedido
FROM sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(CustomerID) > 5
ORDER BY COUNT(CustomerID) DESC;

-- Estamos querendo identificar as provincias com o maior numero de cadastros no nosso sistema, então é preciso encontrar quais províncias estão registraads no banco de dados mais que 1000 vezes.
SELECT StateProvinceID, COUNT(StateProvinceID) AS 'Contagem'
FROM Person.Address
GROUP BY StateProvinceID
HAVING COUNT(StateProvinceID) > 1000;

-- Sendo que se trata de uma multinacional, os gerentes querem saber quais produtos não estão trazendo no mínimo 1 milhão no total de vendas em média
SELECT ProductID, AVG(LineTotal) AS 'Total de vendas'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(LineTotal) < 1000000;


-- Banco de dados Northwind
-- Objetivo: Calcule a média de UnitPrice por SupplierID
SELECT SupplierID, AVG(UnitPrice) AS Média
FROM Products
GROUP BY SupplierID

-- Produtos cujo fornecedor vende apenas esse produto
-- Encontre os ProductName e SupplierID dos produtos cujo fornecedor vende apenas esse único produto.

SELECT 
	ProductName,
	SupplierID
FROM Products
WHERE SupplierID IN (
    SELECT 
		SupplierID
    FROM Products
    GROUP BY SupplierID
    HAVING COUNT(*) = 1
);

-- Valor Médio de Pedido por Cliente
--   • Para cada CustomerID, mostre o total médio de TotalDue em pedidos
--   • Use subconsulta (ou CTE) para calcular o AVG(TotalDue)
--   • Exiba apenas clientes cujo AVG(TotalDue) > 500

SELECT CustomerID, 
		AVG(TotalDue) AS Media
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING AVG(TotalDue) > (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader)
ORDER BY Media DESC;

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


-- Quantos pedidos cada funcionário realizou?
-- Liste o EmployeeID e a quantidade total de pedidos processados.
SELECT 
	Orders.EmployeeID,
	COUNT(*) AS TotalPedidos
FROM Orders
GROUP BY Orders.EmployeeID

-- Quantos clientes únicos cada funcionário atendeu?
-- Liste o EmployeeID e o número de clientes distintos que ele atendeu.

SELECT
	Orders.EmployeeID,
	COUNT(DISTINCT Orders.CustomerID) AS ClientesUnicos
FROM Orders
GROUP BY Orders.EmployeeID
ORDER BY Orders.EmployeeID


-- Média de valor por pedido de cada cliente
-- Para cada CustomerID, mostre a média de valor dos pedidos realizados (considere o valor como SUM(UnitPrice * Quantity) por pedido).

SELECT
	PedidoPorCliente.CustomerID,
	AVG(PedidoPorCliente.TotalPedido) AS MediaPedidos
FROM (
	SELECT
		Orders.CustomerID,
		[Order Details].OrderID,
		SUM([Order Details].UnitPrice * [Order Details].Quantity) AS TotalPedido
	FROM [Order Details]
		INNER JOIN Orders
		ON [Order Details].OrderID = Orders.OrderID
	GROUP BY 
		Orders.CustomerID,
		[Order Details].OrderID) AS PedidoPorCliente
GROUP BY PedidoPorCliente.CustomerID


-- Clientes que já compraram mais de 1000 unidades no total
-- Liste o CustomerID e a soma total de todas as quantidades (Quantity) compradas, mas apenas de quem passou de 1000 unidades.
-- Agrupar por CustomerID
-- Somar o total de quantidades
-- usar having sum > 1000

SELECT
	Orders.CustomerID,
	SUM([Order Details].Quantity) AS QuantidadeTotal
FROM Orders
	INNER JOIN [Order Details]
	ON Orders.OrderID = [Order Details].OrderID
GROUP BY Orders.CustomerID
HAVING SUM([Order Details].Quantity) > 1000


-- Produtos com o menor e maior preço por categoria
-- Liste o CategoryID, MIN(UnitPrice) e MAX(UnitPrice) dos produtos em cada categoria.

SELECT
	Categories.CategoryID,
	MIN(Products.UnitPrice) AS ValorMinimo,
	MAX(Products.UnitPrice) AS ValorMaximo
FROM Categories
	INNER JOIN Products
	ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryID

-- Fornecedores que vendem mais de 5 produtos
-- Liste o SupplierID e a quantidade de produtos que fornece, apenas se for mais de 3.

SELECT
	Products.SupplierID,
	COUNT(*) AS QuantidadeProdutos
FROM Products
GROUP BY Products.SupplierID
HAVING COUNT(*) > 3


-- Clientes que nunca compraram dois produtos iguais
-- Encontre os clientes (CustomerID) que nunca repetiram o mesmo produto em dois pedidos diferentes.

-- Achar quais produtos aparecem apenas uma vez para cada cliente
-- Vincular cliente e produto - orders e orders details

SELECT 
	Orders.CustomerID
FROM Orders
	INNER JOIN [Order Details]
	ON Orders.OrderID = [Order Details].OrderID
GROUP BY 
	Orders.CustomerID, 
	[Order Details].ProductID
HAVING COUNT(DISTINCT Orders.OrderID) = 1

-- Pedidos cujo valor total é maior que a média geral de todos os pedidos
-- Liste os OrderID e seu valor total, se for maior que a média geral dos pedidos.

SELECT
	[Order Details].OrderID,
	SUM([Order Details].UnitPrice * [Order Details].Quantity) AS Total
FROM [Order Details]
GROUP BY [Order Details].OrderID
HAVING 
	SUM([Order Details].UnitPrice * [Order Details].Quantity) > (
	SELECT
		AVG(Total)
	FROM(
	SELECT 
		AVG([Order Details].UnitPrice * [Order Details].Quantity) AS Total
	FROM [Order Details]) AS MediaPedidos)
ORDER BY Total

-- Quantidade de produtos diferentes por pedido
-- Para cada OrderID, mostre quantos produtos diferentes foram incluídos.
SELECT
	[Order Details].OrderID,
	COUNT(DISTINCT [Order Details].ProductID) AS QtdItensDiferentes
FROM [Order Details]
GROUP BY [Order Details].OrderID
ORDER BY [Order Details].OrderID

-- Funcionários com maior número de pedidos processados
-- Liste o(s) EmployeeID e a contagem de pedidos dos funcionários que mais processaram pedidos.

SELECT
	Orders.EmployeeID,
	COUNT(Orders.OrderID) QtdPedidos
FROM Orders
GROUP BY Orders.EmployeeID
ORDER BY QtdPedidos DESC

-- Total de pedidos por país de entrega
-- Mostre os países de entrega (ShipCountry) e a quantidade total de pedidos entregues em cada um. Mostre apenas países que aparecem em pedidos.

SELECT
	Orders.ShipCountry,
	COUNT(*) QtdPedidos
FROM Orders
GROUP BY Orders.ShipCountry

-- Apresente o nome do país e o total de frete somado em pedidos enviados para ele,
-- considerando apenas países com frete total superior a 500.

SELECT
	Orders.ShipCountry,
	SUM(Orders.Freight) AS TotalFrete
FROM 
	Orders
GROUP BY 
	Orders.ShipCountry
HAVING 
	SUM(Orders.Freight) > 500
ORDER BY 
	TotalFrete

-- Mostre o ID do funcionário e o total de pedidos realizados por ele,
-- considerando apenas os que atenderam mais de 30 pedidos.

SELECT
	Orders.EmployeeID,
	COUNT(Orders.EmployeeID) TotalPedidos
FROM 
	Orders
GROUP BY 
	Orders.EmployeeID
HAVING COUNT(Orders.EmployeeID) > 30


-- Liste o CustomerID e o total de frete pago (Freight) por cliente,
-- considerando apenas clientes cujo frete total exceda 200.

SELECT 
	Orders.CustomerID,
	SUM(Orders.Freight) TotalFrete
FROM 
	Orders
GROUP BY
	Orders.CustomerID
HAVING 
	SUM(Orders.Freight) > 200

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