USE ExaminationSystemDatabase;

CREATE INDEX idx_users_username ON Users (Username);

CREATE INDEX idx_department_branchid ON Department (BranchID);

CREATE INDEX idx_track_departmentid ON Track (DepartmentID);

CREATE INDEX idx_instructor_userid ON Instructor (UserID);

CREATE INDEX idx_student_intakeid ON Student (IntakeID);

CREATE INDEX idx_student_branchid ON Student (BranchID);

CREATE INDEX idx_student_trackid ON Student (TrackID);

CREATE INDEX idx_student_userid ON Student (UserID);

CREATE INDEX idx_instructorcourses_instructorid ON InstructorCourses (InstructorID);

CREATE INDEX idx_instructorcourses_courseid ON InstructorCourses (CourseID);

CREATE INDEX idx_questionpool_courseid ON QuestionPool (CourseID);

CREATE INDEX idx_multiplechoiceoption_questionid ON MultipleChoiceOption (QuestionID);

CREATE INDEX idx_truefalsequestion_questionid ON TrueFalseQuestion (QuestionID);

CREATE INDEX idx_textquestion_questionid ON TextQuestion (QuestionID);

CREATE INDEX idx_exam_courseid ON Exam (CourseID);

CREATE INDEX idx_exam_instructorid ON Exam (InstructorID);

CREATE INDEX idx_exam_intakeid ON Exam (IntakeID);

CREATE INDEX idx_exam_branchid ON Exam (BranchID);

CREATE INDEX idx_exam_trackid ON Exam (TrackID);

CREATE INDEX idx_examquestion_examid ON ExamQuestion (ExamID);

CREATE INDEX idx_examquestion_questionid ON ExamQuestion (QuestionID);

CREATE INDEX idx_studentanswer_examid ON StudentAnswer (ExamID);

CREATE INDEX idx_studentanswer_questionid ON StudentAnswer (QuestionID);

CREATE INDEX idx_studentanswer_studentid ON StudentAnswer (StudentID);

CREATE INDEX idx_studentcourses_studentid ON StudentCourses (StudentID);

CREATE INDEX idx_studentcourses_courseid ON StudentCourses (CourseID);

CREATE INDEX idx_studentexams_studentid ON StudentExams (StudentID);

CREATE INDEX idx_studentexams_examid ON StudentExams (ExamID);
