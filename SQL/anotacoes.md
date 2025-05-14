# O QUE É

# Comandos
## DQL (Data Query Language)
```
SELECT: recupera dados de uma ou mais tabelas do banco de dados. É o comando principal para consultas.
```

## DML (Data Manipulation Language)
```
INSERT: adiciona novos registros a uma tabela.
UPDATE: modifica registros existentes em uma tabela.
DELETE: remove registros de uma tabela.
```

## DDL (Data Definition Language)
```
CREATE: cria objetos de banco de dados, como tabelas, índices, visões e procedimentos armazenados.
ALTER: modifica a estrutura de objetos de banco de dados existentes, como adicionar ou remover colunas de tabelas.
DROP: exclui objetos de banco de dados, como tabelas, índices ou visões.
TRUNCATE: Remove todos os registros de uma tabela, mas mantém sua estrutura.
```

## DCL (Data Control Language)
```
GRANT: Concede permissões a usuários ou funções para acessar objetos de banco de dados.
REVOKE: Remove permissões previamente concedidas a usuários.
```

# Exemplos de uso:
## SELECT: Recupera dados em partes ou todo banco de dados, retorna sem alterar o original:
SELECT * -- asterisco seleciona todas colunas
FROM tabela

SELECT FirstName
FROM person.Person -- tabela person.Person

## FROM: Indica a onde srá procurado:
SELECT *
FROM tabela

SELECT *
FROM production.Products

## WHERE: Menciona a onde deve ser aplicado:
SELECT * 
FROM tabela
WHERE condição

SELECT *
FROM person.Person
WHERE FirstName = 'Arthur' AND LastName = 'Antonello'

## IN: Utilizado junto do WHERE, serve para retornar um valor entre os informados:
SELECT * 
FROM tabela
WHERE valor IN (valor1, valor2)

SELECT *
FROM Carros
WHERE color IN ('Blue', 'Red', 'Black')

equivalente a:
WHERE color = 'Blue' OR color = 'Red' OR color = 'Black'

## ORDER BY: Ordena a(s) coluna(s) em ascendente ou decrescente baseado em um ou mais critérios:
SELECT *
FROM tabela
ORDER BY coluna ASC(ou DESC)

SELECT *
FROM person.Person
ORDER BY FirstName ASC

SELECT *
FROM person.Person
ORDER BY FirstName ASC, Salary DESC

## LIKE: Encontra resultados semelhantes a variável informada (use o percentual para considerar como "não importa o que vêm antes/depois"):
SELECT * 
FROM tabela
WHERE condição LIKE 'variavel'

-- Para achar Antonello:
SELECT *
FROM person.Person
WHERE LastName LIKE 'Ant%'

ou ainda

WHERE LastName LIKE '%nello'

ou ainda

WHERE LastName LIKE '%onel%'

- Para ter apenas uma letra antes/após, usa o _ (underline) logo após a variável

WHERE LastName LIKE '%onell_' -- Retornaria por exemplo Antonello, Antonella, Antonelli, se houvesse na tabela.

## BETWEEN: Serve para encontrar valores entre um valor mínimo e um máximo (igual a >= e <=):
SELECT *
FROM tabela
WHERE valor BETWEEN minimo AND maximo

SELECT *
FROM person.Person
WHERE Age BETWEEN 1 AND 18

## DISTINCT: Condição que retorna apenas informações únicas:
SELECT DISTINCT coluna
FROM tabela

SELECT DISTINCT FirstName
FROM person.Person

SELECT COUNT(DISTINCT title)
FROM person.Person

## TOP: Retorna os primeiros X resultados:
SELECT TOP quantidade *
FROM tabela

SELECT TOP 10 *
FROM tabela

## MIN: Retorna o valor mínimo
SELECT MIN(valor)
FROM tabela

SELECT TOP 10 MIN(LineTotal) AS 'Menor Valor'
FROM Sales.SalesOrderDetail

## MAX: Retorna o valor máximo
SELECT MAX(valor)
FROM tabela

SELECT TOP 10 MAX(LineTotal) AS 'Maior Valor'
FROM Sales.SalesOrderDetail

## AVG: Retorna a média
SELECT AVG(valor)
FROM tabela

SELECT TOP 10 AVG(LineTotal) AS 'Média'
FROM Sales.SalesOrderDetail

## GROUP BY: Agrupa os dados baseando-se em uma coluna e em uma função agregada em outra coluna:
SELECT coluna1, funcaoAgregada(coluna2)
FROM tabela
GROUP BY coluna1

SELECT ProductID, COUNT(ProductID) AS 'Contagem de vendas'
FROM sales.SalesOrderDetail
GROUP BY ProductID

SELECT Color, AVG(ListPrice) as 'Média preço'
FROM Production.Product
WHERE Color LIKE '%Silver%'
GROUP BY Color

## HAVING: É tipo um WHERE, mas para dados agrupados, utilizado após GROUP BY:
SELECT coluna1, funcaoAgregada(coluna2)
FROM tabela
GROUP BY coluna1
HAVING condição

SELECT FirstName, COUNT(FirstName) AS 'Quantidade'
FROM Person.Person
GROUP BY FirstName
HAVING COUNT(FirstName) > 10

SELECT FirstName, COUNT(FirstName) AS 'Quantidade'
FROM Person.Person
WHERE Title = 'Mr.'
GROUP BY FirstName
HAVING COUNT(FirstName) > 10

## AS: Serve para apelidar algo, como uma coluna ou uma função agregada:
SELECT coluna AS apelido
FROM tabela

SELECT ListPrice as Lista -- pode ou não ser entre aspas quando é só uma palavra
FROM Production.Product

SELECT TOP 10 AVG(LineTotal) AS 'Preço médio'
FROM Sales.SalesOrderDetail

## INNER JOIN: Retorna os registros iguais entre duas tabelas(interseção):
SELECT *
FROM tabelaA
INNER JOIN tabela b
ON tabelaA.nome = tabelaB.nome -- Onde os nomes forem iguais

## FULL OUTER JOIN: Retorna todos os valores iguais das duas tabelas, quando uma tiver um valor que a outra não possui ele preenche como null na tabela que não possui:
SELECT *
FROM tabelaA
FULL OUTER JOIN tabelaB
ON tabelaA.nome = tabelaB.nome

## LEFT OUTER JOIN (OU LEFT JOIN): Semelhante ao FULL OUTER JOIN, mas considera os registros da tabela A e ignora os registros únicos da tabela B (Right), se não houver o valor correspondente, preenche como null:
SELECT *
FROM tabelaA
LEFT JOIN tabelaB
ON tabelaA.nome = tabelaB.nome

## RIGHT OUTER JOIN(OU RIGHT JOIN): O inverso do LEFT OUTER JOIN.

## UNION: Combina dois ou mais resultados de um SELECT em um único resultado e remove as duplicatas (união):
SELECT info1, info2, info3
FROM tabela
WHERE condicao
UNION
SELECT info1, info2, info3
FROM tabela
WHERE condicao

SELECT Name, Color, ListPrice
FROM Production.Product
WHERE Color = 'Black'
UNION
SELECT Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice > 0 AND ListPrice < 50

## UNION ALL: Faz o mesmo do UNION, mas mantém as duplicatas:

## SELF JOIN: Para comparar duas informações da mesma tabela (precisa utiliar o AS):

SELECT a.info1,a.info2, b.info1, b.info2
FROM tabelaA AS a, tabelaB AS b
WHERE a.info2 = b.info2

-- Selecionar todos os clientes que estão na mesma regiao
SELECT a.ContactName,a.Region, b.ContactName, b.Region
FROM Customers AS a, Customers AS b
WHERE a.Region = b.Region

## SUBQUERY (SUBSELECT)