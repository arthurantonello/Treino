-- Objetivo: Mostre EmployeeID e lista de TerritoryIDs associados
SELECT E.EmployeeID, E.FirstName + ' ' + E.LastName AS EmployeeName, 
	STRING_AGG(CAST(ET.TerritoryID AS VARCHAR), ',') AS Territories
FROM Employees AS E
	INNER JOIN EmployeeTerritories AS ET
	ON E.EmployeeID = ET.EmployeeID
GROUP BY 
    E.EmployeeID, E.FirstName, E.LastName