---- 17CS30022 ------
---- Kousshik Raj ----

CREATE TABLE Student (
    roll_no INT NOT NULL, 
    name VARCHAR(30) NOT NULL, 
    cgpa  DECIMAL(7,2) NOT NULL DEFAULT 0.00, 
    credits_cleared INT NOT NULL DEFAULT 0,
    PRIMARY KEY (roll_no)
);

CREATE TABLE Course (
    course_cd CHAR(2) NOT NULL, 
    course_name VARCHAR(30) NOT NULL, 
    credits INT NOT NULL,
    PRIMARY KEY (course_cd)
);

CREATE TABLE Student_course  (
    roll_no  INT NOT NULL,  
    course_cd  CHAR(2)  NOT NULL,  
    grade_point  INT  NOT NULL DEFAULT 0,
    PRIMARY KEY (roll_no, course_cd),
    FOREIGN KEY (roll_no) REFERENCES Student(roll_no),
    FOREIGN KEY (course_cd) REFERENCES Course(course_cd)
);


CREATE TABLE Prerequisite (
    course_cd CHAR(2) NOT NULL, 
    prereq_course_cd CHAR(2) NOT NULL,
    PRIMARY KEY (course_cd, prereq_course_cd),
    FOREIGN KEY (course_cd) REFERENCES Course(course_cd),
    FOREIGN KEY (prereq_course_cd) REFERENCES Course(course_cd)
);

-- INSERT INTO Student VALUES(1, 'Mr. Raj', 8.00, 23);
-- INSERT INTO Student VALUES(2, 'Ms. Jar', 9.52, 42);

-- INSERT INTO Course VALUES(1, 'ca', 3);
-- INSERT INTO Course VALUES(2, 'bb', 2);
-- INSERT INTO Course VALUES(3, 'ac', 4);

-- INSERT INTO Student_course VALUES(2, 2, 8);
-- INSERT INTO Student_course VALUES(1, 2, 10);
-- INSERT INTO Student_course VALUES(1, 1, 7);

-- INSERT INTO Prerequisite VALUES(2, 4);

------------ 1a -------------------

CREATE TRIGGER update_credits_insert_
AFTER INSERT on Student_course
FOR EACH ROW
WHEN (n.grade_point >= 5)
BEGIN ATOMIC
     UPDATE Student
     SET credits_cleared = credits_cleared + 
           (SELECT credits
            FROM Course
            WHERE Course.course_cd = :new.course_cd)
     WHERE student.roll_no = n.roll_no;
END;


----------- 1b --------------------------

CREATE TRIGGER update_credits_update_ 
AFTER UPDATE on Course
FOR EACH ROW
BEGIN ATOMIC
	UPDATE Student
	SET credits_cleared = credits_cleared + new.credits - old.credits
	WHERE EXISTS(
        SELECT roll_no 
        FROM Student_course 
        WHERE Student_course.roll_no = Student.roll_no AND 
                        Student_course.grade_point >= 5 AND 
                            Student_course.course_cd = :new.course_cd
    );
END;

-------------- 2 -------------------------

-- SET SERVEROUTPUT on;
CREATE PROCEDURE updateCgpa 
@roll INT, 
@cg DECIMAL(7, 2) OUTPUT
AS 
BEGIN
	SELECT @cg = SUM(SC.grade_point * C.credits) / SUM(C.credits) 
	FROM Student_course as SC, Course as C
	WHERE C.course_cd = SC.course_cd and SC.roll_no = @roll;

	UPDATE Student
	SET cgpa = cg
	WHERE Student.roll_no = @roll;
END;

--- EXEC updateCgpa(1)
--- DROP PROCEDURE updateCgpa

-------------------- 3 ----------------------------------

WITH Q AS 
(
    SELECT C.course_cd as rootCrc, C.credits as creds                   ---- The anchor query with first level courses
    FROM Course as C, Prerequisite as P                                 ---- and their credits that have course id 1 as 
    WHERE C.course_cd = P.course_cd AND P.prereq_course_cd = 1          ---- a prerequisite

    UNION ALL

    SELECT C.course_cd as rootCrc, C.credits as creds                   ---- The recursive query which then finds all
    FROM Prerequisite as P                                              ---- courses that have their prerequisites from
        INNER JOIN Q ON P.prereq_course_cd = Q.rootCrc                  ---- one of the courses in the previous recursion
            INNER JOIN Course as C on C.course_cd = P.course_cd         ---- phase
)
SELECT SUM(Q.creds)
FROM Q