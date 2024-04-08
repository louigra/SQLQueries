SELECT
    cpt.ProcedureCode,
    COUNT(DISTINCT claim.PatientVisitId) AS VisitCount
FROM SmartHRA.dbo.MedicalClaimCptTwoCode AS cpt
LEFT JOIN SmartHRA.dbo.MedicalClaim AS claim 
    ON cpt.ClaimId = claim.ID
LEFT JOIN SmartHRA.dbo.PatientVisit AS pv
    ON claim.PatientVisitId = pv.Id
INNER JOIN SmartHRA.dbo.Patient AS pa
    ON pv.PatientId = pa.Id
WHERE (pv.VisitModeId = 1)
AND (pv.AwvDate > Convert(datetime, '2023-01-01'))
GROUP BY cpt.ProcedureCode
ORDER BY cpt.ProcedureCode DESC;