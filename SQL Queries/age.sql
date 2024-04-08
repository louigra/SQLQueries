SELECT DATEDIFF(yy, SmartHRA.dbo.Person.DateofBirth ,GETDATE()) + (CASE WHEN DATEPART(MONTH, GETDATE()) - DATEPART(MONTH, SmartHRA.dbo.Person.DateofBirth) <0 THEN -1 ELSE 0 END) AS age
FROM SmartHRA.dbo.Person;