SELECT 
	base.MemberId,
	base.AwvDate AS visit_date,
	base.DateofBirth,
	DATEDIFF(yy, base.DateofBirth ,GETDATE()) + (CASE WHEN DATEPART(MONTH, GETDATE()) - DATEPART(MONTH, base.DateofBirth) <0 THEN -1 ELSE 0 END) AS age,
	htn.code,
	htn.Name
FROM
	(SELECT pa.MemberId, pv.Id, pv.AwvDate, pe.DateofBirth
		FROM SmartHRA.dbo.PatientVisit AS pv
		INNER JOIN SmartHRA.dbo.Person AS pe
			ON pv.PatientId = pe.Id
		INNER JOIN SmartHRA.dbo.Patient AS pa
			ON pv.PatientId = pa.Id
		WHERE (pv.VisitModeId = 1)
			AND (pv.HraStatusId NOT IN (169,34,35))
			AND (pv.AwvDate > CONVERT (datetime, '2023-01-01'))
		GROUP BY pa.MemberId
			,pe.DateofBirth
			,pv.AwvDate
			,pv.id
			,pv.HraStatusId) AS base
LEFT JOIN
	(SELECT DISTINCT pd.PatientVisitId, ici.Code, ici.Name
	FROM SmartHRA.dbo.PatientDiagnosis AS pd
	INNER JOIN SmartHRA.dbo.IcdCode AS ici ON pd.IcdCodeId = ici.Id
	INNER JOIN SmartHRA.dbo.PatientVisit as pv ON pd.PatientVisitId = pv.Id
	WHERE (pd.IsDeleted =0)
		AND (pv.VisitModeId = 1)
		AND (pv.HraStatusId NOT IN (169,34,35))
		AND (ici.Name LIKE '%Hypertension%')) AS htn 
ON base.Id = htn.PatientVisitId

