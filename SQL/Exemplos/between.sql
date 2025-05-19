-- Desafio B2: Produtos com preço entre 10 e 50
-- Objetivo: Exiba ProductName e UnitPrice dos produtos nessa faixa de preço
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 10 AND 50
ORDER BY UnitPrice


-- Desafio B3: Pedidos do primeiro semestre de 1997
-- Objetivo: Liste OrderID e OrderDate dos pedidos de jan-jun/1997
SELECT OrderID, OrderDate
FROM Orders
WHERE OrderDate BETWEEN '1997/01/01' AND '1997/06/30'
ORDER BY OrderDate