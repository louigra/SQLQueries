SELECT  
	CONCAT(p.LastName, ', ', p.FirstName) AS Full_Name, 
	a.CompanyName AS Account,
	SUM(CASE
		WHEN (pv.VisitModeId = 1 AND (pv.HraStatusId NOT IN (169,34,35)))
			THEN 1
			ELSE 0
			END) AS Completed_HRA,
	SUM(CASE
		WHEN (pv.VisitModeId = 2 AND (pv.HraStatusId NOT IN (169,34,35)))
			THEN 1
			ELSE 0
			END) AS Completed_IAX,
	SUM(CASE
		WHEN (pv.VisitModeId = 5 AND (pv.HraStatusId NOT IN (169,34,35)))
			THEN 1
			ELSE 0
			END) AS Completed_FUA,
	SUM(CASE
		WHEN pv.HraStatusId IN (34,35)
			THEN 1
			ELSE 0
			END) AS Incomplete_Charts
	FROM SmartHRA.dbo.PatientVisit AS pv
	LEFT JOIN SmartHRA.dbo.VisitMode AS vm ON pv.VisitModeId = vm.Id
	LEFT JOIN SmartHRA.dbo.Person AS p ON pv.PhysicianUserId = p.UserId
	LEFT JOIN SmartHRA.dbo.Account AS a ON pv.AccountId = a.Id
	WHERE AwvDate > Convert(datetime, '2023-10-23')
		AND AwvDate < Convert(datetime, '2023-11-6')
		
	GROUP BY pv.PhysicianUserId,
			p.FirstName,
			p.LastName,
			a.CompanyName
	ORDER BY Account, Completed_FUA, Completed_IAX DESC, Full_Name;