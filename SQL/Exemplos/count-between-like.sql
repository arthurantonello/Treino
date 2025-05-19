-- Aula 11
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