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

-- ou ainda

WHERE LastName LIKE '%nello'

-- ou ainda

WHERE LastName LIKE '%onel%'

-- Para ter apenas uma letra antes/após, usa o _ (underline) logo após a variável

-- WHERE LastName LIKE '%onell_' -- Retornaria por exemplo Antonello, Antonella, Antonelli, se houvesse na tabela.

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

# Funções de agregação:
## MIN: Retorna o valor mínimo:
SELECT MIN(valor)
FROM tabela

SELECT TOP 10 MIN(LineTotal) AS 'Menor Valor'
FROM Sales.SalesOrderDetail

## MAX: Retorna o valor máximo:
SELECT MAX(valor)
FROM tabela

SELECT TOP 10 MAX(LineTotal) AS 'Maior Valor'
FROM Sales.SalesOrderDetail

## AVG: Retorna a média:
SELECT AVG(valor)
FROM tabela

SELECT TOP 10 AVG(LineTotal) AS 'Média'
FROM Sales.SalesOrderDetail


--

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

# JOINS:
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

--

## SUBQUERY (SUBSELECT): Serve para fazer um SELECT dentro de outro SELECT, para por exemplo, fazer uma pesquisa baseada em uma resposta:
SELECT *
FROM tabela
WHERE coluna = (
    SELECT coluna
    FROM tabela
    WHERE condicao
)

SELECT *
FROM Production.Product
WHERE ListPrice > (
	SELECT AVG(ListPrice)
	FROM Production.Product)
	ORDER BY ListPrice

--

## DATEPART: Serve para filtrar uma data baseado em uma das informações dela, year - mouth - day por ex:
### (https://learn.microsoft.com/pt-br/sql/t-sql/functions/datepart-transact-sql?view=sql-server-ver16)
SELECT coluna
FROM tabela
WHERE DATEPART(periodo, coluna) = condicao

-- ou

SELECT DATEPART(periodo, coluna)
FROM tabela
WHERE condicao
GROUP BY DATEPART(periodo, coluna)


SELECT *
FROM DatabaseLog
WHERE DATEPART(YEAR, PostTime) = 2017

SELECT DATEPART(YEAR, PostTime) AS Year, COUNT(*) AS Count
FROM DatabaseLog
GROUP BY DATEPART(YEAR, PostTime)
ORDER BY Year

## CAST: Converte um tipo de dado em outro
SELECT CAST(dado AS novo_tipo)
FROM tabela

SELECT CAST (DataComHorario AS DATE) --retornará em formato date, sem horário
FROM horario

SELECT CAST (Altura AS FLOAT)
From tabela

--

# Manipulação de strings: Modifica Strings baseado no infoirmado, concat, substring, etc.
### (https://learn.microsoft.com/en-us/sql/t-sql/functions/string-functions-transact-sql?view=sql-server-ver16)
## CONCAT: Serve para concatenar, seja Strings ou colunas:
SELECT CONCAT(info1, info2)
FROM tabela

SELECT FirstName, LastName, CONCAT(LastName, ' ', LastName) AS 'Nome completo'
FROM Person.Person

-- também funciona com '+'

SELECT FirstName, LastName, LastName + ' ' + LastName AS 'Nome completo'
FROM Person.Person

## UPPER: Transforma a informação toda para maíscula:
SELECT UPPER(info)
FROM tabela

SELECT UPPER(FirstName)
FROM Person.Person

## LOWER: Transforma a informação toda para minúscula:
SELECT LOWER(info)
FROM tabela

SELECT LOWER(FirstName)
FROM Person.Person

## SUBSTRING: Retorna partes de uma String:
SELECT SUBSTRING(coluna, indice_inicial, indice_final) -- No SQL o índice inicia no 1
FROM tabela

SELECT FirstName, SUBSTRING(FirstName, 1, 3) -- De 'Arthur' retornaria 'Art'
FROM Person.Person

## REPLACE: Modifica parte de uma coluna:
SELECT coluna, REPLACE(coluna, info_a_substituir, nova_info)
FROM tabela

SELECT ProductNumber, REPLACE(ProductNumber, '-', '.') -- Trocou os hífens para ponto
FROM Production.Product

## LEN: Retorna a quantidade de caractere da linha:
SELECT LEN(coluna)
FROM tabela

SELECT rowguid, LEN(rowguid) -- Verificando se todos códigos tem o mesmo tamanho, por exemplo
FROM Production.Product

# Funções matemáticas: Consultar documentação para as outras
### (https://learn.microsoft.com/pt-br/sql/t-sql/functions/mathematical-functions-transact-sql?view=sql-server-ver16)
## ROUND: Serve para arredondar um retorno, como se fosse um toFixed:
SELECT ROUND(coluna, casas_depois_da_virgula)
FROM tabela

## SQUARE: Retorna a informação ao quadrado:
SELECT SQUARE(info)
FROM tabela

SELECT UnitPrice, SQUARE(UnitPrice)
FROM Sales.SalesOrderDetail

# Tipos de dados:
## Booleano(BIT): Inicia como NULL, pode ser 0, 1, ou NULL.

## Caracteres:
## Caractere(CHAR): Tamanho fixo informado na inicialização, sempre ocupa todo espaço na memória.

## Caractere variável(VARCHAR/ NVARCHAR): Possui tamanho variável, define tamanho máximo fixo, mas ocupa na memória apenas o que for utilizado.
--
## Números:
## Valores exatos:

### INT: Tipo primitivo para números inteiros, havendo variação de tamanho limite e ocupação na memória, na ordem:
### TINYINT:                             0 a 255                                - 1 byte
### SMALLINT:                       -32.768 a 32.767                            - 2 bytes
### INT:                    -2.147.483.648 a 2.147.483.647                      - 4 bytes
### BIGINT:     -9.223.372.036.854.775.808 a 9.223.372.036.854.775.807          - 8 bytes

### NUMERIC / DECIMAL: Para valores exato, porém permite valor fracionado especificando escala e precisão
NUMERIC(tamanho_desejado,quantidade_depois_da_virgula)

NUMERIC(5, 2) -- Aceitaria por exemplo: 111,23. Totaliza 5, sendo 2 após a vírgula

## Valores aproximados:

### REAL: Tem a precisão aproximada de até 15 dígitos

### FLOAT: Mesma ideia do real

## Temporais:

### DATE: Armazena data no formato YYYY/MM/DD(AAAA/MM/DD)

### DATETIME: Armazena data e hora no formato YYYY/MM/DD:HH:MM:SS

### TIME: Armazena horas no formato HH:MM:SS.SSSSSSS respeitando o limite de '00:00:00.0000000 a 23:59:59.9999999'

### DATETIMEOFFSET - Permite armazenar data e hora, mas com o fuso horário
--

## Chaves (key)
## PRIMARY KEY: Coluna que não se repete, única para representar esta tabela(id por exemplo)
CREATE TABLE nome_tabela(
    nome_coluna1 tipo_de_dados PRIMARY KEY,
    nome_coluna2 tipo_de_dados,
    ...
)

CREATE TABLE Produtos(
    FornecedorID INT PRIMARY KEY IDENTITY(1,1), -- Identity serve para ser um dado autoincrementável no SQL SERVER
    Nome VARCHAR(100) NOT NULL, -- NOT NULL serve para essa coluna não aceitar ser vazia
    ...
)

## FOREING KEY: Chave estrangeira, serve para referenciar a tabela PAI em uma tabela FILHO
## pode se ter mais de uma FK em uma tabela
-- Tabela principal (contém a chave primária que será referenciada)
CREATE TABLE tabela_principal (
    id_tabela_principal INT PRIMARY KEY IDENTITY(1,1),  -- PK (chave primária)
    ...
);

-- Tabela secundária (contém a chave estrangeira)
CREATE TABLE tabela_secundaria (
    id_tabela_secundaria INT PRIMARY KEY IDENTITY(1,1), -- PK
    ...
    
    -- Chave estrangeira (referencia a PK da tabela_principal)
    id_tabela_principal INT NOT NULL,                   -- FK (não pode ser nula)
    
    -- Definindo a relação FK → PK
    CONSTRAINT fk_tabela_secundaria_principal 
        FOREIGN KEY (id_tabela_principal) 
        REFERENCES tabela_principal(id_tabela_principal)
);