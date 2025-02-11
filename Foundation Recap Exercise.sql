
/*
Foundation Recap Exercise

Use the table PatientStay.  
This lists 44 patients admitted to London hospitals over 5 days between Feb 26th and March 2nd 2024
*/

SELECT
	*
FROM
	PatientStay ps ;

/*
1. List the patients -
a) in the Oxleas or PRUH hospitals and
b) admitted in February 2024
c) only the Surgery wards

2. Show the PatientId, AdmittedDate, DischargeDate, Hospital and Ward columns only, not all the columns.
3. Order results by AdmittedDate (latest first) then PatientID column (high to low)
4. Add a new column LengthOfStay which calculates the number of days that the patient stayed in hospital, inclusive of both admitted and discharge date.
*/

-- Write the SQL statement here
select 
    ps.PatientId, 
    ps.AdmittedDate, 
    ps.DischargeDate, 
    ps.Hospital, 
    ps.Ward,
    DATEDIFF(day, ps.AdmittedDate, ps.DischargeDate) + 1 as LengthOfStay, -- [1 as LengthOfStay] adding new column, all values will be 1
    DATEADD(week, -2, ps.AdmittedDate) as ReminderDate
from 
    PatientStay ps
where 
    ps.Hospital in ('Oxleas','PRUH')
    AND ps.AdmittedDate between '2024-02-01' and '2024-02-29' --Like '2024-02%' (data is in date form not string so between is more effective/efficient)
    AND ps.Ward like '%Surgery%'
order by 
    ps.AdmittedDate DESC, 
    ps.PatientId DESC;



/*
5. How many patients has each hospital admitted? 
6. How much is the total tariff for each hospital?
7. List only those hospitals that have admitted over 10 patients
8. Order by the hospital with most admissions first
*/

-- Write the SQL statement here
SELECT 
    ps.Hospital, 
    COUNT(*) AS [Number of records], 
    SUM(ps.Tariff) as [Total Tariff]
FROM 
    PatientStay ps
--WHERE [Number of records] > 10 [should use HAVING when using COUNT/SUM (aggregation functions) - goes after GROUP BY]
GROUP BY 
    ps.Hospital
HAVING
    COUNT(*) > 10
ORDER BY 
    [Number of records] DESC;

SELECT *
FROM PatientStay;

SELECT * 
FROM DimHospital;

SELECT * 
FROM DimHospitalBad;

SELECT 
    ps.PatientId,
    ps.AdmittedDate,
    h.Type,
    h.Hospital
FROM 
    PatientStay ps 
LEFT JOIN 
    DimHospitalBad h 
    ON ps.Hospital = h.Hospital
WHERE 
    h.Type = 'Teaching'
OR      
    h.Type is NULL