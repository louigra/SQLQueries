
WITH CTE AS (
    SELECT 
        pa.MemberId, 
        pd.PatientVisitId, 
        pd.IsAccepted, 
        pd.IsRejected, 
        pd.IsDeleted, 
        ici.Code, 
        ci.[ICD-10-CM CODE], 
        ci.[CHRONIC INDICATOR] AS Chronic,
        LEFT(ici.Code, 3) AS FirstThreeCharacters,
        ROW_NUMBER() OVER (PARTITION BY pa.MemberId, LEFT(ici.Code, 3) ORDER BY pa.MemberId, ici.Code) AS RowNum
    FROM SmartHRA.dbo.PatientDiagnosis AS pd
    INNER JOIN SmartHRA.dbo.IcdCode AS ici ON pd.IcdCodeId = ici.Id
    LEFT JOIN SmartHRA.dbo.icd10ChronicIndicators AS ci ON REPLACE(ici.Code, '.', '') = ci.[ICD-10-CM CODE]
    LEFT JOIN SmartHRA.dbo.PatientVisit AS pv ON pd.PatientVisitId = pv.Id
    INNER JOIN SmartHRA.dbo.Patient AS pa ON pv.PatientId = pa.Id
    WHERE 
        (pd.IsDeleted = 0)
        AND (pv.VisitModeId = 2)
        AND (pv.AccountId = 21)
        AND (pv.HraStatusId NOT IN (169,34,35))
)
SELECT 
	CTE.MemberId,
	COUNT(CASE WHEN Chronic = 1 THEN 1 END) AS Chronic_Indicator_Yes_Count,
    COUNT(CASE WHEN Chronic = 0 THEN 1 END) AS Chronic_Indicator_No_Count,
    COUNT(CASE WHEN Chronic = 9 THEN 1 END) AS Chronic_Indicator_NA_Count
FROM CTE
WHERE RowNum = 1
GROUP BY CTE.MemberId
ORDER BY CTE.MemberId
