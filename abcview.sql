-- View1
CREATE VIEW AverageMonthlySalary AS
SELECT 
    EmployeeID,
    AVG(Amount) AS AverageSalaryPerMonth
FROM 
    Salary
GROUP BY 
    EmployeeID;

-- View2
CREATE VIEW PassedInterviewRounds AS
SELECT 
    Interview_Status.IntervieweeID,
    Interview.JobID,
    COUNT(*) AS PassedRounds
FROM 
    Interview_Status
JOIN 
    Interview ON Interview_Status.InterviewID = Interview.InterviewID
WHERE 
    Interview_Status.Status = 1
GROUP BY 
    Interview_Status.IntervieweeID, Interview.JobID;

-- View3
CREATE VIEW ProductTypeSales AS
SELECT 
    Product.ProductType,
    SUM(Product_Details.Quantity) AS TotalItemsSold
FROM 
    Product_Details
JOIN 
    Product ON Product_Details.ProductID = Product.ProductID
GROUP BY 
    Product.ProductType;

-- View4
CREATE VIEW ProductPartCost AS
SELECT 
    Consists_of.ProductID,
    SUM(Consists_of.Quantity * Supplies.Price) AS TotalPartCost
FROM 
    Consists_of
JOIN 
    Supplies ON Consists_of.PartID = Supplies.PartID
GROUP BY 
    Consists_of.ProductID;