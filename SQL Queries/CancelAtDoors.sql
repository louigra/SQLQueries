SELECT 
    ao.AppointmentId,
    ao.OptedDate,
    cr.Reason,
	phy.mhcp_Physician_Name AS "providerName",
	dapt.AppointmentDate,
	dapt.DeletededOn,
	CAST(DATEDIFF(MINUTE, dapt.AppointmentDate, dapt.DeletededOn) / 60.0 AS DECIMAL(10,1)) AS HoursDifference
FROM 
    TMedicalManagement.dbo.AppointmentsOpted AS ao
LEFT JOIN TMedicalManagement.dbo.CancelationReason AS cr
    ON ao.CancelationReasonId = cr.Id
LEFT JOIN TMedicalManagement.dbo.mhc_Delivery_Physician AS phy
	ON ao.VisitPhysicianId = phy.mhcp_ID
LEFT JOIN TMedicalManagement.dbo.DeletedAppointment AS dapt
	ON ao.AppointmentId = dapt.AppointmentId
WHERE ao.CancelationReasonId IN (1,2)
        AND AppointmentDate > Convert(datetime, '2024-03-11')
		AND AppointmentDate < Convert(datetime, '2024-03-25')
ORDER BY providerName