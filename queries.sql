-- 1. Return the ID and Name of interviewers who participate in interviews where the interviewee's name is "Hellen Cole" arranged for job "11111".
SELECT DISTINCT e.EmployeeID, p.FirstName, p.LastName
FROM PARTICIPATES_IN pi
JOIN EMPLOYEE e ON pi.InterviewerID = e.EmployeeID
JOIN PERSON p ON e.PersonalID = p.PersonalID
JOIN POTENTIAL_EMPLOYEE pe ON pi.ApplicantID = pe.PotentialEmployeeID
JOIN PERSON interviewee ON pe.PersonalID = interviewee.PersonalID
JOIN INTERVIEWED_FOR int_for ON pi.InterviewID = int_for.InterviewID
WHERE interviewee.FirstName = 'Hellen' AND interviewee.LastName = 'Cole'
AND int_for.JobID = '11111';

-- 2. Return the ID of all jobs which are posted by department "Marketing" in January 2011.
SELECT j.JobID
FROM JOB_POSITION j
JOIN DEPARTMENT d ON j.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Marketing'
AND j.PostedDate BETWEEN '2011-01-01' AND '2011-01-31';

-- 3. Return the ID and Name of the employees having no supervisees.
SELECT e.EmployeeID, p.FirstName, p.LastName
FROM EMPLOYEE e
JOIN PERSON p ON e.PersonalID = p.PersonalID
WHERE e.EmployeeID NOT IN (SELECT DISTINCT SupervisorID FROM EMPLOYEE WHERE SupervisorID IS NOT NULL);

-- 4. Return the Id and Location of the marketing sites with no sale records during March 2011.
SELECT m.SiteID, m.Location
FROM MARKETING_SITE m
WHERE m.SiteID NOT IN (
    SELECT DISTINCT s.SiteID
    FROM SOLD_AT s
    WHERE EXTRACT(MONTH FROM s.SaleTime) = 3 
    AND EXTRACT(YEAR FROM s.SaleTime) = 2011
);

-- 5. Return the job's id and description, which does not hire a suitable person one month after it is posted.
SELECT j.JobID, j.JobDescription
FROM JOB_POSITION j
LEFT JOIN (
    SELECT 
        int_for.JobID, 
        AVG(i.Grade) AS AvgGrade, 
        COUNT(*) AS InterviewCount
    FROM INTERVIEWED_FOR int_for
    JOIN INTERVIEW i ON int_for.InterviewID = i.InterviewID
    GROUP BY int_for.JobID
) AS interview_stats ON j.JobID = interview_stats.JobID
WHERE (
    interview_stats.AvgGrade IS NULL 
    OR interview_stats.AvgGrade < 70 
    OR interview_stats.InterviewCount < 5
)
AND j.PostedDate < DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

-- 6. Return the ID and Name of the salespeople who have sold all product types whose price is above $200.
SELECT DISTINCT e.EmployeeID, p.FirstName, p.LastName
FROM EMPLOYEE e
JOIN PERSON p ON e.PersonalID = p.PersonalID
WHERE NOT EXISTS (
    SELECT ProductID
    FROM PRODUCT
    WHERE ListPrice > 200
    AND ProductID NOT IN (
        SELECT ProductID
        FROM SOLD_AT
        WHERE SalespersonID = e.EmployeeID
    )
);

-- 7. Return the department's id and name, which has no job post during 1/1/2011 and 2/1/2011.
SELECT d.DepartmentID, d.DepartmentName
FROM DEPARTMENT d
WHERE d.DepartmentID NOT IN (
    SELECT DISTINCT DepartmentID
    FROM JOB_POSITION
    WHERE PostedDate BETWEEN '2011-01-01' AND '2011-02-01'
);

-- 8. Return the ID, Name, and Department ID of the existing employees who apply for job "12345".
SELECT e.EmployeeID, p.FirstName, p.LastName, ems.DepartmentID
FROM EMPLOYEE e
JOIN PERSON p ON e.PersonalID = p.PersonalID
JOIN EMPLOYEE_MARKETING_SITE ems ON e.EmployeeID = ems.EmployeeID
JOIN POTENTIAL_EMPLOYEE pe ON e.PersonalID = pe.PersonalID
JOIN APPLIED_FOR af ON pe.PotentialEmployeeID = af.ApplicantID
WHERE af.JobID = '12345';

-- 9. Return the best seller's type in the company (sold the most items).
SELECT p.ProductType, SUM(s.Quantity) AS TotalSold
FROM PRODUCT p
JOIN SALE s ON p.ProductID = s.ProductID
GROUP BY p.ProductType
ORDER BY TotalSold DESC
LIMIT 1;

-- 10. Return the product type whose net profit is highest in the company (money earned minus the part cost).
SELECT p.ProductType, 
    SUM(s.Quantity * p.ListPrice) - SUM(pa.Weight) AS EstimatedNetProfit
FROM PRODUCT p
JOIN SALE s ON p.ProductID = s.ProductID
JOIN USES u ON p.ProductID = u.ProductID
JOIN PART pa ON u.PartID = pa.PartID
GROUP BY p.ProductType
ORDER BY EstimatedNetProfit DESC
LIMIT 1;

-- 11. Return the name and id of the employees who have worked in all departments after being hired by the company.
SELECT e.EmployeeID, p.FirstName, p.LastName
FROM EMPLOYEE e
JOIN PERSON p ON e.PersonalID = p.PersonalID
WHERE (
    SELECT COUNT(DISTINCT DepartmentID)
    FROM EMPLOYEE_MARKETING_SITE
    WHERE EmployeeID = e.EmployeeID
) = (SELECT COUNT(*) FROM DEPARTMENT);

-- 12. Return the name and email address of the interviewee who is selected.
SELECT p.FirstName, p.LastName, p.PhoneNum AS EmailAddress
FROM PERSON p
JOIN POTENTIAL_EMPLOYEE pe ON p.PersonalID = pe.PersonalID
JOIN PARTICIPATES_IN pi ON pe.PotentialEmployeeID = pi.ApplicantID
JOIN INTERVIEW i ON pi.InterviewID = i.InterviewID
GROUP BY p.PersonalID, p.FirstName, p.LastName, p.PhoneNum
HAVING AVG(i.Grade) > 70 AND COUNT(*) >= 5;

-- 13. Retrieve the names, phone numbers, and email addresses of the interviewees selected for all the jobs they apply for.
SELECT DISTINCT p.FirstName, p.LastName, p.PhoneNum AS PhoneNumber, p.PhoneNum AS EmailAddress
FROM PERSON p
JOIN POTENTIAL_EMPLOYEE pe ON p.PersonalID = pe.PersonalID
JOIN APPLIED_FOR af ON pe.PotentialEmployeeID = af.ApplicantID
JOIN PARTICIPATES_IN pi ON pe.PotentialEmployeeID = pi.ApplicantID
JOIN INTERVIEW i ON pi.InterviewID = i.InterviewID
GROUP BY p.PersonalID, p.FirstName, p.LastName, p.PhoneNum
HAVING AVG(i.Grade) > 70 AND COUNT(*) >= 5;

-- 14. Return the employee's name and id whose average monthly salary is the highest in the company.
SELECT e.EmployeeID, p.FirstName, p.LastName, AVG(s.Amount) AS AverageMonthlySalary
FROM EMPLOYEE e
JOIN PERSON p ON e.PersonalID = p.PersonalID
JOIN SALARY s ON e.EmployeeID = s.EmployeeID
GROUP BY e.EmployeeID, p.FirstName, p.LastName
ORDER BY AverageMonthlySalary DESC
LIMIT 1;

-- 15. Return the ID and Name of the vendor who supplies part whose name is "Cup" and weight is smaller than 4 pounds.
SELECT DISTINCT v.VendorID, v.Name
FROM VENDOR v
JOIN SUPPLIES s ON v.VendorID = s.VendorID
JOIN PART p ON s.PartID = p.PartID
WHERE p.PartName = 'Cup' AND p.Weight < 4;
