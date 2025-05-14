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