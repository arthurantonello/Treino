--Aula 20
-- Selecionar todos os clientes que estão na mesma regiao

SELECT a.ContactName,a.Region, b.ContactName, b.Region
FROM Customers AS a, Customers AS b
WHERE a.Region = b.Region

-- Encontrar nome e data de contratação de todos os funcionários que foram contratados no mesmo ano
SELECT a.FirstName, a.HireDate,b.FirstName, b.HireDate
FROM dbo.Employees AS A, dbo.Employees AS B
WHERE DATEPART(YEAR, a.HireDate) = DATEPART(YEAR, b.HireDate)

-- Quais produtos tem o mesmo percentual de desconto na tabela detalhe do pedido
SELECT a.ProductID, a.Discount, b.ProductID, b.Discount
FROM [Order Details] AS A, [Order Details] AS B
WHERE b.Discount = b.Discount