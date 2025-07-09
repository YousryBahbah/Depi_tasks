
CREATE SCHEMA stdschema;
GO

CREATE TABLE stdschema.DEPARTMENT (
    DNum INT PRIMARY KEY,
    DName VARCHAR(50) NOT NULL UNIQUE,
    Location NVARCHAR(100) NOT NULL,
    ManagerSSN CHAR(9)
);

CREATE TABLE stdschema.EMPLOYEE (
    SSN CHAR(9) PRIMARY KEY,
    FName VARCHAR(50) NOT NULL,
    LName VARCHAR(50) NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    BirthDate DATE NOT NULL,
    DNum INT NOT NULL,
    SuperSSN CHAR(9),
    Email VARCHAR(100) UNIQUE,
    FOREIGN KEY (DNum) REFERENCES stdschema.DEPARTMENT(DNum) ON UPDATE CASCADE,
    FOREIGN KEY (SuperSSN) REFERENCES stdschema.EMPLOYEE(SSN) ON DELETE SET NULL
);

ALTER TABLE stdschema.DEPARTMENT
ADD CONSTRAINT FK_Department_ManagerSSN FOREIGN KEY (ManagerSSN)
REFERENCES stdschema.EMPLOYEE(SSN) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE stdschema.PROJECT (
    PNum INT PRIMARY KEY,
    PName VARCHAR(50) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL,
    DNum INT NOT NULL,
    FOREIGN KEY (DNum) REFERENCES stdschema.DEPARTMENT(DNum) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE stdschema.DEPENDENT (
    DependentID INT IDENTITY(1,1) PRIMARY KEY,
    DepName VARCHAR(50) NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    BirthDate DATE NOT NULL,
    SSN CHAR(9) NOT NULL,
    CONSTRAINT UQ_Dependent UNIQUE (SSN, DepName),
    FOREIGN KEY (SSN) REFERENCES stdschema.EMPLOYEE(SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE stdschema.EMP_PROJECT (
    SSN CHAR(9),
    PNum INT,
    Working_Hours INT NOT NULL CHECK (Working_Hours > 0),
    PRIMARY KEY (SSN, PNum),
    FOREIGN KEY (SSN) REFERENCES stdschema.EMPLOYEE(SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PNum) REFERENCES stdschema.PROJECT(PNum) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE stdschema.MANAGER_HIREDATE (
    DNum INT,
    SSN CHAR(9),
    HireDate DATE NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (DNum, SSN),
    FOREIGN KEY (DNum) REFERENCES stdschema.DEPARTMENT(DNum) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (SSN) REFERENCES stdschema.EMPLOYEE(SSN) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

INSERT INTO stdschema.DEPARTMENT (DNum, DName, Location, ManagerSSN) VALUES
(1, 'HR', 'Cairo', NULL),
(2, 'IT', 'Alexandria', NULL),
(3, 'Finance', 'Giza', NULL);

INSERT INTO stdschema.EMPLOYEE (SSN, FName, LName, Gender, BirthDate, DNum, SuperSSN, Email) VALUES
('111111111', 'Ali', 'Hassan', 'M', '1990-01-01', 1, NULL, 'ali@example.com'),
('222222222', 'Sara', 'Omar', 'F', '1992-03-15', 2, '111111111', 'sara@example.com'),
('333333333', 'John', 'Smith', 'M', '1985-07-10', 1, '111111111', 'john@example.com'),
('444444444', 'Laila', 'Kamel', 'F', '1993-09-23', 3, '222222222', 'laila@example.com'),
('555555555', 'Hussein', 'Ali', 'M', '1988-12-12', 2, '111111111', 'hussein@example.com');

UPDATE stdschema.DEPARTMENT SET ManagerSSN = '111111111' WHERE DNum = 1;
UPDATE stdschema.DEPARTMENT SET ManagerSSN = '222222222' WHERE DNum = 2;
UPDATE stdschema.DEPARTMENT SET ManagerSSN = '444444444' WHERE DNum = 3;

INSERT INTO stdschema.PROJECT (PNum, PName, City, DNum) VALUES
(1001, 'Payroll System', 'Cairo', 1),
(1002, 'E-Commerce', 'Alexandria', 2),
(1003, 'Finance Tracker', 'Giza', 3);

INSERT INTO stdschema.EMP_PROJECT (SSN, PNum, Working_Hours) VALUES
('111111111', 1001, 20),
('222222222', 1002, 30),
('333333333', 1001, 25),
('444444444', 1003, 35),
('555555555', 1002, 15);

INSERT INTO stdschema.DEPENDENT (DepName, Gender, BirthDate, SSN) VALUES
('Mona', 'F', '2010-05-12', '111111111'),
('Yousef', 'M', '2008-08-08', '222222222'),
('Ahmed', 'M', '2015-01-20', '111111111');

INSERT INTO stdschema.MANAGER_HIREDATE (DNum, SSN, HireDate) VALUES
(1, '111111111', '2015-01-10'),
(2, '222222222', '2016-03-01'),
(3, '444444444', '2018-06-12');
