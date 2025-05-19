--Aula 19
-- Faça uma query que mostre Nome, Cor e Preço dos produtos que sejam da cor Preta ou tenham seu preço entre 0 e 50 dólares

SELECT Name, Color, ListPrice
FROM Production.Product
WHERE Color = 'Black'
UNION
SELECT Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice > 0 AND ListPrice < 50
ORDER BY ListPrice ASC;