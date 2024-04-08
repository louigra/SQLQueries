
SELECT COUNT(DISTINCT PatientVisitId) AS TotalVisits
FROM
(SELECT 
	cpt.ClaimId,
	claim.PatientVisitId,
	claim.ClaimNumber
FROM SmartHRA.dbo.MedicalClaimCptTwoCode AS cpt
LEFT JOIN SmartHRA.dbo.MedicalClaim AS claim 
	ON cpt.ClaimId = claim.ID
LEFT JOIN SmartHRA.dbo.PatientVisit AS pv
    ON claim.PatientVisitId = pv.Id
WHERE (pv.AwvDate > Convert(datetime, '2023-01-01'))) as base;