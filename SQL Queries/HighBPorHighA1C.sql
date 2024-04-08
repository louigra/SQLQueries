SELECT *
FROM
(
	SELECT SmartHRA.dbo.Patient.MemberId, pv.Id, pv.AwvDate, sms.memberStatus
		,MAX(CASE 
				WHEN questionid = 5725
					THEN answer
				END) AS [Seen_PCP_Last_12_Months]
		,MAX(CASE 
				WHEN questionid = 6808
					THEN answer
				END) AS [How_Often]
		,MAX(CASE 
				WHEN questionid = 6807
					THEN answer
				END) AS [Last_PCP_Visit]
		,MAX(CASE
				WHEN questionid = 70075
					THEN answer
				END) AS [Diabetes]
		,MAX(CASE 
				WHEN questionid = 70224
					THEN answer
				END) AS [HOME_A1C]
		,MAX(CASE 
				WHEN questionid = 70209
					THEN convert(DECIMAL(4,1),answer)
				END) AS [A1C_Value]
		,MAX(CASE 
				WHEN questionid = 252
					THEN answer
				END) AS [Left_Systolic]
		,MAX(CASE 
				WHEN questionid = 253
					THEN answer
				END) AS [Left_Diastolic]
		,MAX(CASE 
				WHEN questionid = 6818
					THEN answer
				END) AS [Right_Systolic]
		,MAX(CASE 
				WHEN questionid = 6819
					THEN answer
				END) AS [Right_Diastolic]
	FROM SmartHRA.dbo.PatientVisit AS pv
	INNER JOIN SmartHRA.dbo.Person 
		ON pv.PatientId = SmartHRA.dbo.Person.Id
	INNER JOIN SmartHRA.dbo.Patient 
		ON pv.PatientId = SmartHRA.dbo.Patient.Id
	LEFT OUTER JOIN SmartHRA.dbo.Scott_Member_Status AS sms ON SmartHRA.dbo.Patient.MemberId = sms.memberid
		AND pv.InsuranceCarierId = sms.insuranceCarrierID
	LEFT OUTER JOIN SmartHRA.dbo.PatientAnswer AS pa ON pv.Id = pa.PatientVisitId
		AND pa.IsDeleted = 0
		AND pa.QuestionId IN (
			5725,
			70224,
			70075,
			70209,
			6808,
			6807,
			252,
			253,
			6818,
			6819
			)
	WHERE (pv.VisitModeId = 2)
		AND (pv.AccountId = 21)
		AND (pv.HraStatusId NOT IN (169,34,35))
	GROUP BY SmartHRA.dbo.Patient.MemberId
		,SmartHRA.dbo.Person.DateofBirth
		,pv.AwvDate
		,pv.id
		,pv.HraStatusId
		,sms.memberStatus
) AS base
WHERE base.A1C_Value >= 7.0
	OR Left_Systolic >= 160
	OR Right_Systolic >= 160;