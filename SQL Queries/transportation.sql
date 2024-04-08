SELECT SmartHRA.dbo.Patient.MemberId AS Member_Id, 
pv.Id AS VisitId, 
pv.AwvDate AS VisitDate, 
sms.memberStatus AS Status,
a.CompanyName AS Account,
    MAX(CASE 
            WHEN questionid = 5552
                THEN answer
            END) AS [Transportation_Difficulty]
FROM SmartHRA.dbo.PatientVisit AS pv
INNER JOIN SmartHRA.dbo.Person 
    ON pv.PatientId = SmartHRA.dbo.Person.Id
INNER JOIN SmartHRA.dbo.Patient 
    ON pv.PatientId = SmartHRA.dbo.Patient.Id
LEFT OUTER JOIN SmartHRA.dbo.Scott_Member_Status AS sms ON SmartHRA.dbo.Patient.MemberId = sms.memberid
    AND pv.InsuranceCarierId = sms.insuranceCarrierID
LEFT OUTER JOIN SmartHRA.dbo.Account AS a ON pv.AccountId = a.Id
LEFT OUTER JOIN SmartHRA.dbo.PatientAnswer AS pa ON pv.Id = pa.PatientVisitId
    AND pa.IsDeleted = 0
    AND pa.QuestionId IN (
        5552
        )
WHERE (pv.VisitModeId = 2)
    AND (pv.HraStatusId NOT IN (169,34,35))
GROUP BY SmartHRA.dbo.Patient.MemberId
    ,SmartHRA.dbo.Person.DateofBirth
    ,pv.AwvDate
    ,pv.id
    ,pv.HraStatusId
    ,sms.memberStatus
    ,a.CompanyName