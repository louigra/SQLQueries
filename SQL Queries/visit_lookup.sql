SELECT pa.MemberId,
pv.AwvDate AS VisitDate,
CONCAT(p.LastName, ', ', p.FirstName) AS Full_Name,
pv.Id 
FROM SmartHRA.dbo.PatientVisit as pv
LEFT JOIN SmartHRA.dbo.Person AS p 
    ON pv.PhysicianUserId = p.UserId
LEFT JOIN SmartHRA.dbo.Person AS p2
    ON pv.PatientId = p2.Id
LEFT JOIN SmartHRA.dbo.Patient AS pa
    ON pv.PatientId = pa.Id
WHERE pv.AwvDate > Convert(datetime, '2023-11-28')
	AND pv.AwvDate < Convert(datetime, '2023-11-30')
    AND pa.MemberId = '134312187'