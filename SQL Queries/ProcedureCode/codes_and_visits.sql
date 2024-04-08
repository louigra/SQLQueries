SELECT DISTINCT 
	pa.MemberId,
	pv.AwvDate,
	cpt.Id,
	cpt.ClaimId,
	cpt.ProcedureCode,
	cpt.IsDeleted,
	claim.PatientVisitId,
	claim.ClaimNumber
FROM SmartHRA.dbo.MedicalClaimCptTwoCode AS cpt
LEFT JOIN SmartHRA.dbo.MedicalClaim AS claim 
	ON cpt.ClaimId = claim.ID
LEFT JOIN SmartHRA.dbo.PatientVisit AS pv
	ON claim.PatientVisitId = pv.Id
INNER JOIN SmartHRA.dbo.Patient AS pa
	ON pv.PatientId = pa.Id
WHERE (pv.VisitModeId = 1)
	AND (pv.AwvDate > Convert(datetime, '2023-01-01'))
ORDER BY pa.MemberID DESC, pv.AwvDate DESC, cpt.ProcedureCode DESC;
