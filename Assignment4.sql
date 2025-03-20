"Task1-Step 1: Create Professor1 Table with Address as an Object"
CREATE TYPE address_typ AS OBJECT (
    StreetNo NUMBER(10),
    StreetName VARCHAR2(100),
    AptNo NUMBER(5),
    City VARCHAR2(100),
    State VARCHAR2(100),
    ZipCode NUMBER(9),
    Country VARCHAR2(100)
);

CREATE TABLE Professor1 (
    ProfessorID NUMBER PRIMARY KEY,
    ProfessorName VARCHAR2(100),
    ProfessorAddress address_typ
);

INSERT INTO Professor1 VALUES (
    1,
    'Dr. John Doe',
    address_typ(123, 'Main St', 5, 'Toronto', 'Ontario', 12345, 'Canada')
);

INSERT INTO Professor1 VALUES (
    2,
    'Dr. Jane Smith',
    address_typ(456, 'Elm St', 10, 'Vancouver', 'British Columbia', 67890, 'Canada')
);
SELECT * FROM Professor1;


"Task1-Step 2: Create Professor2 Table with Circular Object Type"
CREATE TYPE professor_typ AS OBJECT (
    ProfessorID NUMBER,
    ProfessorName VARCHAR2(100),
    Department VARCHAR2(100),
    Mentor REF professor_typ
);

CREATE TABLE Professor2 OF professor_typ (
    PRIMARY KEY (ProfessorID)
);

INSERT INTO Professor2 VALUES (
    1,
    'Dr. John Doe',
    'Computer Science',
    NULL
);

INSERT INTO Professor2 VALUES (
    2,
    'Dr. Jane Smith',
    'Mathematics',
    NULL
);

UPDATE Professor2
SET Mentor = (
    SELECT REF(p)
    FROM Professor2 p
    WHERE p.ProfessorID = 2
)
WHERE ProfessorID = 1;

UPDATE Professor2
SET Mentor = (
    SELECT REF(p)
    FROM Professor2 p
    WHERE p.ProfessorID = 1
)
WHERE ProfessorID = 2;

SELECT * FROM Professor2;

"Tak3: Add NumCourses Attribute to the Professor Object and Create a Procedure to Increment Courses"
DROP TABLE Professor2;

CREATE OR REPLACE TYPE professor_typ AS OBJECT (
    ProfessorID NUMBER,
    ProfessorName VARCHAR2(100),
    Department VARCHAR2(100),
    NumCourses NUMBER,
    Mentor REF professor_typ
);


CREATE TABLE Professor2 OF professor_typ (
    PRIMARY KEY (ProfessorID)
);

-- Reinsert data
INSERT INTO Professor2 VALUES (
    1,
    'Dr. John Doe',
    'Computer Science',
    3,
    NULL
);

INSERT INTO Professor2 VALUES (
    2,
    'Dr. Jane Smith',
    'Mathematics',
    2,
    NULL
);

CREATE OR REPLACE PROCEDURE IncrementCourses (
    p_ProfessorID IN NUMBER,
    p_IncrementBy IN NUMBER
) AS
BEGIN
    UPDATE Professor2
    SET NumCourses = NumCourses + p_IncrementBy
    WHERE ProfessorID = p_ProfessorID;
END;
/

BEGIN
    IncrementCourses(1, 1); -- Increment Dr. John Doe's courses by 1
END;
/

SELECT * FROM Professor2;