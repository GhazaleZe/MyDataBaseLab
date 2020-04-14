
-- /create required tables
CREATE TABLE Departments
(
Name varchar(20) NOT NULL ,
ID char(5) PRIMARY KEY,
Budget numeric(12,2),
Category varchar(15) Check (Category in
('Engineering','Science'))
);

--  ************************************************
CREATE TABLE Teachers
(
FirstName varchar(20) NOT NULL,
LastName varchar(30) NOT NULL ,
ID char(7),
BirthYear int,
DepartmentID char(5),
Salary numeric(7,2) Default 10000.00,
PRIMARY KEY (ID),
FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
);

-- **********************************************

CREATE TABLE Students
(
FirstName varchar(20) NOT NULL,
LastName varchar(30) NOT NULL ,
StudentNumber char(7) PRIMARY KEY,
BirthYear int,
DepartmentID char(5),
AdvisorID char(7),
FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
FOREIGN KEY (AdvisorID) REFERENCES Teachers(ID)
);
-- /q1 part1 ################################################:

ALTER TABLE Students
    ADD PassedCredit int;
SELECT * from Students;

-- /q1 part2 ###############################################:
CREATE TABLE Courses
(
    ID CHAR(7) PRIMARY KEY,
    Title VARCHAR(30),
    Credits int,
    DepartmentID CHAR(5),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(ID)
);
-- ***************************************************
CREATE TABLE Available_Courses
(
    CourseID CHAR(7) PRIMARY KEY,
    Semester VARCHAR(10) check (Semester in ('fall' ,'spring')),
    Year int,
    TeacherID CHAR(7),
    FOREIGN key (TeacherID) REFERENCES Teachers(ID)
);

SELECT * from Available_Courses;

-- ******************************************************

CREATE TABLE Taken_Courses
(
    StudentID  CHAR(7),
    CourseID CHAR(7),
    Semester VARCHAR(10),
    Year int,
    Grade int,
    PRIMARY KEY (StudentID,CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentNumber),
    FOREIGN KEY (CourseID) REFERENCES Courses(ID)
);

DROP TABLE Taken_Courses;
-- ****************************************************

CREATE TABLE Prerequisites
(
    CourseId CHAR(7),
    PrereqID CHAR(7),
    PRIMARY KEY (CourseID,PrereqID),
    FOREIGN KEY (CourseID) REFERENCES  Courses(ID)
);

-- q2 part1 #############################################

INSERT INTO Students (FirstName , LastName, StudentNumber,BirthYear, DepartmentID,AdvisorID,PassedCredit)
VALUES ('gh','ze','123',1377,NULL, NULL ,108);

INSERT INTO Students (FirstName , LastName, StudentNumber,BirthYear, DepartmentID,AdvisorID,PassedCredit)
VALUES ('someone','someone','1111111',1370,NULL, NULL ,100);

INSERT INTO Students (FirstName , LastName, StudentNumber,BirthYear, DepartmentID,AdvisorID,PassedCredit)
VALUES ('somebody','somebody','222222',1379,NULL, NULL ,50);

INSERT INTO Students (FirstName , LastName, StudentNumber,BirthYear, DepartmentID,AdvisorID,PassedCredit)
VALUES ('notme','notme','1234',1379,NULL, NULL ,53);

INSERT INTO Students (FirstName , LastName, StudentNumber,BirthYear, DepartmentID,AdvisorID,PassedCredit)
VALUES ('yeki','oonyeki','3333',1379,NULL, NULL ,53);

SELECT * FROM Departments;

INSERT INTO Departments (Name, ID ,Budget,Category ) VALUES ('Comp-sci','12345',100000000.00,'Engineering');
INSERT INTO Departments (Name, ID ,Budget,Category ) VALUES ('Mechanics','11111',100000000.00,'Engineering');
INSERT INTO Departments (Name, ID ,Budget,Category ) VALUES ('Math','22222',100000000.00,'Science');
INSERT INTO Departments (Name, ID ,Budget,Category ) VALUES ('Physics','33333',100000000.00,'Science');


UPDATE Students
SET DepartmentID = '12345'
WHERE StudentNumber='123';

SELECT * from Students;

SELECT Departments.Name,Departments.ID,Departments.Budget,Departments.Category
FROM Departments INNER JOIN Students ON (Students.DepartmentID= Departments.ID);

SELECT * FROM Courses;

INSERT INTO Courses (ID,Title,Credits,DepartmentID) VALUES ('1','BP',4,'12345');
INSERT INTO Courses (ID,Title,Credits,DepartmentID) VALUES ('12','AP',4,'12345');
INSERT INTO Courses (ID,Title,Credits,DepartmentID) VALUES ('13','DB',3,'12345');
INSERT INTO Courses (ID,Title,Credits,DepartmentID) VALUES ('14','Dis_MAth',3,'12345');
INSERT INTO Courses (ID,Title,Credits,DepartmentID) VALUES ('20','Statics',3,'22222');

SELECT * FROM Taken_Courses;

INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('3333',NULL,NULL,NULL,NULL);

INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('123','1','fall',2017,18);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('123','12','spring',2018,15);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('123','13','spring',2020,19);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('123','14','fall',2019,10);

INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('1234','1','fall',2017,19);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('1234','12','spring',2018,13);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('1234','14','fall',2019,16);


INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('1111111','1','fall',2012,15);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('1111111','12','spring',2018,11);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('1111111','20','spring',2018,20);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,[Year],Grade)
VALUES('1111111','14','fall',2013,17);

-- /q2 part2 #############################################

SELECT StudentID,CourseID,Semester,[Year],Grade+1 FROM Taken_Courses WHERE Grade < 20;

-- /q2 part3 ##################################################

SELECT  distinct FirstName,LastName, StudentNumber FROM Students LEFT  JOIN Taken_Courses
 ON (Students.StudentNumber=Taken_Courses.StudentID )
 WHERE ( StudentNumber <> (SELECT  StudentID FROM Taken_Courses WHERE CourseID = '13'));
