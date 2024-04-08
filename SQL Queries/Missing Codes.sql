SELECT 
    pa.MemberId,
	MAX(p.Npi) AS NPI,
    MAX(cpt.PatientVisitId) AS PatientVisitId,
    MAX(pv.AwvDate) AS visitDate,
	CASE 
		WHEN COUNT(DISTINCT CASE WHEN cpt.Code IN ('3074F', '3075F', '3077F') THEN cpt.Code END) > 0 THEN 1 
		ELSE 0 
	END AS hasCBPSystolicCodes,
		MAX(CASE 
				WHEN questionid = 252
					THEN answer
				END) AS [Left_Systolic],
		MAX(CASE 
				WHEN questionid = 6818
					THEN answer
				END) AS [Right_Systolic],
	CASE 
		WHEN COUNT(DISTINCT CASE WHEN cpt.Code IN ('3078F', '3079F', '3080F') THEN cpt.Code END) > 0 THEN 1 
		ELSE 0 
	END AS hasCBPDiastolicCodes,

		MAX(CASE 
				WHEN questionid = 253
					THEN answer
				END) AS [Left_Diastolic],

		MAX(CASE 
				WHEN questionid = 6819
					THEN answer
				END) AS [Right_Diastolic],
	CASE 
		WHEN COUNT(DISTINCT CASE WHEN cpt.Code IN ('1170F') THEN cpt.Code END) > 0 THEN 1 
		ELSE 0 
	END AS hasCOAFACode,
	CASE 
		WHEN COUNT(DISTINCT CASE WHEN cpt.Code IN ('1125F', '1126F') THEN cpt.Code END) > 0 THEN 1 
		ELSE 0 
	END AS hasCOAPSCodes,
		MAX(CASE 
			WHEN questionid = 6711
				THEN answer
			END) AS [Pain_Score],
	CASE 
		WHEN COUNT(DISTINCT CASE WHEN cpt.Code = '1159F' THEN cpt.Code END) > 0 AND 
				COUNT(DISTINCT CASE WHEN cpt.Code = '1160F' THEN cpt.Code END) > 0 THEN 1 
		ELSE 0 
	END AS hasCOAMRCodes
FROM SmartHRA.dbo.PatientCptTwoCode AS cpt
LEFT JOIN SmartHRA.dbo.PatientVisit AS pv ON cpt.PatientVisitId = pv.Id
LEFT JOIN SmartHRA.dbo.Person AS p ON pv.PhysicianUserId = p.UserId
INNER JOIN SmartHRA.dbo.Patient AS pa ON pv.PatientId = pa.Id
	LEFT OUTER JOIN SmartHRA.dbo.PatientAnswer AS pan ON pv.Id = pan.PatientVisitId
		AND pan.IsDeleted = 0 
		AND pan.QuestionId IN (
			252,
			253,
			6818,
			6819,
			6711
			)
WHERE 
    (pv.VisitModeId = 1)
    AND (pv.AccountId = 15)
    AND (pv.HraStatusId NOT IN (169, 34, 35))
    AND (cpt.IsDeleted = 0)
    AND (AwvDate > CONVERT(DATETIME, '2024-03-01'))
    AND (AwvDate < CONVERT(DATETIME, '2024-03-25'))
GROUP BY pa.MemberId