use ExaminationSystemDatabase
/* This trigger will prevent students from submitting answers outside the designated exam time window. */
CREATE TRIGGER trg_EnsureExamTime
ON StudentAnswer
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ExamID INT;
    DECLARE @CurrentTime DATETIME;
    DECLARE @StartTime DATETIME;
    DECLARE @EndTime DATETIME;

    SELECT @ExamID = ExamID FROM inserted;
    SELECT @CurrentTime = GETDATE();

    SELECT @StartTime = StartTime, @EndTime = EndTime
    FROM Exam
    WHERE ExamID = @ExamID;

    -- Check if the current time is within the exam time window
    IF @CurrentTime NOT BETWEEN @StartTime AND @EndTime
    BEGIN
        -- Raise an error and rollback the transaction if the current time is outside the exam time window
        RAISERROR ('You can only submit answers during the designated exam time window.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- If the current time is within the exam time window, insert the row into StudentAnswer
        INSERT INTO StudentAnswer (ExamID, QuestionID,StudentID, StudentAnswer  ,IsCorrect , Marks)
        SELECT ExamID, QuestionID ,StudentID, StudentAnswer , IsCorrect , Marks
        FROM inserted;
    END
END;

drop trigger trg_EnsureExamTime

/* This trigger will update the StudentExams table with the total score whenever a student answer is inserted. */

CREATE TRIGGER trg_UpdateFinalScore
ON StudentAnswer
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @ExamID INT;
    DECLARE @StudentID INT;

    SELECT @ExamID = ExamID, @StudentID = StudentID FROM inserted;

    UPDATE StudentExams
    SET Score = (
        SELECT SUM(Marks)
        FROM StudentAnswer
        WHERE ExamID = @ExamID AND StudentID = @StudentID
    )
    WHERE ExamID = @ExamID AND StudentID = @StudentID;
END;

/* This trigger ensures that no two users can have the same username. */
CREATE TRIGGER trg_UniqueUsername
ON Users
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    DECLARE @Username VARCHAR(255);

    SELECT @Username = Username FROM inserted;

    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
    BEGIN
        RAISERROR ('Username already exists. Please choose a different username.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM inserted)
        BEGIN
            INSERT INTO Users (UserID, Username, PasswordHash, Role)
            SELECT UserID, Username, PasswordHash, Role FROM inserted;
        END
        ELSE
        BEGIN
            UPDATE Users
            SET Username = inserted.Username,
                PasswordHash = inserted.PasswordHash,
                Role = inserted.Role
            FROM inserted
            WHERE Users.UserID = inserted.UserID;
        END
    END
END;

/* This trigger will prevent a student from being enrolled in the same course more than once. */

alter TRIGGER trg_EnsureUniqueEnrollment
ON StudentCourses
instead of INSERT
AS
BEGIN
    DECLARE @StudentID INT;
    DECLARE @CourseID INT;

    SELECT @StudentID = StudentID, @CourseID = CourseID FROM inserted;

    IF EXISTS (SELECT 1 FROM StudentCourses WHERE StudentID = @StudentID AND CourseID = @CourseID)
    BEGIN
        RAISERROR ('Student is already enrolled in this course.', 16, 1);
        ROLLBACK TRANSACTION;
    END
	else
	begin
INSERT INTO StudentCourses (StudentID, CourseID  ,EnrollmentDate)
        SELECT StudentID, CourseID ,EnrollmentDate
        FROM inserted;	
		end
END;

--drop trigger trg_EnsureUniqueEnrollment


/* Trigger to Prevent Deleting Instructors Assigned to Courses */

CREATE TRIGGER trg_PreventInstructorDeletionWithAssignedCourses
ON Instructor
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM deleted d
        JOIN InstructorCourses ci ON d.InstructorID = ci.InstructorID
    )
    BEGIN
        RAISERROR('Cannot delete instructor assigned to courses.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        DELETE FROM Instructor
        WHERE InstructorID IN (SELECT InstructorID FROM deleted);
    END
END;


---------- Course Table ----------

create trigger CourseTrig
on Course
after  insert,update,delete
as
	select 'Done'
------------------

---------- Instructor Table ----------

create trigger InstructorTrig
on Instructor
after  update
as
	if update([InstructorID])
	select 'an instructorID has been updated'

---------------------------

---------- Branch Table ----------
-------------------
create trigger trig_Branch
on Branch
after  insert
as
	select 'Branch created successfully'


---------- Track Table ----------
create trigger trig_Track
on Track
after insert
as
	select 'track created successfully'
-------------------
create trigger trig_upTrackTri
on Track
after  update
as
	select 'track updated successfully'


---------- Department Table ----------

-------------------
create trigger trig_Department
on Department
after  insert
as
	select 'Department created successfully'



---------- Intake Table ----------
create trigger trig_Intake
on Intake
after  insert
as
	select 'Intake created successfully'

---------- QuestionPool Table ----------
create trigger trig_QuestionPool
on QuestionPool
after  insert
as
	select 'question created successfully'

---------- Exam Table ----------
alter trigger trig_Exam
on Exam
 after insert
as
	select 'exam created successfully'
	


---------- Users Table ----------
create trigger trig_Users
on Users
after  insert
as
	select 'user created successfully'



