-- Banco de dados Northwind
-- Pedidos antigos: 
--		Liste os 10 pedidos mais antigos registrados
--    • Mostre SalesOrderID, CustomerID, OrderDate, TotalDue
SELECT TOP 10 SalesOrderID, CustomerID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY OrderDate DESC;

-- Banco de dados ContosoRetailDW

-- Você é Analista de Customer Experience (Experiência do Cliente) e precisa criar um relatório com os 100 primeiros clientes da história da empresa. Esses clientes receberão uma placa em reconhecimento à confiança dada.Z
-- Você precisa levantar essa lista de clientes dentro do banco de dados, em 10 minutos, pois o seu gestor solicitou essa informação para apresentar em uma reunião.

SELECT TOP (100)*
FROM DimCustomer
WHERE CustomerType = 'Person'
ORDER BY DateFirstPurchase