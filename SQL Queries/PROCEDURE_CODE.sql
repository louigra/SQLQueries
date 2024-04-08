SELECT 
	pvhc.PatientVisitId,
	pvhc.Code,
	pvhc.DateCreated AS created_date,
	pv.AwvDate AS visit_date,
	p.MemberId,
	vm.VisitName,
	ic.OrganizationName AS account
FROM SmartHRA.dbo.PatientVisitHcpcsCode AS pvhc
INNER JOIN SmartHRA.dbo.PatientVisit AS pv
	ON pvhc.PatientVisitId = pv.Id
INNER JOIN SmartHRA.dbo.Patient AS p
	ON pv.PatientId = p.Id
INNER JOIN SmartHRA.dbo.VisitMode AS vm
	ON pv.VisitModeID = vm.Id
INNER JOIN SmartHRA.dbo.InsuranceCarrier AS ic
	ON pv.InsuranceCarierId = ic.Id
WHERE ic.CompanyName = 'Care at Home'
	AND pv.IsDeleted = 0
ORDER BY pvhc.PatientVisitId;