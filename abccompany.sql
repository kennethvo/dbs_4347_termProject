CREATE DATABASE ABCCompany;
USE ABCCompany;

-- DEPARTMENT
CREATE TABLE DEPARTMENT (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

-- PERSON
CREATE TABLE PERSON (
    PersonalID INT PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    Age INT CHECK (Age < 65),
    Gender VARCHAR(10),
);
-- PERSON_ADDRESS
CREATE TABLE PERSON_ADDRESS (
    PersonalID INT,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(20),
    PRIMARY KEY (PersonalID, Address, City, State, ZipCode),
    FOREIGN KEY (PersonalID) REFERENCES Person(PersonalID)
);
-- PERSON_PHONENUMBER
CREATE TABLE PERSON_PHONENUMBER (
    PersonalID INT,
    PhoneNumber VARCHAR(15),
    PRIMARY KEY (PersonalID, PhoneNumber),
    FOREIGN KEY (PersonalID) REFERENCES Person(PersonalID)
);
-- EMPLOYEE
CREATE TABLE EMPLOYEE (
    EmployeeID INT PRIMARY KEY,
    PersonalID INT NOT NULL,
    EmpRank VARCHAR(50),
    Title VARCHAR(50),
    SupervisorID INT,
    FOREIGN KEY (PersonalID) REFERENCES PERSON(PersonalID),
    FOREIGN KEY (SupervisorID) REFERENCES EMPLOYEE(EmployeeID)
);

-- CUSTOMER
CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY,
    PersonalID INT NOT NULL,
    PreferredSalespersonID INT,
    FOREIGN KEY (PersonalID) REFERENCES PERSON(PersonalID),
    FOREIGN KEY (PreferredSalespersonID) REFERENCES EMPLOYEE(EmployeeID)
);

-- POTENTIAL_EMPLOYEE
CREATE TABLE POTENTIAL_EMPLOYEE (
    PotentialEmployeeID INT PRIMARY KEY,
    PersonalID INT NOT NULL,
    FOREIGN KEY (PersonalID) REFERENCES PERSON(PersonalID)
);

-- JOB_POSITION
CREATE TABLE JOB_POSITION (
    JobID INT PRIMARY KEY,
    DepartmentID INT NOT NULL,
    JobDescription TEXT NOT NULL,
    PostedDate DATE NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID)
);

-- INTERVIEW
CREATE TABLE INTERVIEW (
    InterviewID INT PRIMARY KEY,
    JobID INT NOT NULL,
    InterviewTime DATETIME NOT NULL,
    FOREIGN KEY (JobID) REFERENCES JOB_POSITION(JobID),
);

-- INTERVIEW_GRADE
CREATE TABLE INTERVIEW_GRADE (
    InterviewID INT NOT NULL,
    IntervieweeID INT NOT NULL,
    InterviewerID INT NOT NULL,
    Grade INT CHECK (Grade >= 0 AND Grade <= 100),
    PRIMARY KEY (InterviewID, IntervieweeID, InterviewerID),
    FOREIGN KEY (InterviewID) REFERENCES INTERVIEW(InterviewID),
    FOREIGN KEY (IntervieweeID) REFERENCES POTENTIAL_EMPLOYEE(PotentialEmployeeID),
    FOREIGN KEY (InterviewerID) REFERENCES EMPLOYEE(EmployeeID)
);

-- INTERVIEW_STATUS
CREATE TABLE INTERVIEW_STATUS (
    InterviewID INT PRIMARY KEY,
    IntervieweeID INT NOT NULL,
    Status INT CHECK (Status >= 0 AND Status <= 1),
    Grade INT CHECK (Grade >= 0 AND Grade <= 100),
    PRIMARY KEY (InterviewID, IntervieweeID),
    FOREIGN KEY (InterviewID) REFERENCES INTERVIEW(InterviewID),
    FOREIGN KEY (IntervieweeID) REFERENCES POTENTIAL_EMPLOYEE(PotentialEmployeeID),
);

-- PRODUCT
CREATE TABLE PRODUCT (
    ProductID INT PRIMARY KEY,
    ProductType VARCHAR(50) NOT NULL,
    Size VARCHAR(20),
    ListPrice DECIMAL(10, 2) NOT NULL,
    Weight DECIMAL(8, 2),
    Style VARCHAR(50)
);

-- MARKETING_SITE
CREATE TABLE MARKETING_SITE (
    SiteID INT PRIMARY KEY,
    SiteName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL
);

-- SALE
CREATE TABLE SALE (
    SaleID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    EmployeeID INT NOT NULL,
    SiteID INT NOT NULL,
    SaleTime DATETIME NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID),
    FOREIGN KEY (SiteID) REFERENCES MARKETING_SITE(SiteID)
);

-- PRODUCT_DETAILS
CREATE TABLE PRODUCT_DETAILS (
    SaleID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (SaleID, ProductID),
    FOREIGN KEY (SaleID) REFERENCES SALE(SaleID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
);

-- VENDOR
CREATE TABLE VENDOR (
    VendorID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    AccountNumber VARCHAR(50) NOT NULL,
    CreditRating VARCHAR(20),
    URL VARCHAR(255)
);

--VENDOR_ADDRESS
CREATE TABLE VENDOR_ADDRESS (
    VendorID INT,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(20),
    PRIMARY KEY (VendorID, Address, City, State, ZipCode),
    FOREIGN KEY (VendorID) REFERENCES VENDOR(VendorID)
);

-- PART
CREATE TABLE PART (
    PartID INT PRIMARY KEY,
    PartName VARCHAR(100) NOT NULL,
    Weight DECIMAL(8, 2),
    VendorID INT,
    ProductID INT,
    FOREIGN KEY (VendorID) REFERENCES VENDOR(VendorID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
);

-- SALARY
CREATE TABLE SALARY (
    TransactionNumber INT PRIMARY KEY,
    EmployeeID INT,
    PayDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (TransactionNumber, EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
);

-- RELATIONS (M:N)
CREATE TABLE APPLIED_FOR (
	ApplicantID INT,
    JobID INT,
    ApplicationDate DATE,
    FOREIGN KEY (ApplicantID) REFERENCES POTENTIAL_EMPLOYEE(PotentialEmployeeID),
    FOREIGN KEY (JobID) REFERENCES JOB_POSITION(JobID)
);

CREATE TABLE USES (
	ProductID INT,
    PartID INT,
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID),
    FOREIGN KEY (PartID) REFERENCES PART(PartID)
);

CREATE TABLE SUPPLIES (
	VendorID INT,
    PartID INT,
    FOREIGN KEY (VendorID) REFERENCES VENDOR(VendorID),
    FOREIGN KEY (PartID) REFERENCES PART(PartID)
);

CREATE TABLE WORKS_FOR (
    EmployeeID INT,
    DepartmentID INT,
    Shift_Start TIME,
    Shift_End TIME,
    CurrentDept INT CHECK (CurrentDept >= 0 AND CurrentDept <= 1),
    PRIMARY KEY (EmployeeID, DepartmentID),
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID)
);

CREATE TABLE WORKS_AT (
    EmployeeID INT,
    SiteID INT,
    PRIMARY KEY (EmployeeID, SiteID),
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID),
    FOREIGN KEY (SiteID) REFERENCES MARKETING_SITE(SiteID)
);

INSERT INTO DEPARTMENT (DepartmentID, DepartmentName) VALUES
(1, 'Sales'),
(2, 'Marketing'),
(3, 'Human Resources'),
(4, 'Engineering'),
(5, 'Finance');

INSERT INTO PERSON (PersonalID, LastName, FirstName, Age, Gender, PhoneNum, Address, City, State, ZipCode) VALUES
(1, 'Smith', 'John', 35, 'Male', 2642546, '123 Main St', 'New York', 'NY', '10001'),
(2, 'Johnson', 'Emily', 28, 'Female', 9682834, '456 Elm St', 'Los Angeles', 'CA', '90001'),
(3, 'Williams', 'Michael', 42, 'Male', 1848453, '789 Oak St', 'Chicago', 'IL', '60601'),
(4, 'Brown', 'Sarah', 31, 'Female', 4567890, '321 Pine St', 'Houston', 'TX', '77001'),
(5, 'Jones', 'David', 39, 'Male', 5063912, '654 Maple St', 'Phoenix', 'AZ', '85001'),
(6, 'Garcia', 'Maria', 45, 'Female', 2034954, '987 Cedar St', 'Philadelphia', 'PA', '19101'),
(7, 'Miller', 'James', 33, 'Male', 5062345, '147 Birch St', 'San Antonio', 'TX', '78201'),
(8, 'Davis', 'Jennifer', 29, 'Female', 3456854, '258 Walnut St', 'San Diego', 'CA', '92101'),
(9, 'Rodriguez', 'Carlos', 37, 'Male', 5234334, '369 Spruce St', 'Dallas', 'TX', '75201'),
(10, 'Martinez', 'Lisa', 41, 'Female', 1111111, '741 Ash St', 'San Jose', 'CA', '95101'),
(11, 'Cole', 'Hellen', 30, 'Female', 9876543, '159 Pine St', 'Miami', 'FL', '33101'),
(12, 'Taylor', 'Robert', 36, 'Male', 8765432, '753 Oak St', 'Boston', 'MA', '02101');

INSERT INTO EMPLOYEE (EmployeeID, PersonalID, EmpRank, Title, SupervisorID) VALUES
(1, 1, 'Senior', 'Sales Manager', NULL),
(2, 2, 'Junior', 'Marketing Specialist', 1),
(3, 3, 'Mid-level', 'HR Coordinator', 1),
(4, 4, 'Senior', 'Software Engineer', 1),
(5, 5, 'Mid-level', 'Financial Analyst', 1),
(6, 6, 'Junior', 'Sales Representative', 1),
(7, 7, 'Junior', 'Marketing Assistant', 2),
(8, 8, 'Mid-level', 'Product Manager', 1);

INSERT INTO CUSTOMER (CustomerID, PersonalID, PreferredSalespersonID) VALUES
(1, 9, 1),
(2, 10, 2),
(3, 11, 1);

INSERT INTO POTENTIAL_EMPLOYEE (PotentialEmployeeID, PersonalID) VALUES
(1, 12);

INSERT INTO JOB_POSITION (JobID, DepartmentID, JobDescription, PostedDate) VALUES
(11111, 1, 'Senior Sales Representative', '2011-01-15'),
(22222, 2, 'Digital Marketing Specialist', '2011-01-20'),
(33333, 3, 'HR Assistant', '2011-02-15'),
(44444, 4, 'Junior Software Developer', '2011-03-01'),
(55555, 5, 'Accounting Clerk', '2011-03-15'),
(12345, 2, 'Content Marketing Manager', '2023-05-01');

INSERT INTO INTERVIEW (InterviewID, JobID, IntervieweeID, InterviewerID, InterviewTime, Grade) VALUES
(1, 11111, 1, 1, '2011-01-25 10:00:00', 85),
(2, 11111, 1, 2, '2011-01-26 14:00:00', 78),
(3, 11111, 1, 3, '2011-01-27 11:00:00', 92),
(4, 11111, 1, 4, '2011-01-28 13:00:00', 88),
(5, 11111, 1, 5, '2011-01-29 15:00:00', 95),
(6, 12345, 1, 2, '2023-05-10 10:00:00', 90),
(7, 12345, 1, 3, '2023-05-11 11:00:00', 85);

INSERT INTO PRODUCT (ProductID, ProductType, Size, ListPrice, Weight, Style) VALUES
(1, 'Laptop', '15 inch', 999.99, 2.5, 'Modern'),
(2, 'Smartphone', '6.1 inch', 699.99, 0.2, 'Sleek'),
(3, 'Tablet', '10 inch', 499.99, 0.5, 'Compact'),
(4, 'Desktop', 'Tower', 1299.99, 10.0, 'Professional'),
(5, 'Smartwatch', '1.5 inch', 299.99, 0.05, 'Sporty');

INSERT INTO MARKETING_SITE (SiteID, SiteName, Location) VALUES
(1, 'Downtown Store', 'New York City'),
(2, 'Mall Kiosk', 'Los Angeles'),
(3, 'Online Store', 'www.abccompany.com'),
(4, 'Airport Shop', 'Chicago O''Hare'),
(5, 'Tech Expo Booth', 'Las Vegas Convention Center');

INSERT INTO SALE (SaleID, ProductID, CustomerID, EmployeeID, SiteID, SaleTime, Quantity) VALUES
(1, 1, 1, 1, 1, '2011-02-01 10:30:00', 1),
(2, 2, 2, 2, 2, '2011-02-02 14:45:00', 2),
(3, 3, 3, 1, 3, '2011-02-03 09:15:00', 1),
(4, 4, 1, 2, 4, '2011-02-04 16:20:00', 1),
(5, 5, 2, 1, 5, '2011-02-05 11:00:00', 3);

INSERT INTO VENDOR (VendorID, Name, Address, City, State, ZipCode, AccountNumber, CreditRating, URL) VALUES
(1, 'TechSupplies Inc.', '789 Tech Blvd', 'San Jose', 'CA', '95101', 'TS001', 'Excellent', 'https://api.techsupplies.com'),
(2, 'ElectroComponents Ltd.', '456 Circuit Ave', 'Austin', 'TX', '78701', 'EC002', 'Good', 'https://api.electrocomponents.com'),
(3, 'GlobalParts Co.', '123 World St', 'Seattle', 'WA', '98101', 'GP003', 'Fair', 'https://api.globalparts.com');

INSERT INTO PART (PartID, PartName, Weight, VendorID, ProductID) VALUES
(1, 'CPU', 0.1, 1, 1),
(2, 'RAM', 0.05, 1, 1),
(3, 'SSD', 0.2, 2, 1),
(4, 'Display', 0.5, 2, 2),
(5, 'Battery', 0.3, 3, 2),
(6, 'Cup', 0.2, 1, NULL);

INSERT INTO SALARY (TransactionNumber, EmployeeID, PayDate, Amount) VALUES
(1, 1, '2023-03-31', 5000.00),
(2, 2, '2023-03-31', 3500.00),
(3, 3, '2023-03-31', 4000.00),
(4, 4, '2023-03-31', 4500.00),
(5, 5, '2023-03-31', 4200.00),
(6, 6, '2023-03-31', 3000.00),
(7, 7, '2023-03-31', 3200.00),
(8, 8, '2023-03-31', 4800.00);

INSERT INTO EMPLOYEE_MARKETING_SITE (EmployeeID, DepartmentID, ShiftStart, ShiftEnd) VALUES
(1, 1, '09:00:00', '17:00:00'),
(2, 2, '10:00:00', '18:00:00'),
(3, 3, '08:00:00', '16:00:00'),
(4, 4, '09:00:00', '17:00:00'),
(5, 5, '08:30:00', '16:30:00');

INSERT INTO APPLIED_FOR (ApplicantID, JobID, ApplicationDate) VALUES
(1, 11111, '2011-01-20'),
(1, 22222, '2011-01-25'),
(1, 33333, '2011-02-20');

INSERT INTO PARTICIPATES_IN (InterviewID, ApplicantID, InterviewerID) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5);

INSERT INTO INTERVIEWED_FOR (InterviewID, JobID, InterviewerID) VALUES
(1, 11111, 1),
(2, 11111, 2),
(3, 11111, 3),
(4, 11111, 4),
(5, 11111, 5);

INSERT INTO SOLD_AT (ProductID, SiteID, SaleTime, SalespersonID, CustomerID) VALUES
(1, 1, '10:30:00', 1, 1),
(2, 2, '14:45:00', 2, 2),
(3, 3, '09:15:00', 1, 3),
(4, 4, '16:20:00', 2, 1),
(5, 5, '11:00:00', 1, 2);

INSERT INTO USES (ProductID, PartID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5);

INSERT INTO SUPPLIES (VendorID, PartID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(1, 6);