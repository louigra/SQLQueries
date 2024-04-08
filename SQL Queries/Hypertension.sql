SELECT DISTINCT pd.PatientVisitId, pd.IcdCodeId, ici.Code, ici.Name
FROM SmartHRA.dbo.PatientDiagnosis AS pd
INNER JOIN SmartHRA.dbo.IcdCode AS ici ON pd.IcdCodeId = ici.Id
INNER JOIN SmartHRA.dbo.PatientVisit as pv ON pd.PatientVisitId = pv.Id
WHERE (ici.Name LIKE '%Hypertension%')
	AND (pv.VisitModeId = 2)
	AND (pv.AccountId = 21)
	AND (pv.HraStatusId NOT IN (169,34,35));