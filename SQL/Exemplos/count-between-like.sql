-- Banco de dados Adventure Works 2017

-- Quantos produtos temos cadastrados no sistema que custam mais que 1500 dolares?
SELECT COUNT(ListPrice)
FROM Production.Product
WHERE ListPrice > 1500;

-- Quantas pessoas temos com o sobrenome que inicia com a letra P?
SELECT COUNT(LastName)
FROM Person.Person
WHERE LastName LIKE 'P%';

-- Em quantas cidades únicas estão cadastrados nossos clientes?
SELECT COUNT(DISTINCT City)
FROM person.Address;

-- Quais são as cidades únicas que temos cadastradas no nosso sistema?
SELECT DISTINCT City
FROM person.Address;

-- Quantos produtos vermelhos têm preço entre 500 a 1000 dolares?
SELECT COUNT(*)
FROM Production.Product
WHERE Color = 'Red' 
AND ListPrice BETWEEN 500 AND 1000;

-- Quantos produtos cadastrados tem a palavra 'road' no nome deles?
SELECT COUNT(*)
FROM Production.Product
WHERE Name LIKE '%road%';

-- Banco de dados Northwind

-- Produtos com preço entre 10 e 50
-- Objetivo: Exiba ProductName e UnitPrice dos produtos nessa faixa de preço
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 10 AND 50
ORDER BY UnitPrice


-- Pedidos do primeiro semestre de 1997
-- Objetivo: Liste OrderID e OrderDate dos pedidos de jan-jun/1997
SELECT OrderID, OrderDate
FROM Orders
WHERE OrderDate BETWEEN '1997/01/01' AND '1997/06/30'
ORDER BY OrderDate

-- Banco de dados ContosoRetailDW

-- Você é Analista de Produtos e precisa levantar algumas informações sobre os produtos, como:
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

-- Você agora é um Analista de RH da empresa e precisa saber a quantidade total de funcionários de cada departamento pois o Financeiro depende desse entendimento para dimensionar gastos para cada um dos departamentos, como bonificações, computadores, equipamentos de forma geral. Utilize seus conhecimentos para dar suporte à área financeira.

SELECT DepartmentName, COUNT(DepartmentName) Quantidade
FROM DimEmployee
GROUP BY DepartmentName