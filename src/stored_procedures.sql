/* 1. */
use ExaminationSystemDatabase

/* check if instructor is assigned to course */

create FUNCTIon IsInstructorAssignedtoCourse (
    @InstructorID INT,
    @CourseID INT
) RETURNS BIT
AS
BEGIN
    declare @Result BIT;

    if EXISTS (select 1 from InstructorCourses where InstructorID = @InstructorID AND CourseID = @CourseID)
        SET @Result = 1;
    else
        SET @Result = 0;

    RETURN @Result;
END;
GO


/* adding question pool by instructor */

create procedure AddQuestiontoPool (
    @InstructorID INT,
    @CourseID INT,
    @QuestionText nvarchar(MAX),
    @QuestionType nvarchar(50)
)
AS
BEGIN
    -- Check if the instructor is assigned to the course
    if dbo.IsInstructorAssignedtoCourse(@InstructorID, @CourseID) = 0
    BEGIN
        RAISERROR('Instructor not assigned to the course.', 16, 1);
        RETURN;
    END

    -- Add the question to the question pool
    insert into QuestionPool (CourseID, QuestionText, QuestionType)
    values (@CourseID, @QuestionText, @QuestionType);
END;
GO

/* update Question pool */

create procedure UpdateQuestionInPool (
    @InstructorID INT,
    @CourseID INT,
    @QuestionID INT,
    @QuestionText nvarchar(MAX),
    @QuestionType nvarchar(50)
)
AS
BEGIN
    -- Check if the instructor is assigned to the course
    if dbo.IsInstructorAssignedtoCourse(@InstructorID, @CourseID) = 0
    BEGIN
        RAISERROR('Instructor not assigned to the course.', 16, 1);
        RETURN;
    END

    -- Check if the question belongs to the course
    if NOT EXISTS (select 1 from QuestionPool where QuestionPoolID = @QuestionID AND CourseID = @CourseID)
    BEGIN
        RAISERROR('Question not found in the specified course.', 16, 1);
        RETURN;
    END

    -- Update the question in the question pool
    UPDATE QuestionPool
    SET QuestionText = @QuestionText, QuestionType = @QuestionType
    where QuestionPoolID = @QuestionID;
END;
GO



/* delete question */
create procedure DeleteQuestionfromPool (
    @InstructorID INT,
    @CourseID INT,
    @QuestionID INT
)
AS
BEGIN
    -- Check if the instructor is assigned to the course
    if dbo.IsInstructorAssignedtoCourse(@InstructorID, @CourseID) = 0
    BEGIN
        RAISERROR('Instructor not assigned to the course.', 16, 1);
        RETURN;
    END

    -- Check if the question belongs to the course
    if NOT EXISTS (select 1 from QuestionPool where QuestionPoolID = @QuestionID AND CourseID = @CourseID)
    BEGIN
        RAISERROR('Question not found in the specified course.', 16, 1);
        RETURN;
    END

    -- Delete the question from the question pool
    DELETE from QuestionPool
    where QuestionPoolID = @QuestionID;
END;
GO


/* test stored procedures*/


-- Test AddQuestiontoPool
EXEC AddQuestiontoPool @InstructorID = 2, @CourseID = 2, @QuestionText = 'What is the capital of France?', @QuestionType = 'MCQ';

-- Test UpdateQuestionInPool
EXEC UpdateQuestionInPool @InstructorID = 1, @CourseID = 1, @QuestionID = 1, @QuestionText = 'What is 2 + 2?', @QuestionType = 'MCQ';

-- Test DeleteQuestionfromPool
EXEC DeleteQuestionfromPool @InstructorID = 1, @CourseID = 1, @QuestionID = 1;




/* This stored procedure allows the Training Manager to add a new instructor. */

create procedure AddInstructor (
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Email nvarchar(100),
    @IsTrainingManager BIT,
    @UserID INT
)
AS
BEGIN
    insert into Instructor (FirstName, LastName, Email, IsTrainingManager, UserID)
    values (@FirstName, @LastName, @Email, @IsTrainingManager, @UserID);
END;
GO

/* This stored procedure allows the Training Manager to update an existing instructor's information. */

alter procedure UpdateInstructor (
    @InstructorID INT,
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Email nvarchar(100),
    @IsTrainingManager BIT
)
AS
BEGIN
    UPDATE Instructor
    SET FirstName = @FirstName, LastName = @LastName, Email = @Email, IsTrainingManager = @IsTrainingManager
    where InstructorID = @InstructorID;
END;
GO

/* This stored procedure allows the Training Manager to delete an instructor.*/

create procedure DeleteInstructor (
    @InstructorID INT
)
AS
BEGIN
    DELETE from Instructor where InstructorID = @InstructorID;
END;
GO

EXEC DeleteInstructor @InstructorID = 1 ;

/* This stored procedure allows the Training Manager to add a new course.*/

create procedure AddCourse (
    @CourseName nvarchar(100),
    @Description nvarchar(MAX),
    @MaxDegree INT,
    @MinDegree INT
)
AS
BEGIN
    insert into Course (CourseName, Description, MaxDegree, MinDegree)
    values (@CourseName, @Description, @MaxDegree, @MinDegree);
END;
GO

/* This stored procedure allows the Training Manager to update an existing course's information.*/

create procedure UpdateCourse (
    @CourseID INT,
    @CourseName nvarchar(100),
    @Description nvarchar(MAX),
    @MaxDegree INT,
    @MinDegree INT
)
AS
BEGIN
    UPDATE Course
    SET CourseName = @CourseName, Description = @Description, MaxDegree = @MaxDegree, MinDegree = @MinDegree
    where CourseID = @CourseID;
END;
GO

/* This stored procedure allows the Training Manager to delete a course. */

create procedure DeleteCourse (
    @CourseID INT
)
AS
BEGIN
    DELETE from Course where CourseID = @CourseID;
END;
GO


EXEC UpdateCourse @CourseID = 1, @CourseName = 'java' , @Description = 'hard' , @MaxDegree = 100 , @MinDegree = 50 ;


/*This stored procedure allows the Training Manager to assign an instructor to a course.*/

create procedure AssignInstructortoCourse (
    @InstructorID INT,
    @CourseID INT
)
AS
BEGIN
    insert into InstructorCourses (InstructorID, CourseID)
    values (@InstructorID, @CourseID);
END;
GO

exec AssignInstructortoCourse @InstructorID = 2 , @CourseID = 2;

/* This stored procedure allows the Training Manager to remove an instructor from a course.*/

create procedure RemoveInstructorfromCourse (
    @InstructorID INT,
    @CourseID INT
)
AS
BEGIN
    DELETE from InstructorCourses
    where InstructorID = @InstructorID AND CourseID = @CourseID;
END;
GO

/*
-- Test AddInstructor
EXEC AddInstructor @FirstName = 'Mark', @LastName = 'Brown', @Email = 'mark.brown@example.com', @IsTrainingManager = 0, @UserID = 5;

-- Test UpdateInstructor
EXEC UpdateInstructor @InstructorID = 1, @FirstName = 'John', @LastName = 'Doe', @Email = 'john.doe@updated.com', @IsTrainingManager = 1;

-- Test DeleteInstructor
EXEC DeleteInstructor @InstructorID = 3;

-- Test AddCourse
EXEC AddCourse @CourseName = 'Chemistry', @Description = 'Basic Chemistry Course', @MaxDegree = 100, @MinDegree = 50;

-- Test UpdateCourse
EXEC UpdateCourse @CourseID = 1, @CourseName = 'Advanced Mathematics', @Description = 'Advanced Math Course', @MaxDegree = 100, @MinDegree = 50;

-- Test DeleteCourse
EXEC DeleteCourse @CourseID = 2;

-- Test AssignInstructortoCourse
EXEC AssignInstructortoCourse @InstructorID = 1, @CourseID = 1;

-- Test RemoveInstructorfromCourse
EXEC RemoveInstructorfromCourse @InstructorID = 1, @CourseID = 1;

*/


/* Add track and intack and branch */
-- Stored procedure to Add a New Branch
create procedure AddBranch
    @BranchName VARCHAR(255)
AS
BEGIN
    insert into Branch (BranchName) values (@BranchName);
END
GO


exec AddBranch @BranchName = 'benisuef';
-- Stored procedure to Add a New Track
create procedure AddTrack
    @TrackName VARCHAR(255),
    @DepartmentID INT
AS
BEGIN
    insert into Track (TrackName, DepartmentID) values (@TrackName, @DepartmentID);
END
GO

exec AddTrack @TrackName = 'dot net', @DepartmentID = 1;;


-- Stored procedure to Add a New Intake
create procedure AddIntake
    @IntakeName VARCHAR(255),
    @Year INT
AS
BEGIN
    insert into Intake (IntakeName, Year) values (@IntakeName, @Year);
END
GO

/* This stored procedure allows the Training Manager to add a new student with their personal data and assignment to intake, branch, and track.*/

create procedure AddStudent (
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Email nvarchar(100),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT,
    @UserID INT
)
AS
BEGIN
    insert into Student (FirstName, LastName, Email, IntakeID, BranchID, TrackID, UserID)
    values (@FirstName, @LastName, @Email, @IntakeID, @BranchID, @TrackID, @UserID);
END;
GO

/* This stored procedure allows the Training Manager to update an existing student's personal data and their assignments to intake, branch, and track.*/

create procedure UpdateStudent (
    @StudentID INT,
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Email nvarchar(100),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT
)
AS
BEGIN
    UPDATE Student
    SET FirstName = @FirstName, LastName = @LastName, Email = @Email, IntakeID = @IntakeID, BranchID = @BranchID, TrackID = @TrackID
    where StudentID = @StudentID;
END;
GO

/* This stored procedure allows the Training Manager to delete a student from the system.*/

create procedure DeleteStudent (
    @StudentID INT
)
AS
BEGIN
    DELETE from Student where StudentID = @StudentID;
END;
GO

/*  test these stored procedures by running the following example scripts:*/


-- Test AddStudent
EXEC AddStudent @FirstName = 'Alice', @LastName = 'Smith', @Email = 'alice.smith@example.com', @IntakeID = 1, @BranchID = 1, @TrackID = 1, @UserID = 1;

-- Test UpdateStudent
EXEC UpdateStudent @StudentID = 1, @FirstName = 'Alice', @LastName = 'Johnson', @Email = 'alice.johnson@updated.com', @IntakeID = 1, @BranchID = 2, @TrackID = 2;

-- Test DeleteStudent
EXEC DeleteStudent @StudentID = 1;



/* create user Account */

create procedure createUserAccount (
    @Username nvarchar(50),
    @PasswordHash nvarchar(256),
    @Role nvarchar(20)
)
AS
BEGIN
    if EXISTS (select 1 from Users where Username = @Username)
    BEGIN
        RAISERROR('Username already exists.', 16, 1);
        RETURN;
    END

    insert into Users (Username, PasswordHash, Role)
    values (@Username, @PasswordHash, @Role);
END;
GO

/* try to authenticate the user */

create procedure AuthenticateUser (
    @Username nvarchar(50),
    @PasswordHash nvarchar(256),
    @Role nvarchar(20) OUTPUT
)
AS
BEGIN
    declare @UserExists BIT;
    select @UserExists = case when EXISTS (select 1 from Users where Username = @Username AND PasswordHash = @PasswordHash) THEN 1 else 0 END;

    if @UserExists = 1
    BEGIN
        select @Role = Role from Users where Username = @Username AND PasswordHash = @PasswordHash;
    END
    else
    BEGIN
        RAISERROR('Invalid username or password.', 16, 1);
        RETURN;
    END
END;
GO

/* create Login for the users */

create procedure createLoginAndUser (
    @Username nvarchar(50),
    @Password nvarchar(256), -- This should be the plaintext password
    @Role nvarchar(20)
)
AS
BEGIN
    declare @SQL nvarchar(MAX);
    
    -- create login
    SET @SQL = 'create LOGIN [' + @Username + '] WITH PASSWORD = ''' + @Password + ''';';
    EXEC sp_executesql @SQL;
    
    -- create user and associate with login
    SET @SQL = 'create USER [' + @Username + '] FOR LOGIN [' + @Username + '];';
    EXEC sp_executesql @SQL;
    
    -- grant role-based permissions
    if @Role = 'Admin'
    BEGIN
        SET @SQL = 'ALTER ROLE [db_owner] ADD MEMBER [' + @Username + '];';
        EXEC sp_executesql @SQL;
    END
    else if @Role = 'TrainingManager'
    BEGIN
        SET @SQL = 'ALTER ROLE [db_datawriter] ADD MEMBER [' + @Username + '];';
        EXEC sp_executesql @SQL;
    END
    else if @Role = 'Instructor'
    BEGIN
        SET @SQL = 'ALTER ROLE [db_datareader] ADD MEMBER [' + @Username + '];';
        EXEC sp_executesql @SQL;
    END
    else if @Role = 'Student'
    BEGIN
        SET @SQL = 'ALTER ROLE [db_datareader] ADD MEMBER [' + @Username + '];';
        EXEC sp_executesql @SQL;
    END
    else
    BEGIN
        RAISERROR('Invalid role specified.', 16, 1);
    END
END;
GO

/* the full procedure for creating user */

create procedure createCompleteUser (
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Email nvarchar(100),
    @Username nvarchar(50),
    @Password nvarchar(256), -- This should be the plaintext password
    @Role nvarchar(20)
)
AS
BEGIN
    -- create the user account with hashed password
    declare @PasswordHash VARBINARY(256);
    SET @PasswordHash = HASHBYTES('SHA2_256', @Password);

    EXEC createUserAccount @Username = @Username, @PasswordHash = @PasswordHash, @Role = @Role;

    -- Get the newly created UserID
    declare @UserID INT;
    select @UserID = UserID from Users where Username = @Username;

    -- insert into respective tables based on the role
    if @Role = 'TrainingManager'
    BEGIN
        insert into Instructor (FirstName, LastName, Email, IsTrainingManager, UserID)
        values (@FirstName, @LastName, @Email, 1, @UserID);
    END
    else if @Role = 'Instructor'
    BEGIN
        insert into Instructor (FirstName, LastName, Email, IsTrainingManager, UserID)
        values (@FirstName, @LastName, @Email, 0, @UserID);
    END
    else if @Role = 'Student'
    BEGIN
        insert into Student (FirstName, LastName, Email, UserID)
        values (@FirstName, @LastName, @Email, @UserID);
    END
    else
    BEGIN
        RAISERROR('Invalid role specified.', 16, 1);
        RETURN;
    END

    -- create SQL Server login and user
    EXEC createLoginAndUser @Username = @Username, @Password = @Password, @Role = @Role;
END;
GO


/* creating complete user test */


-- create Training Manager with comprehensive procedure
EXEC createCompleteUser 
    @FirstName = 'Ahmed', 
    @LastName = 'Mohamed', 
    @Email = 'Ahmed.doe@example.com', 
    @Username = 'Ahmed_doe', 
    @Password = 'Ahmed123', 
    @Role = 'TrainingManager';

-- create Instructor with comprehensive procedure
EXEC createCompleteUser 
    @FirstName = 'Abdelrahman', 
    @LastName = 'fathy', 
    @Email = 'abdelrahman.fathy@example.com', 
    @Username = 'abdo_fathy', 
    @Password = 'jabdelrahman123', 
    @Role = 'Instructor';

-- create Student with comprehensive procedure
EXEC createCompleteUser 
    @FirstName = 'Saif', 
    @LastName = 'mohamed', 
    @Email = 'saif.mohamed@example.com', 
    @Username = 'saif_mohamed', 
    @Password = 'saifEldin123', 
    @Role = 'Student';

/* create exam */

create procedure createExam
    @InstructorID INT,
    @CourseID INT,
    @ExamType VARCHAR(50),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT,
    @StartTime DATETIME,
    @EndTime DATETIME,
    @totalTime INT,
    @Allowances TEXT,
    @ExamID INT OUTPUT
AS
BEGIN
    if (select dbo.IsInstructorAssignedtoCourse(@InstructorID, @CourseID)) = 0
    BEGIN
        RAISERROR('Instructor is not assigned to this course.', 16, 1);
        RETURN;
    END

    insert into Exam (CourseID, InstructorID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, totalTime, Allowances)
    values (@CourseID, @InstructorID, @ExamType, @IntakeID, @BranchID, @TrackID, @StartTime, @EndTime, @totalTime, @Allowances);

    -- Get the newly created ExamID
    SET @ExamID = SCOPE_IDENTITY();

    -- Return the new ExamID
    select @ExamID AS ExamID;
END


/* adding exam questions */

create procedure AddQuestiontoExam
    @ExamID INT,
    @QuestionID INT,
    @Degree INT,
    @CourseID INT,
    @totalDegree INT OUTPUT
AS
BEGIN
    declare @MaxDegree INT;

    -- Get course max degree
    select @MaxDegree = MaxDegree from Course where CourseID = @CourseID;

    -- Check if adding the degree exceeds the max degree
    if @totalDegree + @Degree > @MaxDegree
    BEGIN
        RAISERROR('total degrees exceed the course maximum degree.', 16, 1);
        RETURN;
    END

    -- insert question into ExamQuestion
    insert into ExamQuestion (ExamID, QuestionID, Degree)
    values (@ExamID, @QuestionID, @Degree);

    -- Update total degree
    SET @totalDegree = @totalDegree + @Degree;
END

/* select random questions */

create procedure selectRandomQuestionsByType
    @CourseID INT,
    @QuestionType VARCHAR(50),
    @NumQuestions INT
AS
BEGIN
    select toP (@NumQuestions) QuestionPoolID
    from QuestionPool
    where CourseID = @CourseID AND QuestionType = @QuestionType
    ORDER BY NEWID();
END


/* select manual questions */
create TYPE QuestionIDTable AS TABLE (
    QuestionID INT
);


create procedure selectManualQuestions
    @QuestionIDs QuestionIDTable readonly
AS
BEGIN
    select QuestionPoolID
    from QuestionPool
    where QuestionPoolID IN (select QuestionID from @QuestionIDs);
END

/* assign students to exams */

create TYPE StudentIDTableType AS TABLE (
    StudentID INT
);


-- procedure to assign students to an exam
create procedure AssignStudentstoExam
    @ExamID INT,
    @StudentIDs StudentIDTableType readonly
AS
BEGIN
    insert into StudentExams(ExamID, StudentID)
    select @ExamID, StudentID from @StudentIDs;
END;


-- procedure to define exam details
create procedure DefineExamDetails
    @ExamID INT,
    @StartTime DATETIME,
    @EndTime DATETIME
AS
BEGIN
    UPDATE Exam
    SET StartTime = @StartTime, EndTime = @EndTime
    where ExamID = @ExamID;
END;

-- Example query for students to view their upcoming exams
create procedure GetStudentUpcomingExams
    @StudentID INT
AS
BEGIN
    select e.ExamID, e.CourseID, e.InstructorID, e.ExamType, e.StartTime, e.EndTime, e.totalTime, e.Allowances
    from Exam e
    INNER JOIN StudentExams es on e.ExamID = es.ExamID
    where es.StudentID = @StudentID AND GETDATE() BETWEEN e.StartTime AND e.EndTime;
END;

/* This procedure will handle inserting the student's answer and calculating if it is correct based on the question type.*/
/*
create procedure SubmitStudentAnswer
    @ExamID INT,
    @QuestionID INT,
    @StudentID INT,
    @StudentAnswer nvarchar(500)
AS
BEGIN
    declare @IsCorrect BIT;
    declare @Marks INT;
    declare @CorrectAnswer nvarchar(500);
    declare @QuestionType VARCHAR(50);

    -- Determine the question type and correct answer
    select @QuestionType = QuestionType, @CorrectAnswer = 
        case 
            when QuestionType = 'MultipleChoice' THEN (select OptionText from MultipleChoiceOption where QuestionID = @QuestionID and IsCorrect = 1)
            when QuestionType = 'TrueFalse' THEN (select CAST(CorrectAnswer AS nvarchar(500)) from TrueFalseQuestion where QuestionID = @QuestionID)
            when QuestionType = 'Text' THEN (select BestAnswer from TextQuestion where QuestionID = @QuestionID)
        END
    from QuestionPool 
    where QuestionPoolID = @QuestionID;

    -- Calculate if the answer is correct and the marks
    SET @IsCorrect = case 
        when @QuestionType = 'MultipleChoice' AND @StudentAnswer = @CorrectAnswer THEN 1 
        when @QuestionType = 'TrueFalse' AND @StudentAnswer = @CorrectAnswer THEN 1 
        when @QuestionType = 'Text' AND @StudentAnswer = @CorrectAnswer THEN 1 
        else 0 
    END;

    SET @Marks = case 
        when @IsCorrect = 1 THEN (select Degree from ExamQuestion where ExamID = @ExamID AND QuestionID = @QuestionID) 
        else 0 
    END;

    -- insert the student's answer into the StudentAnswer table
    insert into StudentAnswer (ExamID, QuestionID, StudentID, StudentAnswer, IsCorrect, Marks)
    values (@ExamID, @QuestionID, @StudentID, @StudentAnswer, @IsCorrect, @Marks);
END;

*/
CREATE FUNCTION dbo.SplitString
(
    @Input NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @Output TABLE (Position INT IDENTITY(1,1), Value NVARCHAR(MAX))
AS
BEGIN
    DECLARE @Start INT, @End INT
    SET @Start = 1

    WHILE CHARINDEX(@Delimiter, @Input, @Start) > 0
    BEGIN
        SET @End = CHARINDEX(@Delimiter, @Input, @Start)
        INSERT INTO @Output (Value)
        VALUES (SUBSTRING(@Input, @Start, @End - @Start))
        SET @Start = @End + 1
    END

    INSERT INTO @Output (Value)
    VALUES (SUBSTRING(@Input, @Start, LEN(@Input) - @Start + 1))

    RETURN
END


alter PROCEDURE SubmitStudentAnswer
    @ExamID INT,
    @StudentID INT,
    @QuestionIDs NVARCHAR(MAX),
    @StudentAnswers NVARCHAR(MAX)
AS
BEGIN
    DECLARE @QuestionID INT;
    DECLARE @StudentAnswer NVARCHAR(500);
    DECLARE @IsCorrect BIT;
    DECLARE @Marks INT;
    DECLARE @CorrectAnswer NVARCHAR(500);
    DECLARE @QuestionType VARCHAR(50);

    -- Split the input strings into tables
    DECLARE @Questions TABLE (Position INT, QuestionID INT);
    INSERT INTO @Questions (Position, QuestionID)
    SELECT Position, CAST(Value AS INT)
    FROM dbo.SplitString(@QuestionIDs, ',');

    DECLARE @Answers TABLE (Position INT, StudentAnswer NVARCHAR(500));
    INSERT INTO @Answers (Position, StudentAnswer)
    SELECT Position, Value
    FROM dbo.SplitString(@StudentAnswers, ',');

    -- Declare cursor for processing the answers
    DECLARE answer_cursor CURSOR FOR
        SELECT q.QuestionID, a.StudentAnswer
        FROM @Questions q
        JOIN @Answers a ON q.Position = a.Position;

    OPEN answer_cursor;
    FETCH NEXT FROM answer_cursor INTO @QuestionID, @StudentAnswer;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Determine the question type and correct answer
        SELECT @QuestionType = QuestionType, 
               @CorrectAnswer = 
                   CASE 
                       WHEN QuestionType = 'MultipleChoice' THEN (SELECT OptionText FROM MultipleChoiceOption WHERE QuestionID = @QuestionID AND IsCorrect = 1)
                       WHEN QuestionType = 'TrueFalse' THEN (SELECT CAST(CorrectAnswer AS NVARCHAR(500)) FROM TrueFalseQuestion WHERE QuestionID = @QuestionID)
                       WHEN QuestionType = 'Text' THEN (SELECT BestAnswer FROM TextQuestion WHERE QuestionID = @QuestionID)
                   END
        FROM QuestionPool 
        WHERE QuestionPoolID = @QuestionID;

        -- Calculate if the answer is correct and the marks
        SET @IsCorrect = CASE 
                             WHEN @QuestionType = 'MultipleChoice' AND @StudentAnswer = @CorrectAnswer THEN 1 
                             WHEN @QuestionType = 'TrueFalse' AND @StudentAnswer = @CorrectAnswer THEN 1 
                             WHEN @QuestionType = 'Text' AND @StudentAnswer = @CorrectAnswer THEN 1 
                             ELSE 0 
                         END;

        SET @Marks = CASE 
                         WHEN @IsCorrect = 1 THEN (SELECT Degree FROM ExamQuestion WHERE ExamID = @ExamID AND QuestionID = @QuestionID) 
                         ELSE 0 
                     END;

        -- Insert the student's answer into the StudentAnswer table
        INSERT INTO StudentAnswer (ExamID, QuestionID, StudentID, StudentAnswer, IsCorrect, Marks)
        VALUES (@ExamID, @QuestionID, @StudentID, @StudentAnswer, @IsCorrect, @Marks);

        FETCH NEXT FROM answer_cursor INTO @QuestionID, @StudentAnswer;
    END;

    CLOSE answer_cursor;
    DEALLOCATE answer_cursor;
END;


/* This procedure will aggregate the marks for all exams related to a specific course for a student.*/
create procedure CalculateFinalResult
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    declare @FinalResult INT;

    -- Calculate the final result by summing the marks from all exams in the course
    select @FinalResult = SUM(sa.Marks)
    from StudentAnswer sa
    JOIN Exam e on sa.ExamID = e.ExamID
    where sa.StudentID = @StudentID AND e.CourseID = @CourseID;

    -- Return the final result
    select @FinalResult AS FinalResult;
END;

/* Daily backup */


create procedure DailyBackup
AS
BEGIN
    declare @BackupFile nvarchar(255);
    SET @BackupFile = 'G:\ITI\sql\project\Examination-Database-System' + ConVERT(nvarchar, GETDATE(), 112) + '.bak';

    BACKUP DATABASE ExaminationSystemDatabase
    to DISK = @BackupFile;
END
GO

-- Schedule this procedure to run daily using SQL Server Agent.


--steps 

/*
Open SQL Server Management Studio (SSMS).
Expand SQL Server Agent in the Object Explorer.
Right-click Jobs and select New Job.
Give the job a name, e.g., "DailyBackupJob".
Go to Steps, click New, and create a new step with the following details:
Step Name: "BackupDatabase"
Type: "Transact-SQL script (T-SQL)"
Database: "ExaminationSystemDatabase"
Command: EXEC DailyBackup;
Go to Schedules, click New, and create a new schedule with the following details:
Name: "DailyBackupSchedule"
Schedule Type: "Recurring"
Frequency: Daily
Recurs every: 1 day
Daily Frequency: Occurs once at (choose a suitable time, e.g., 2:00 AM)
Click OK to save the job and schedule.
*/





/* necessary permissions */ 

/** grant execute permission to Training Manager on all relevant stored procedures */

grant execute on dbo.AddInstructor to TrainingManager;

grant execute on dbo.UpdateInstructor to TrainingManager;

grant execute on dbo.DeleteInstructor to TrainingManager;

grant execute on dbo.AddCourse to TrainingManager;

grant execute on dbo.UpdateCourse to TrainingManager;

grant execute on dbo.DeleteCourse to TrainingManager;

grant execute on dbo.AssignInstructortoCourse to TrainingManager;

grant execute on dbo.RemoveInstructorfromCourse to TrainingManager;

grant execute on dbo.AddBranch to TrainingManager;

grant execute on dbo.AddTrack to TrainingManager;

grant execute on dbo.AddIntake to TrainingManager;

grant execute on dbo.AddStudent to TrainingManager;

grant execute on dbo.UpdateStudent to TrainingManager;

grant execute on dbo.DeleteStudent to TrainingManager;


grant execute on dbo.createUserAccount to TrainingManager;

grant execute on dbo.createCompleteUser to TrainingManager;

grant execute on dbo.createLoginAndUser to TrainingManager;

/** grant execute permission to Instructor on relevant stored procedures */

grant execute on dbo.AddQuestiontoPool to Instructor;

grant execute on dbo.UpdateQuestionInPool to Instructor;

grant execute on dbo.DeleteQuestionfromPool to Instructor;

grant execute on dbo.selectRandomQuestionsByType to Instructor;

grant execute on dbo.selectManualQuestions to Instructor;

grant execute on dbo.createExam to Instructor;

grant execute on dbo.AddQuestiontoExam to Instructor;

grant execute on dbo.AssignStudentstoExam to Instructor;

grant execute on dbo.DefineExamDetailsس to Instructor;

/** grant execute permission to Student on relevant stored procedures */

grant execute on dbo.GetStudentUpcomingExams to Student;

grant execute on dbo.SubmitStudentAnswer to Student;





