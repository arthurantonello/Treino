-- Aula 23
-- Monte um relatório de todos os produtos cadastrados que tem um preço de venda acima da média
SELECT *
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product)

-- Retorne todos os endereços que estão no estado de 'Alberta'
SELECT *
FROM Person.Address
WHERE StateProvinceID IN (
	SELECT StateProvinceID
	FROM Person.StateProvince
	WHERE Name = 'Alberta')

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