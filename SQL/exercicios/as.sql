-- Aula 15
-- Encontrar o FirstName e LastName da lista de pessoas e mostrar elas em português
SELECT FirstName AS 'Primeiro nome', LastName AS 'Sobrenome'
FROM Person.Person;

-- Transformar o ProductNumber da tabela produtos em 'Número do Produto'
SELECT ProductNumber AS 'Número do Produto'
FROM Production.Product;

-- Encontrar a coluna unitPrice do sales order e mostrar como 'Preço Unitário'
SELECT UnitPrice AS 'Preço Unitário'
FROM Sales.SalesOrderDetail;