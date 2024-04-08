SELECT pa.MemberId, pv.Id, pv.AwvDate, sms.memberStatus, pd.IsDeleted, pd.IsAccepted, PD.IsRejected, ici.Code, ici.Name, CI.[ICD-10-CM CODE], CI.[CHRONIC INDICATOR] AS chronic
	FROM SmartHRA.dbo.PatientVisit AS pv
	INNER JOIN SmartHRA.dbo.Person 
		ON pv.PatientId = SmartHRA.dbo.Person.Id
	INNER JOIN SmartHRA.dbo.Patient AS pa
		ON pv.PatientId = pa.Id
	LEFT OUTER JOIN SmartHRA.dbo.Scott_Member_Status AS sms ON pa.MemberId = sms.memberid
		AND pv.InsuranceCarierId = sms.insuranceCarrierID
	INNER JOIN SmartHRA.dbo.PatientDiagnosis AS pd ON pv.Id = pd.PatientVisitId
	INNER JOIN SmartHRA.dbo.IcdCode AS ici ON pd.IcdCodeId = ici.Id
	LEFT JOIN SmartHra.dbo.ICDChronicIndicators AS CI
		ON  REPLACE(ici.Code, '.', '') = CI.[ICD-10-CM CODE]
	WHERE 	(pd.IsDeleted = 0)
		AND	(pv.VisitModeId = 2)
		AND (pv.AccountId = 21)
		AND (pv.HraStatusId NOT IN (169,34,35))
		--AND (pa.MemberId = '2EK5KH0AC58')
	GROUP BY pa.MemberId
		,SmartHRA.dbo.Person.DateofBirth
		,pv.AwvDate
		,pv.id
		,pv.HraStatusId
		,sms.memberStatus,
		ici.Code,
		ici.Name,
		pd.IsDeleted, 
		pd.IsAccepted, 
		PD.IsRejected,
		CI.[ICD-10-CM CODE], 
		CI.[CHRONIC INDICATOR]