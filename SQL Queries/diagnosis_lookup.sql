SELECT DISTINCT pd.PatientVisitId, ici.Code, ici.Name, pd.IsAccepted, pd.IsRejected, pd.IsDeleted
	FROM SmartHRA.dbo.PatientDiagnosis AS pd
	INNER JOIN SmartHRA.dbo.IcdCode AS ici ON pd.IcdCodeId = ici.Id
	INNER JOIN SmartHRA.dbo.PatientVisit as pv ON pd.PatientVisitId = pv.Id
    WHERE pv.Id = 227209