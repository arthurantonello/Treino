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
