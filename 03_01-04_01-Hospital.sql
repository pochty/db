--CREATE DATABASE hospital;
--GO;
--USE hospital;

CREATE TABLE Person (
	PersonId INT IDENTITY(1,1),
	FirstName NVARCHAR(255),
	MiddleName NVARCHAR(255),
	LastName NVARCHAR(255) NOT NULL,
	BirthDate DATE NOT NULL,
	PRIMARY KEY (PersonId),
);

CREATE TABLE Email (
	EmailId INT IDENTITY(1,1),
	PersonId INT,
	Email NVARCHAR(255),
	PRIMARY KEY (EmailId),
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
		ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE Phone (
	PhoneId INT IDENTITY(1,1),
	PersonId INT,
	Phone NVARCHAR(255),
	PRIMARY KEY (PhoneId),
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
		ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE Position (
	PositionId INT IDENTITY(1,1),
	Title NVARCHAR(500) NOT NULL,
	Wage SMALLMONEY DEFAULT 0,
	PRIMARY KEY (PositionId)
);

CREATE TABLE Employee (
	EmployeeId INT IDENTITY(1,1),
	PersonId INT,
	PositionId INT,
	PRIMARY KEY (EmployeeId),
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (PositionId) REFERENCES Position(PositionId)
);

CREATE TABLE Department (
	DepartmentId INT IDENTITY(1,1),
	Title NVARCHAR(500),
	PRIMARY KEY (DepartmentId)
);

CREATE TABLE EmployeeDepartment (
	EmployeeDepartmentId INT IDENTITY(1,1),
	DepartmentId INT,
	EmployeeId INT,
	PRIMARY KEY (EmployeeDepartmentId),
	FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);

CREATE TABLE Patient (
	PatientId INT IDENTITY(1,1),
	PersonId INT,
	PRIMARY KEY (PatientId),
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
		ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE Disease (
	DiseaseId INT IDENTITY(1,1),
	Class NVARCHAR(500) NOT NULL,
	Details NVARCHAR(2000),
	PRIMARY KEY (DiseaseId)
);

CREATE TABLE MedicalCase (
	MedicalCaseId INT IDENTITY(1,1),
	PatientId INT,
	DiseaseId INT,
	EmployeeId INT,
	MedicalCaseDate DATE DEFAULT GETDATE(),
	Details NVARCHAR(2000),
	Treatment NVARCHAR(2000),
	PRIMARY KEY (MedicalCaseId),
	FOREIGN KEY (PatientId) REFERENCES Patient(PatientId),
	FOREIGN KEY (DiseaseId) REFERENCES Disease(DiseaseId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId),
);


CREATE TABLE PatientDepartment (
	PatientDepartmentId INT IDENTITY(1,1),
	DepartmentId INT,
	PatientId INT,
	BeginDate DATE DEFAULT GETDATE(),
	EndDate DATE DEFAULT GETDATE(),
	PRIMARY KEY (PatientDepartmentId),
	FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId),
	FOREIGN KEY (PatientId) REFERENCES Patient(PatientId)
);

INSERT INTO Person (FirstName, MiddleName, LastName, BirthDate)
VALUES ('FirstName1', 'MiddleName1', 'LastName1', '1991-1-1'),
		('FirstName2', 'MiddleName2', 'LastName2', '1992-1-1'),
		('FirstName3', 'MiddleName3', 'LastName3', '1993-1-1'),
		('FirstName4', 'MiddleName4', 'LastName4', '1994-1-1'),
		('FirstName5', 'MiddleName5', 'LastName5', '1995-1-1'),
		('FirstName6', 'MiddleName6', 'LastName6', '1996-1-1'),
		('FirstName7', 'MiddleName7', 'LastName7', '1997-1-1'),
		('FirstName8', 'MiddleName8', 'LastName8', '1994-1-1');

INSERT INTO Phone (PersonId, Phone)
VALUES (1, '01'),
		(2, '02'),
		(3, '03'),
		(4, '04'),
		(5, '01');

INSERT INTO Email (PersonId, Email)
VALUES (1, 'email1@email.com'),
		(2, 'email2@email.com'),
		(3, 'email3@email.com'),
		(4, 'email4@email.com'),
		(5, 'email5@email.com');

INSERT INTO Department (Title)
VALUES ('Department1'), ('Department2'), ('Department3');

INSERT INTO Position (Title)
VALUES ('Position1'), ('Position2'), ('Position3');

INSERT INTO Employee (PersonId, PositionId)
VALUES (6, 1), (7, 2), (8, 3);

INSERT INTO EmployeeDepartment (DepartmentId, EmployeeId)
VALUES (1, 2), (2, 3), (3, 4);

INSERT INTO Patient (PersonId)
VALUES (1), (2), (3), (4), (5), (6);

INSERT INTO Disease (Class, Details)
VALUES ('Disease1','Class1'), ('Disease2','Class2'), ('Disease3','Class3');

INSERT INTO	MedicalCase (PatientId, DiseaseId, EmployeeId, MedicalCaseDate, Details, Treatment)
VALUES (1, 1, 2, '2019-12-1', 'MedicalCase1', 'Treatment1'),
		(2, 2, 3, '2019-12-2', 'MedicalCase2', 'Treatment2'),
		(3, 3, 4, '2019-12-3', 'MedicalCase3', 'Treatment3'),
		(4, 1, 2, '2019-12-4', 'MedicalCase4', 'Treatment4'),
		(5, 1, 2, '2019-12-5', 'MedicalCase5', 'Treatment5'),
		(6, 3, 4, '2019-12-6', 'MedicalCase6', 'Treatment6');

INSERT INTO PatientDepartment (DepartmentId, PatientId, BeginDate, EndDate)
VALUES (1, 1, '2019-12-1', '2019-12-22'),
		(1, 4, '2019-12-4', '2019-12-26'),
		(1, 5, '2019-12-5', '2019-12-27'),
		(2, 2, '2019-12-2', '2019-12-23'),
		(3, 3, '2019-12-3', '2019-12-25'),
		(3, 6, '2019-12-6', '2019-12-28');

--CREATE VIEW PersonView AS
--SELECT p.PersonId, p.FirstName, p.MiddleName, p.LastName, p.BirthDate, pp.Phone, pe.Email
--FROM Person AS p LEFT JOIN
--	Email AS pe ON p.PersonId = pe.PersonId LEFT JOIN
--	Phone AS pp ON p.PersonId = pp.PersonId;

--CREATE VIEW EmployeeView AS
--SELECT e.EmployeeId, pv.FirstName, pv.MiddleName, pv.LastName, pv.BirthDate, pv.Phone, pv.Email,
--		p.Title AS Position, d.Title AS Department
--FROM Employee AS e LEFT JOIN
--	PersonView AS pv ON e.PersonId = pv.PersonId LEFT JOIN
--	Position AS p ON e.PositionId = p.PositionId LEFT JOIN
--	EmployeeDepartment AS ed ON e.EmployeeId = ed.EmployeeId LEFT JOIN
--	Department AS d ON ed.DepartmentId = d.DepartmentId;

CREATE OR ALTER VIEW PatientView AS
SELECT p.PatientId, pv.FirstName, pv.MiddleName, pv.LastName, pv.BirthDate, pv.Phone, pv.Email,
	d.Title AS Department, d.DepartmentId, pd.BeginDate, pd.EndDate
FROM Patient AS p LEFT JOIN
	PersonView AS pv ON pv.PersonId = p.PersonId LEFT JOIN
	PatientDepartment AS pd ON pd.PatientId = p.PatientId LEFT JOIN
	Department AS d ON d.DepartmentId = pd.DepartmentId;

--1. Patients in hospital
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email, 
		Department, BeginDate, EndDate
FROM PatientView
WHERE Department IS NOT NULL;

--2. Patients in department
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email, 
		Department, BeginDate, EndDate
FROM PatientView
WHERE DepartmentId = 1;

--3. Patients with more than 10 days treatment
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email, 
		Department, BeginDate, EndDate
FROM PatientView
WHERE DATEDIFF(DAYOFYEAR, BeginDate, EndDate) > 10
ORDER BY BeginDate;

--4. Patients discharged last month
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email, 
		Department, BeginDate, EndDate
FROM PatientView
WHERE DATEPART(MONTH, EndDate) = DATEPART(MONTH, DATEADD(MONTH, -1, GETDATE()));

--5. Patients within period in department
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email, 
		Department, BeginDate, EndDate
FROM PatientView
WHERE DepartmentId = 1 AND EndDate BETWEEN '2019-12-01' AND '2019-12-23';

--6. Patients with same disease and doctor
SELECT pv.FirstName +' '+ pv.MiddleName +' '+ pv.LastName AS Patient, pv.BirthDate, pv.Phone, pv.Email, 
		ev.FirstName +' '+ ev.MiddleName +' '+ ev.LastName AS Doctor, d.Class AS Disease
FROM MedicalCase AS mc 
	INNER JOIN PatientView AS pv ON pv.PatientId = mc.PatientId 
	INNER JOIN EmployeeView AS ev ON ev.EmployeeId = mc.EmployeeId 
	INNER JOIN Disease AS d ON d.DiseaseId = mc.DiseaseId
WHERE d.DiseaseId = 1 AND ev.EmployeeId = 2;

--7. All departments
SELECT Title
FROM Department;

--8. Youngest patient
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, 
	BirthDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age, Phone, Email
FROM PatientView
WHERE BirthDate = (SELECT MIN(BirthDate) FROM Person);

--9. Patients in 2 departments
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email, 
		Department, BeginDate, EndDate
FROM PatientView
WHERE DepartmentId IN (1,2);

--10. Patient's last name begins and ends with letter
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email, 
		Department, BeginDate, EndDate
FROM PatientView
WHERE LastName LIKE 'L%1' OR LastName LIKE 'L%2';

--11. Patients with the same mobile operator
SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email, 
		Department, BeginDate, EndDate
FROM PatientView
WHERE Phone LIKE '01%';

--12. Rename department
UPDATE Department
SET Title = 'Department3'
WHERE DepartmentId = 3;

--13. Delete discharged patients
DELETE FROM Patient
WHERE PatientId IN (
	SELECT PatientId
	FROM PatientDepartment
	WHERE EndDate < DATEADD(MONTH, -6, GETDATE()));

--UPDATE PatientDepartment
--SET EndDate = '2019-12-12'
--WHERE PatientId = 4;

--SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email,
--		Position, Department
--FROM EmployeeView;

--SELECT FirstName +' '+ MiddleName +' '+ LastName AS FullName, BirthDate, Phone, Email
--FROM PersonView;
