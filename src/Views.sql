
use ExaminationSystemDatabase

create view InstructorCoursesView AS
select 
    i.InstructorID,
    i.FirstName,
    i.LastName,
    c.CourseID,
    c.CourseName,
    ic.Year
from 
    Instructor i
JOIN 
    InstructorCourses ic on i.InstructorID = ic.InstructorID
JOIN 
    Course c on ic.CourseID = c.CourseID;

select * from InstructorCoursesView

create view StudentCoursesView AS
select 
    s.StudentID,
    s.FirstName,
    s.LastName,
    c.CourseID,
    c.CourseName,
    sc.EnrollmentDate
from 
    Student s
JOIN 
    StudentCourses sc on s.StudentID = sc.StudentID
JOIN 
    Course c on sc.CourseID = c.CourseID;

	select * from StudentCoursesView

create view ExamResultsView AS
select 
    se.StudentID,
    s.FirstName,
    s.LastName,
    e.ExamID,
    se.Score
from 
    StudentExams se
JOIN 
    Student s on se.StudentID = s.StudentID
JOIN 
    Exam e on se.ExamID = e.ExamID;

		select * from ExamResultsView


create view StudentExamsView AS
select
	ExamID, Count (StudentID) as StudentNum
	from [dbo].[StudentExams]
	group by ExamID

	select * from StudentExamsView

create view CourseDetailsView AS
select 
    c.CourseID,
    c.CourseName,
    c.Description,
    i.InstructorID,
    i.FirstName AS InstructorFirstName,
    i.LastName AS InstructorLastName,
    sc.StudentID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName
from 
    Course c
LEFT JOIN 
    InstructorCourses ic on c.CourseID = ic.CourseID
LEFT JOIN 
    Instructor i on ic.InstructorID = i.InstructorID
LEFT JOIN 
    StudentCourses sc on c.CourseID = sc.CourseID
LEFT JOIN 
    Student s on sc.StudentID = s.StudentID;

			select * from CourseDetailsView

create view QuestionPoolView AS
select 
    qp.QuestionPoolID,
    qp.CourseID,
    c.CourseName,
    qp.QuestionText,
    qp.QuestionType
from 
    QuestionPool qp
JOIN 
    Course c on qp.CourseID = c.CourseID;

				select * from QuestionPoolView


create view StudentExamDetailsview AS
select 
    se.StudentID,
    s.FirstName,
    s.LastName,
    e.ExamID,
    sa.QuestionID,
    qp.QuestionText,
    sa.StudentAnswer,
    sa.IsCorrect,
    sa.Marks
from 
    StudentExams se
JOIN 
    Student s on se.StudentID = s.StudentID
JOIN 
    Exam e on se.ExamID = e.ExamID
JOIN 
    StudentAnswer sa on se.ExamID = sa.ExamID AND se.StudentID = sa.StudentID
JOIN 
    QuestionPool qp on sa.QuestionID = qp.QuestionPoolID;

					select * from StudentExamDetailsview

create view CourseView AS
select 
    CourseID,
    CourseName,
    Description,
    MaxDegree,
    MinDegree
from 
    Course;

						select * from CourseView

create view InstructorView AS
select 
    InstructorID,
    FirstName,
    LastName,
    Email,
    IsTrainingManager,
    UserID
from 
    Instructor;

							select * from InstructorView

create view StudentView AS
select 
    StudentID,
    FirstName,
    LastName,
    Email,
    IntakeID,
    BranchID,
    TrackID,
    UserID
from 
    Student;
								select * from StudentView



create view BranchView AS
select 
    BranchID,
    BranchName
from 
    Branch;


create view TrackView AS
select 
    TrackID,
    TrackName,
    DepartmentID
from 
    Track;


create view DepartmentView AS
select 
    DepartmentID,
    DepartmentName,
    BranchID
from 
    Department;


create view IntakeView AS
select 
    IntakeID,
    IntakeName,
    Year
from 
    Intake;


create view MultipleChoiceOptionView AS
select 
    OptionID,
    QuestionID,
    OptionText,
    IsCorrect
from 
    MultipleChoiceOption;


									select * from MultipleChoiceOptionView

create view ExamView AS
select 
    ExamID,
    CourseID,
    InstructorID,
    ExamType,
    IntakeID,
    BranchID,
	TrackID,
	StartTime,
	EndTime,
	TotalTime,
	Allowances
from 
    Exam;

										select * from ExamView


create view StudentAnswerView AS
select 
    AnswerID,
    ExamID,
    QuestionID,
    StudentID,
    StudentAnswer,
    IsCorrect,
    Marks
from 
    StudentAnswer;

											select * from StudentAnswerView



create view UsersView AS
select 
    UserID,
    Username,
    PasswordHash,
    Role
from 
    Users;


	select * from UsersView