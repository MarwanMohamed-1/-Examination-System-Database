USE ExaminationSystemDatabase;

insert into Users (Username, PasswordHash, Role)
values ( 'instructor2', 'hashedpassword2', 'Instructor'),
       ( 'student2', 'hashedpassword3', 'Student'),
       ( 'trainingmanager1', 'hashedpassword3', 'TrainingManager');

insert into Department ( DepartmentName, BranchID)
values ( 'Computer Engineering', 1);

insert into Branch ( BranchName)
values ( 'second Branch');

insert into Track ( TrackName, DepartmentID)
values ( 'Software Development', 2);

insert into Intake ( IntakeName, Year)
values ( 'winter 2024', 2024);

insert into Course ( CourseName, Description, MaxDegree, MinDegree)
values ( 'C#', 'Introduction to C#', 130, 75);

insert into Instructor ( FirstName, LastName, Email, IsTrainingManager, UserID)
values ( 'Alaa', 'Ali', 'Alaa.doe@example.com', 1, 7);

insert into Student ( FirstName, LastName, Email, IntakeID, BranchID, TrackID, UserID)
values ( 'ahmed', 'hamdy', 'hamdy.smith@example.com', 3, 3, 3, 4);

insert into InstructorCourses ( InstructorID, CourseID, Year)
values ( 2, 2, 2000);

insert into QuestionPool ( CourseID, QuestionText, QuestionType)
values (2,  'What is the capital of France?', 'Text'),
       (3, 'Which of the following is a fruit?', 'MultipleChoice'),
       (3,  'Is the sky blue?', 'TrueFalse'),
	   (1,  'What is the capital of France?', 'Text'),
       (2, 'Which of the following is a fruit?', 'MultipleChoice'),
       (3,  'Is the sky blue?', 'TrueFalse');

insert into MultipleChoiceOption ( OptionText, IsCorrect, QuestionID)
values ( 'Apple', 1, 2),
       ( 'Carrot', 0, 2),
       ( 'Potato', 0, 2);

insert into TrueFalseQuestion (QuestionID, CorrectAnswer)
values (3, 1);

insert into TextQuestion (QuestionID, BestAnswer)
values (1, 'Paris');

insert into Exam (CourseID, InstructorID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, TotalTime, Allowances)
values ( 4, 4, 'Text', 2, 2, 2, '2024-07-01 10:00:00', '2024-07-01 13:00:00', 120, 'None');

insert into ExamQuestion ( ExamID, QuestionID, Degree)
values ( 1, 2, 10),
       ( 1, 3, 10),
       ( 1, 1003, 10);

insert into StudentCourses ( StudentID, CourseID, EnrollmentDate)
values ( 1, 101, '2024-01-01');

insert into StudentExams (, StudentID, ExamID, ExamDate, Score)
values ( 1, 1, '2024-07-01', NULL);


------------------------------------------------------------------------



insert into Users ( Username, PasswordHash, Role)
values ( 'instructor1', 'hashedpassword1', 'Instructor'),
       ( 'student1', 'hashedpassword2', 'Student'),
       ( 'trainingmanager', 'hashedpassword3', 'TrainingManager');

insert into Department ( DepartmentName, BranchID)
values ( 'Computer Science', 1);

insert into Branch ( BranchName)
values ( 'Main Branch');

insert into Track ( TrackName, DepartmentID)
values ('Software Engineering', 1);

insert into Intake ( IntakeName, Year)
values ( 'Spring 2024', 2024);

insert into Course ( CourseName, Description, MaxDegree, MinDegree)
values ( 'Database Systems', 'Introduction to Databases', 100, 50);

insert into Instructor ( FirstName, LastName, Email, IsTrainingManager, UserID)
values ( 'John', 'Doe', 'john.doe@example.com', 0, 2);

insert into Student (StudentID, FirstName, LastName, Email, IntakeID, BranchID, TrackID, UserID)
values (1, 'Jane', 'Smith', 'jane.smith@example.com', 1, 1, 1, 2);

insert into InstructorCourses ( InstructorID, CourseID, Year)
values ( 1, 101, 2024);

insert into QuestionPool (CourseID, QuestionText, QuestionType)
values ( 1, 'What is the capital of France?', 'Text'),
       ( 2, 'Which of the following is a fruit?', 'MultipleChoice'),
       ( 3, 'Is the sky blue?', 'TrueFalse');

insert into MultipleChoiceOption ( OptionText, IsCorrect, QuestionID)
values ( 'Apple', 1, 2),
       ( 'Carrot', 0, 2),
       ( 'Potato', 0, 2);

insert into TrueFalseQuestion (QuestionID, CorrectAnswer)
values (1004, 1);

insert into TextQuestion (QuestionID, BestAnswer)
values (1003, 'tennis');

insert into Exam ( CourseID, InstructorID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, TotalTime, Allowances)
values (1, 2, 'Final', 1, 1, 1, '2024-07-01 09:00:00', '2024-07-01 12:00:00', 180, 'None');

insert into ExamQuestion ( ExamID, QuestionID, Degree)
values ( 5, 1003, 10),
       ( 5, 2, 10),
       ( 1, 3, 10);

insert into StudentCourses ( StudentID, CourseID, EnrollmentDate)
values (6 , 5, '2024-01-01');


insert into StudentExams ( StudentID, ExamID, ExamDate, Score)
values ( 5, 5, '2024-07-01', 200);


/* We'll use the SubmitStudentAnswer procedure to submit more answers for different students.*/

exec SubmitStudentAnswer @ExamID = 5, @QuestionID = 2, @StudentID = 5, @StudentAnswer = 'Paris';
exec SubmitStudentAnswer @ExamID = 1, @QuestionID = 2, @StudentID = 1, @StudentAnswer = 'Apple';
exec SubmitStudentAnswer @ExamID = 1, @QuestionID = 3, @StudentID = 1, @StudentAnswer = 'True';

exec SubmitStudentAnswer @ExamID = 2, @QuestionID = 4, @StudentID = 2, @StudentAnswer = 'A rectangular array of numbers.';
exec SubmitStudentAnswer @ExamID = 2, @QuestionID = 5, @StudentID = 2, @StudentAnswer = '5';

exec SubmitStudentAnswer @ExamID = 3, @QuestionID = 6, @StudentID = 3, @StudentAnswer = 'True';

exec SubmitStudentAnswer @ExamID = 3, @QuestionID = 6, @StudentID = 4, @StudentAnswer = 'True';


exec CalculateFinalResult @StudentID = 5, @CourseID = 3;

exec CalculateFinalResult @StudentID = 2, @CourseID = 102;

exec CalculateFinalResult @StudentID = 3, @CourseID = 103;

exec CalculateFinalResult @StudentID = 4, @CourseID = 103;


/*check student answers*/


SELECT * FROM StudentAnswer WHERE StudentID IN (1, 2, 3, 4);

exec CalculateFinalResult @StudentID = 1, @CourseID = 101;
exec CalculateFinalResult @StudentID = 2, @CourseID = 102;
exec CalculateFinalResult @StudentID = 3, @CourseID = 103;
exec CalculateFinalResult @StudentID = 4, @CourseID = 103;
