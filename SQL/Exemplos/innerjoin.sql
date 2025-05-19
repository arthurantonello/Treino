-- Aula 16
-- Juntar as informações BusinessEntityId, Name, PhoneNumberTypeID e PhoneNumber da tabela person.PhoneNumberType e person.PersonPhone
SELECT TOP 10 pp.BusinessEntityId, pnt.Name, pnt.PhoneNumberTypeID, pp.PhoneNumber
FROM Person.PhoneNumberType AS PNT
INNER JOIN Person.PersonPhone AS PP 
ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;

-- Juntar o AdressId, City, StateProvinceId e o Name das tabelas person.StateProvince e person.Adress
SELECT a.AddressID, a.City, st.StateProvinceID, st.Name
FROM Person.StateProvince AS ST
INNER JOIN Person.Address AS A
ON st.StateProvinceID = a.StateProvinceID;

-- Retorne todos os endereços que estão no estado de 'Alberta'
SELECT PA.*
FROM Person.Address AS PA
INNER JOIN Person.StateProvince AS SP
ON PA.StateProvinceID = SP.StateProvinceID
AND SP.Name = 'Alberta'

    -- Daria para fazer esse mesmo utilizando SUBQUERY
    SELECT *
    FROM Person.Address
    WHERE StateProvinceID = (
        SELECT StateProvinceID
        FROM Person.StateProvince
        WHERE Name = 'Alberta')

-- Retorne o nome dos funcionários que tem o cargo de 'Design Engineer'
SELECT p.FirstName
FROM Person.Person AS P
INNER JOIN HumanResources.Employee AS E
ON p.BusinessEntityID = e.BusinessEntityID
AND e.JobTitle = 'Design Engineer'

    -- Daria para fazer esse mesmo utilizando SUBQUERY
    SELECT FirstName
    FROM Person.Person
    WHERE BusinessEntityID in (
        SELECT BusinessEntityID 
        FROM HumanResources.Employee 
        WHERE JobTitle = 'Design Engineer');

-- Objetivo: Liste produtos com estoque < 20 da categoria "Beverages"
SELECT P.ProductName, P.UnitsInStock
FROM Products AS P
	INNER JOIN Categories as C
	ON C.CategoryName = 'Beverages'
WHERE P.UnitsInStock < 20

-- Calcule o total de vendas (em valor monetário) por funcionário em 1996, ordenado do maior para o menor
SELECT 
    E.EmployeeID,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalSales
FROM 
    Orders AS O
    INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
    INNER JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
WHERE 
    O.OrderDate BETWEEN '1996-01-01' AND '1996-12-31'
GROUP BY 
    E.EmployeeID, E.FirstName, E.LastName
ORDER BY 
    TotalSales DESC;

-- Objetivo: Conte quantos produtos existem em cada categoria
SELECT P.CategoryID, C.CategoryName, COUNT(P.CategoryID) AS Count
FROM Products AS P
	INNER JOIN Categories AS C
	ON P.CategoryID = C.CategoryID
GROUP BY P.CategoryID, C.CategoryName

-- Objetivo: Calcule a média de UnitPrice por SupplierID
SELECT S.SupplierID, S.CompanyName AS Fornecedor,
		ROUND(AVG(P.UnitPrice), 2) AS MediaPreco,
		COUNT(P.ProductID) AS QtdProdutos
FROM Products P
    INNER JOIN Suppliers AS S
	ON P.SupplierID = S.SupplierID
GROUP BY S.SupplierID, S.CompanyName
ORDER BY MediaPreco DESC

-- Objetivo: Pedidos que têm mais de 2 tipos de produtos
SELECT O.OrderID, COUNT(OD.ProductID) AS QtdProdutos,
		SUM(OD.UnitPrice * OD.Quantity) AS TotalPedido
FROM Orders AS O
	INNER JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
GROUP BY O.OrderID
HAVING (COUNT(OD.ProductID) >= 2)
ORDER BY QtdProdutos DESC

-- Objetivo: Mostre EmployeeID e lista de TerritoryIDs associados
SELECT E.EmployeeID, E.FirstName + ' ' + E.LastName AS EmployeeName, 
	STRING_AGG(CAST(ET.TerritoryID AS VARCHAR), ',') AS Territories
FROM Employees AS E
	INNER JOIN EmployeeTerritories AS ET
	ON E.EmployeeID = ET.EmployeeID
GROUP BY 
    E.EmployeeID, E.FirstName, E.LastName

    -- Objetivo: Soma de (UnitPrice*Quantity) agrupada por CategoryName
SELECT C.CategoryName, 
		SUM(OD.UnitPrice * Quantity) AS TotalVendas
FROM [Order Details] AS OD
	INNER JOIN Products AS P
	ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS C
	ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName
ORDER BY TotalVendas DESC