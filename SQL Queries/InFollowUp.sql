SELECT 
    pa.MemberId,
    pe.FirstName,
    pe.LastName,
    pv.Awvdate AS VisitDate,
    sms.memberStatus
FROM SmartHra.dbo.Person AS pe
LEFT JOIN SmartHra.dbo.PatientVisit AS pv ON pe.Id = pv.PatientId
LEFT JOIN SmartHra.dbo.Patient AS pa ON pe.Id = pa.Id
LEFT JOIN SmartHra.dbo.Scott_Member_Status AS sms ON pa.MemberId = sms.memberid
WHERE (pv.AccountId = 21)
    AND (pv.VisitModeId = 5)
    AND (pv.HraStatusId NOT IN (169))
    ;