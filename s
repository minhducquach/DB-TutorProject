
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    Email VARCHAR(50),
    PhoneNumber VARCHAR(20),
    Gender CHAR(1),
    YearOfBirth INT,
    Street VARCHAR(50),
    City VARCHAR(50),
    Province VARCHAR(50),
    Age AS (YEAR(GETDATE()) - YearOfBirth)
);

CREATE TABLE Subjects (
    SubjectID INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName VARCHAR(100),
);

CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName VARCHAR(50),
    Description VARCHAR(200),
    Capacity INT,
    SubjectID INT,
    MinNumOfStudents INT,
    CONSTRAINT FK_Course_Subject FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Accounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50),
    AccessLevel VARCHAR(20),
    Password VARCHAR(20),
    Role CHAR(1),
    UserID INT,
    CONSTRAINT FK_Accounts_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Class VARCHAR(2), -- using '00' for students who don't declare CLASS
    SubjectWantToLearnID INT,
    CONSTRAINT FK_Students_Users FOREIGN KEY (StudentID) REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Student_Subject FOREIGN KEY (SubjectWantToLearnID) REFERENCES Subjects(SubjectID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Tests (
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    MinTest FLOAT,
    MidtermExam FLOAT,
    FinalExam FLOAT,
    CourseID INT,
    StudentID INT,
    CONSTRAINT FK_Tests_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Tests_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE StudyCourses (
    StudentID INT,
    CourseID INT,
    PRIMARY KEY (StudentID, CourseID),
    CONSTRAINT FK_StudyCourses_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_StudyCourses_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Schedules (
    CourseID INT,
    ScheduleDate DATE,
    ScheduleTime TIME,
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    CONSTRAINT FK_Schedules_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Tutors (
    TutorID INT PRIMARY KEY,
    SubjectWantToTeachID INT,
    CONSTRAINT FK_Tutors_Users FOREIGN KEY (TutorID) REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Tutors_Subject FOREIGN KEY (SubjectWantToTeachID) REFERENCES Subjects(SubjectID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE TutorProfiles (
    TutorProfileID INT PRIMARY KEY,
    Certificate VARCHAR(50),
    SoftSkill VARCHAR(100),
    Experience VARCHAR(100),
    CONSTRAINT FK_TutorProfiles_Tutors FOREIGN KEY (TutorProfileID) REFERENCES Tutors(TutorID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE TeachesCourses (
    TutorID INT,
    CourseID INT,
    PRIMARY KEY (TutorID, CourseID),
    CONSTRAINT FK_TeachesCourses_Tutors FOREIGN KEY (TutorID) REFERENCES Tutors(TutorID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_TeachesCourses_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Ratings (
    StudentID INT,
    RatingID INT IDENTITY(1,1),
    TutorID INT,
    Score FLOAT,
    PRIMARY KEY (StudentID, RatingID),
    CONSTRAINT FK_Ratings_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Ratings_Tutors FOREIGN KEY (TutorID) REFERENCES Tutors(TutorID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create views for computed columns
GO

CREATE VIEW vw_CourseNumberOfStudents
AS
SELECT Courses.CourseID, COUNT(StudyCourses.StudentID) AS NumberOfStudents
FROM Courses
LEFT JOIN StudyCourses ON Courses.CourseID = StudyCourses.CourseID
GROUP BY Courses.CourseID;

GO

CREATE VIEW vw_TutorAverageRating
AS
SELECT Tutors.TutorID, AVG(Ratings.Score) AS AverageRating
FROM Tutors
LEFT JOIN Ratings ON Tutors.TutorID = Ratings.TutorID
GROUP BY Tutors.TutorID;

GO

CREATE VIEW vw_TutorNumberOfCourses
AS
SELECT Tutors.TutorID, COUNT(DISTINCT TeachesCourses.CourseID) AS NumberOfCourses
FROM Tutors
LEFT JOIN TeachesCourses ON Tutors.TutorID = TeachesCourses.TutorID
GROUP BY Tutors.TutorID;

GO


-- DATA SAMPLE
INSERT INTO Subjects (SubjectName)
VALUES ('Math');

INSERT INTO Subjects (SubjectName)
VALUES ('Literature');

INSERT INTO Subjects (SubjectName)
VALUES ('English');

INSERT INTO Subjects (SubjectName)
VALUES ('Database Systems');

INSERT INTO Subjects (SubjectName)
VALUES ('Operating Systems');

INSERT INTO Subjects (SubjectName)
VALUES ('Artificial Intelligence');

-- Data for Student 1 --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Nguyen Van A', 'nguyenvana@email.com', '0912345678', 'M', 2000, '123 Nguyen Van Cu, Quan 5', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('nguyenvana', 'Student', 'password1', 'S', 1);

INSERT INTO Students (StudentID, Class, SubjectWantToLearnID)
VALUES (1, '12', 1);

-- Data for Tutor 2 (Math) --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Tran Minh D', 'tranminhd@email.com', '0987654322', 'M', 1990, '456 Le Duan, Quan 1', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Tutors (TutorID, SubjectWantToTeachID)
VALUES (2, 1);

INSERT INTO TutorProfiles (TutorProfileID, Certificate, SoftSkill, Experience)
VALUES (2, 'Math Teacher Certificate', 'Communication, Problem-solving', '5 years teaching experience');

INSERT INTO Courses (CourseName, Description, Capacity, SubjectID, MinNumOfStudents)
VALUES ('Math for High School', 'Math course for high school students', 30, 1, 10);

INSERT INTO TeachesCourses (TutorID, CourseID)
VALUES (2, 1);

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('tranminhd', 'Tutor', 'tutorpass1', 'T', 2);

INSERT INTO Schedules (CourseID, ScheduleDate, ScheduleTime)
VALUES (1, '2023-06-01', '09:00:00');

-- Student 1 takes the Math course and leaves a rating for Tutor 2
INSERT INTO StudyCourses (StudentID, CourseID)
VALUES (1, 1);

INSERT INTO Tests (MinTest, MidtermExam, FinalExam, CourseID, StudentID)
VALUES (7.5, 8.0, 9.0, 1, 1);

INSERT INTO Ratings (StudentID, TutorID, Score)
VALUES (1, 2, 4.5);

-- Data for Student 3 --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Tran Thi B', 'tranthib@email.com', '0987654321', 'F', 2001, '456 Tran Hung Dao, Quan 1', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('tranthib', 'Student', 'password2', 'S', 3);

INSERT INTO Students (StudentID, Class, SubjectWantToLearnID)
VALUES (3, '11', 1);

-- Student 3 takes the Math course and leaves a rating for Tutor 2
INSERT INTO StudyCourses (StudentID, CourseID)
VALUES (3, 1);

INSERT INTO Tests (MinTest, MidtermExam, FinalExam, CourseID, StudentID)
VALUES (6.0, 7.5, 8.5, 1, 3);

INSERT INTO Ratings (StudentID, TutorID, Score)
VALUES (3, 2, 3.8);

-- Data for Student 4 --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Le Van C', 'levanc@email.com', '0912345679', 'M', 2002, '789 Pham Ngu Lao, Quan 1', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('levanc', 'Student', 'password3', 'S', 4);

INSERT INTO Students (StudentID, Class, SubjectWantToLearnID)
VALUES (4, '10', 1);

-- Student 4 takes the Math course and leaves a rating for Tutor 2
INSERT INTO StudyCourses (StudentID, CourseID)
VALUES (4, 1);

INSERT INTO Tests (MinTest, MidtermExam, FinalExam, CourseID, StudentID)
VALUES (8.0, 7.0, 9.5, 1, 3);

INSERT INTO Ratings (StudentID, TutorID, Score)
VALUES (4, 2, 4.2);

--
-- Data for Student 5 --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Nguyen Thi K', 'nguyenthik@email.com', '0987654325', 'F', 2004, '789 Tran Hung Dao, Quan 5', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('nguyenthik', 'Student', 'password9', 'S', 5);

INSERT INTO Students (StudentID, Class, SubjectWantToLearnID)
VALUES (5, '9', 4);

-- Data for Tutor 6 (Database) --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Tran Van L', 'tranvanl@email.com', '0901234570', 'M', 1988, '456 Nguyen Trai, Quan 1', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Tutors (TutorID, SubjectWantToTeachID)
VALUES (6, 4);

INSERT INTO TutorProfiles (TutorProfileID, Certificate, SoftSkill, Experience)
VALUES (6, 'Database Administrator Certificate', 'Problem-solving, Communication', '6 years experience');

INSERT INTO Courses (CourseName, Description, Capacity, SubjectID, MinNumOfStudents)
VALUES ('Database Management Systems', 'Advanced database management course', 20, 4, 8);

INSERT INTO TeachesCourses (TutorID, CourseID)
VALUES (6, 2);

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('tranvanl', 'Tutor', 'tutorpass5', 'T', 6);

INSERT INTO Schedules (CourseID, ScheduleDate, ScheduleTime)
VALUES (2, '2023-09-20', '14:00:00');

-- Student 5 takes the Database course and leaves a rating for Tutor 6
INSERT INTO StudyCourses (StudentID, CourseID)
VALUES (5, 2);

INSERT INTO Tests (MinTest, MidtermExam, FinalExam, CourseID, StudentID)
VALUES (6.5, 7.2, 8.0, 2, 5);

INSERT INTO Ratings (StudentID, TutorID, Score)
VALUES (5, 6, 4.3);

-- Data for Tutor 7 (AI) --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Nguyen Thi M', 'nguyenthim@email.com', '0901234571', 'F', 1993, '789 Tran Binh Trong, Quan 5', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Tutors (TutorID, SubjectWantToTeachID)
VALUES (7, 5);

INSERT INTO TutorProfiles (TutorProfileID, Certificate, SoftSkill, Experience)
VALUES (7, 'AI Specialist Certificate', 'Creativity, Critical Thinking', '4 years experience');

INSERT INTO Courses (CourseName, Description, Capacity, SubjectID, MinNumOfStudents)
VALUES ('Introduction to Artificial Intelligence', 'Introductory course on AI concepts', 25, 5, 10);

INSERT INTO TeachesCourses (TutorID, CourseID)
VALUES (7, 3);

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('nguyenthim', 'Tutor', 'tutorpass6', 'T', 7);

INSERT INTO Schedules (CourseID, ScheduleDate, ScheduleTime)
VALUES (3, '2023-10-05', '18:00:00');

-- Student 5 takes the AI course and leaves a rating for Tutor 7
INSERT INTO StudyCourses (StudentID, CourseID)
VALUES (5, 3);

INSERT INTO Tests (MinTest, MidtermExam, FinalExam, CourseID, StudentID)
VALUES (7.0, 8.5, 9.2, 3, 5);

INSERT INTO Ratings (StudentID, TutorID, Score)
VALUES (5, 7, 4.6);

-- Data for Student 8 --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Tran Van N', 'tranvann@email.com', '0987654326', 'M', 2003, '456 Nguyen Hue, Quan 1', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('tranvann', 'Student', 'password12', 'S', 8);

INSERT INTO Students (StudentID, Class, SubjectWantToLearnID)
VALUES (8, '10', 6);

-- Data for Tutor 9 (Operating Systems) --
INSERT INTO Users (FullName, Email, PhoneNumber, Gender, YearOfBirth, Street, City, Province)
VALUES ('Le Thi O', 'lethio@email.com', '0901234572', 'F', 1995, '789 Nguyen Du, Quan 1', 'Ho Chi Minh', 'Ho Chi Minh');

INSERT INTO Tutors (TutorID, SubjectWantToTeachID)
VALUES (9, 6);

INSERT INTO TutorProfiles (TutorProfileID, Certificate, SoftSkill, Experience)
VALUES (9, 'Operating Systems Specialist', 'Attention to Detail, Problem-solving', '3 years experience');

INSERT INTO Courses (CourseName, Description, Capacity, SubjectID, MinNumOfStudents)
VALUES ('Operating Systems Concepts', 'Introduction to operating systems', 20, 6, 8);

INSERT INTO TeachesCourses (TutorID, CourseID)
VALUES (9, 4);

INSERT INTO Accounts (Username, AccessLevel, Password, Role, UserID)
VALUES ('lethio', 'Tutor', 'tutorpass7', 'T', 9);

INSERT INTO Schedules (CourseID, ScheduleDate, ScheduleTime)
VALUES (4, '2023-11-10', '10:00:00');

-- Student 8 takes the Operating Systems course and leaves a rating for Tutor 9
INSERT INTO StudyCourses (StudentID, CourseID)
VALUES (8, 4);

INSERT INTO Tests (MinTest, MidtermExam, FinalExam, CourseID, StudentID)
VALUES (7.8, 8.2, 9.0, 4, 8);

INSERT INTO Ratings (StudentID, TutorID, Score)
VALUES (8, 9, 4.7);