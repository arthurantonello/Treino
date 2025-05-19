-- Descobrir quais pessoas tem um cartão de crédito registrado, tabelas person.person e sales.PersonCreditCard
SELECT *
FROM Person.Person AS PP
LEFT JOIN Sales.PersonCreditCard AS PCC
ON pp.BusinessEntityID = pcc.BusinessEntityID
WHERE pcc.CreditCardID IS NULL;

-- Identifique clientes que não fizeram nenhum pedido após 1º de janeiro de 1997
SELECT C.*, O.OrderDate
FROM Customers AS C 
	LEFT JOIN Orders AS O
	ON C.CustomerID = O.CustomerID
	AND O.OrderDate > '1997-01-01' 
WHERE O.OrderID is NULL

-- Objetivo: Soma de Freight agrupado por país do cliente
SELECT C.Country, 
		SUM(O.Freight) AS 'Soma'
FROM Customers AS C
LEFT JOIN Orders AS O --Incluindo país sem pedido com left
ON  C.CustomerID = O.CustomerID
GROUP BY C.Country
ORDER BY Soma DESC

-- Objetivo: Liste ProductName dos produtos sem vendas
SELECT P.ProductID, P.ProductName
FROM Products AS P
	LEFT JOIN [Order Details] AS OD 
	ON P.ProductID = OD.ProductID
WHERE OD.ProductID IS NULL;

-- Para funcionar nessa tabela, inserir um produto sem venda
INSERT INTO Products (ProductName, Discontinued) 
VALUES ('Produto Teste Sem Vendas', 0);
