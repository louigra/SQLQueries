SELECT dbo.Patient.MemberId
	,DATEDIFF(year, dbo.Person.DateofBirth, pv.AwvDate) AS age
	,MAX(CASE 
			WHEN questionid = 5552
				THEN answer
			END) AS [Transportation Difficult]
	,MAX(CASE 
			WHEN questionid = 5117
				THEN answer
			END) AS [Falls Risk]
	,MAX(CASE 
			WHEN questionid = 5115
				THEN answer
			END) AS [Balance Issues]
	,med AS [Med Cnt]
	,COALESCE(max(CASE 
				WHEN questionid = 5709
					THEN answer
				END), ' ') AS [Patient Status]
	,Diag AS [Diag Cnt]
	,sms.memberStatus
FROM dbo.PatientVisit AS pv
INNER JOIN dbo.Person ON pv.PatientId = dbo.Person.Id
INNER JOIN dbo.Patient ON pv.PatientId = dbo.Patient.Id
LEFT OUTER JOIN dbo.Scott_Member_Status AS sms ON dbo.Patient.MemberId = sms.memberid
	AND pv.InsuranceCarierId = sms.insuranceCarrierID
LEFT OUTER JOIN dbo.PatientAnswer AS pa ON pv.Id = pa.PatientVisitId
	AND pa.IsDeleted = 0
	AND pa.QuestionId IN (
		5552
		,5117
		,5115
		,5709
		)
CROSS APPLY (
	SELECT v.id
		,count(upper(trim(replace(left(pcm.name, charindex(', ', pcm.name)), ', ', ' ')))) AS med
	FROM dbo.PatientCurrentMedication pcm
	INNER JOIN dbo.PatientVisit v ON pcm.PatientVisitId = v.Id
	WHERE (pcm.IsDeleted = 0)
		AND (pcm.IsOtc = 0)
	GROUP BY v.id
	) a
CROSS APPLY (
	SELECT PatientVisit.Id
		,count(dbo.Diagnosis.Name) AS Diag
	FROM dbo.PatientDiagnosis
	INNER JOIN dbo.Diagnosis ON dbo.PatientDiagnosis.DiagnosisId = dbo.Diagnosis.Id
	INNER JOIN dbo.PatientVisit ON dbo.PatientDiagnosis.PatientVisitId = dbo.PatientVisit.Id
	WHERE (dbo.PatientDiagnosis.IsAccepted = 1)
		AND (dbo.PatientDiagnosis.IsDeleted = 0)
	GROUP BY PatientVisit.Id
	) b
WHERE (pv.VisitModeId = 2)
	AND (pv.HraStatusId = 127)
	AND a.id = pv.id
	AND b.id = pv.id
GROUP BY dbo.Patient.MemberId
	,dbo.Person.DateofBirth
	,pv.AwvDate
	,med
	,pv.id
	,diag
	,sms.memberStatus
