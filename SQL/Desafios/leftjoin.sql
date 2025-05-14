-- Descobrir quais pessoas tem um cartão de crédito registrado, tabelas person.person e sales.PersonCreditCard
SELECT *
FROM Person.Person AS PP
LEFT JOIN Sales.PersonCreditCard AS PCC
ON pp.BusinessEntityID = pcc.BusinessEntityID
WHERE pcc.CreditCardID IS NULL;
