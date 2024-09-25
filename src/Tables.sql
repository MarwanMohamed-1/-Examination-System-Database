create database ExaminationSystemDatabase
use ExaminationSystemDatabase

create table Course (
    CourseID int identity(1,1) primary key,
    CourseName varchar(255),
    Description TEXT,
    MaxDegree int,
    MinDegree int
);




create table Instructor (
    InstructorID int identity(1,1) primary key,
    FirstName varchar(255),
    LastName varchar(255),
    Email varchar(255),
    IsTrainingManager BIT,
	UserID int,
	foreign key (UserID) references Users(UserID)
);

create table Student (
    StudentID int identity(1,1) primary key,
    FirstName varchar(255),
    LastName varchar(255),
    Email varchar(255),
    intakeID int,
    BranchID int,
    TrackID int,
	UserID int,
	foreign key (UserID) references Users(UserID),
    foreign key (intakeID) references intake(intakeID),
    foreign key (BranchID) references Branch(BranchID),
    foreign key (TrackID) references Track(TrackID)
);

create table Branch (
    BranchID int identity(1,1) primary key,
    BranchName varchar(255)
);

create table Track (
    TrackID int identity(1,1) primary key,
    TrackName varchar(255),
    DepartmentID int,
    foreign key (DepartmentID) references Department(DepartmentID)
);

create table Department (
    DepartmentID int identity(1,1) primary key,
    DepartmentName varchar(255),
	BranchID int,
	foreign key (BranchID) references Branch(BranchID)
);

 
create table InstructorCourses (
    InstructorCourseID int identity(1,1) primary key,
    InstructorID int,
    CourseID int,
    Year int,
    foreign key (InstructorID) references Instructor(InstructorID),
    foreign key (CourseID) references Course(CourseID)
);

create table intake (
    intakeID int identity(1,1) primary key,
    intakeName varchar(255),
    Year int
);

create table QuestionPool (
    QuestionPoolID int identity(1,1) primary key,
    CourseID int,
    QuestionText TEXT,
    QuestionType varchar(50),
    foreign key (CourseID) references Course(CourseID)
);

create table MultipleChoiceOption (
    OptionID int identity(1,1) primary key,
    OptionText TEXT,
    IsCorrect BIT,
    QuestionID int,
    foreign key (QuestionID) references QuestionPool(QuestionPoolID)
);

create table TrueFalseQuestion (
    TFID int identity(1,1) primary key,
    CorrectAnswer BIT,
	QuestionID INT
    foreign key (QuestionID) references QuestionPool(QuestionPoolID)
);

create table TextQuestion (
    TextID int identity(1,1) primary key,
    BestAnswer TEXT,
	QuestionID INT
    foreign key (QuestionID) references QuestionPool(QuestionPoolID)
);

drop table TextQuestion
create table Exam (
    ExamID int identity(1,1) primary key,
    CourseID int,
    InstructorID int,
    ExamType varchar(50),
    intakeID int,
    BranchID int,
    TrackID int,
    StartTime DATETIME,
    EndTime DATETIME,
    TotalTime int,
    Allowances TEXT,
    foreign key (CourseID) references Course(CourseID),
    foreign key (InstructorID) references Instructor(InstructorID),
    foreign key (intakeID) references intake(intakeID),
    foreign key (BranchID) references Branch(BranchID),
    foreign key (TrackID) references Track(TrackID)
);

create table ExamQuestion (
    ExamQuestionID  int identity(1,1) primary key,
    ExamID int,
    QuestionID int,
    Degree int,
    foreign key (ExamID) references Exam(ExamID),
    foreign key (QuestionID) references QuestionPool(QuestionPoolID)
);

create table StudentAnswer (
    AnswerID int identity(1,1) primary key,
    ExamID int,
    QuestionID int,
    StudentID int,
    StudentAnswer Nvarchar(500),
    IsCorrect BIT,
    Marks int,
    foreign key (ExamID) references Exam(ExamID),
    foreign key (QuestionID) references QuestionPool(QuestionPoolID),
    foreign key (StudentID) references Student(StudentID)
);

create table StudentCourses (
    StudentCourseID  int identity(1,1) primary key,
    StudentID int,
    CourseID int,
    EnrollmentDate DATETIME,
    foreign key (StudentID) references Student(StudentID),
    foreign key (CourseID) references Course(CourseID)
);

create table StudentExams (
    StudentExamID int identity(1,1) primary key,
    StudentID int,
    ExamID int,
    ExamDate DATETIME,
    Score int,
    foreign key (StudentID) references Student(StudentID),
    foreign key (ExamID) references Exam(ExamID)
);


create table Users (
    UserID int identity(1,1) primary key,
    Username varchar(255),
    passwordHash varchar(255),
    role varchar(50)
);

use ExaminationSystemDatabase

create role Admin;
create role TrainingManager;
create role Instructor;
create role Student;

grant select, insert, update, delete on SCHEMA::dbo TO Admin;

grant select, insert, update, delete on Course TO TrainingManager;
grant select, insert, update, delete on Instructor TO TrainingManager;
grant select, insert, update, delete on Branch TO TrainingManager;
grant select, insert, update, delete on Track TO TrainingManager;
grant select, insert, update, delete on intake TO TrainingManager;
grant select, insert, update, delete on Exam TO TrainingManager;
grant select, insert, update, delete on InstructorCourses TO TrainingManager;
grant select, insert, update, delete on [dbo].[MultipleChoiceOption]  TO TrainingManager;
grant select, insert, update, delete on  [dbo].[Student]  TO TrainingManager;
grant select, insert, update, delete on  [dbo].[TrueFalseQuestion]  TO TrainingManager;
grant select, insert, update, delete on  [dbo].[TextQuestion]  TO TrainingManager;
grant select, insert, update, delete on  [dbo].[StudentExams]  TO TrainingManager;




grant select, insert, update, delete on QuestionPool TO Instructor;
grant select, insert, update, delete on Exam TO Instructor;
grant select on StudentCourses TO Instructor;
grant select on StudentAnswer TO Instructor;

grant select on Exam TO Student;
grant insert, update on StudentAnswer TO Student;
grant select on StudentExams TO Student;

/* 3. create User Accounts and Assign roles */

create login admin_account WITH password = 'Admin123!';
create USER admin_account FOR login admin_account;
ALTER role Admin add member admin_account;

create login training_manager_account WITH password = 'TrainingManager123!';
create USER training_manager_account FOR login training_manager_account;
ALTER role TrainingManager add member training_manager_account;

create login instructor_account WITH password = 'Instructor123!';
create USER instructor_account FOR login instructor_account;
ALTER role Instructor add member instructor_account;


create login student_account WITH password = 'Student123!';
create USER student_account FOR login student_account;
ALTER role Student add member student_account;


