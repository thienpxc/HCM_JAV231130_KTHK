--TẠO CSDL
CREATE DATABASE Test2

USE Test2

--TẠO BẢNG STUDENTS
CREATE TABLE STUDENTS(
    StudentID INT(4) PRIMARY KEY ,
    StudentName NVARCHAR(50),
    AGE INT (4),
    EMAIL NVARCHAR(100)
)

--Tạo bảng Subjects
CREATE TABLE SUBJECTS(
    SubjectID INT(4) PRIMARY KEY,
    SubjectName NVARCHAR(50)
)

--Tạo bảng Classes
CREATE TABLE CLASSES(
    ClassID INT(4) PRIMARY KEY,
    ClassName NVARCHAR(50)
)

--Tạo bảng ClassStudent
CREATE TABLE CLASSSTUDENT(
    ClassID INT(4),
    StudentID INT(4)
)

--Tạo bảng Marks
CREATE TABLE MARKS(
    StudentID INT(4),
    SubjectID INT(4),
    Mark INT(4)
)

--tạo khóa phụ ClassStudent
ALTER TABLE classstudent
ADD CONSTRAINT FK_ClassStudent_Students
FOREIGN KEY (StudentID) REFERENCES STUDENTS(StudentID),
ADD CONSTRAINT FK_ClassStudent_Classes
FOREIGN KEY (ClassID) REFERENCES CLASSES(ClassID);

--tạo khóa phụ mark
ALTER TABLE marks
ADD CONSTRAINT FK_Marks_Students
FOREIGN KEY (StudentID) REFERENCES STUDENTS(StudentID),
ADD CONSTRAINT FK_Marks_Subjects
FOREIGN KEY (SubjectID) REFERENCES SUBJECTS(SubjectID);

--THÊM DỮ LIỆU VÀO BẢNG STUDENTS
INSERT INTO STUDENTS(StudentID,StudentName,AGE,EMAIL) VALUES(1, 'Nguyễn Quang An', 18,'an@yahoo.com'),
(2, 'Nguyễn Cong vinh', 20,'vinh@gmail.com'),
(3, 'Nguyễn van quyen', 19,'quyen'),
(4, 'Pham thanh Binh', 25,'binh2com'),
(5, 'Nguyen van tai em', 30,'taiem@sport.vn')

--THÊM DỮ LIỆU VÀO BẢNG Classes
INSERT INTO CLASSES(ClassID,ClassName) VALUES(1, 'C0706L'),
(2, 'C0708G')

--THÊM DỮ LIỆU VÀO BẢNG ClassStudent
INSERT INTO CLASSSTUDENT(ClassID,StudentID) VALUES(1,1),
(1,2),
(2,3),
(2,4),
(2,5)

--THÊM DỮ LIỆU VÀO BẢNG Subjects
INSERT INTO SUBJECTS(SubjectID,SubjectName) VALUES(1, 'SQL'),
(2, 'Java'),
(3, 'C'),
(4, 'Visual Basic')

--THÊM DỮ LIỆU VÀO BẢNG Marks
INSERT INTO MARKS(StudentID,SubjectID,Mark) VALUES(1,1,8),
(1,2,4),
(1,1,9),
(3,1,7),
(4,1,3),
(5,2,5),
(3,3,8),
(3,3,1),
(4,2,3)

//viet cau truy xuat
--1.hien thi danh sach tat ca cac hoc vien 
SELECT * FROM STUDENTS

--2.hien thi danh sach tat ca cac mon hoc
SELECT * FROM SUBJECTS

--3. tinh diem trung binh
SELECT m.StudentID, s.StudentName, AVG(m.Mark) AS diem_trung_binh
FROM MARKS m
JOIN students s ON m.StudentID = s.StudentID
GROUP BY m.StudentID, s.StudentName;

--4.Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
SELECT s.StudentName, u.SubjectName, m.Mark
FROM MARKS m
JOIN STUDENTS s ON s.StudentID = m.StudentID
JOIN SUBJECTS u ON u.SubjectID = m.SubjectID
ORDER BY m.Mark DESC
LIMIT 1;

--5.Danh so thu tu cua diem theo chieu giam
SELECT s.StudentName, u.SubjectName, m.Mark
FROM MARKS m
JOIN STUDENTS s ON s.StudentID = m.StudentID
JOIN SUBJECTS u ON u.SubjectID = m.SubjectID
ORDER BY m.Mark DESC

--6.Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh varchar(255)
ALTER TABLE SUBJECTS
MODIFY COLUMN SubjectName NVARCHAR(4000);

-- 7.Cap nhat them dong chu « Day la mon hoc «  vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
UPDATE SUBJECTS
SET SubjectName = CONCAT('Day la mon hoc ', SubjectName)

--8.Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
ALTER TABLE STUDENTS
ADD CONSTRAINT CHK_Age CHECK (AGE > 15 AND AGE < 50)

--9.Loai bo tat ca quan he giua cac bang
ALTER TABLE classstudent
DROP FOREIGN KEY FK_ClassStudent_Students;

ALTER TABLE classstudent
DROP FOREIGN KEY FK_ClassStudent_Classes;

ALTER TABLE marks
DROP FOREIGN KEY FK_Marks_Students;

ALTER TABLE marks
DROP FOREIGN KEY FK_Marks_Subjects;

--10.Xoa hoc vien co StudentID la 1
DELETE FROM STUDENTS
WHERE StudentID = 1

--11.Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
ALTER TABLE STUDENTS
ADD Status BIT DEFAULT 1

--12.Cap nhap gia tri Status trong bang Student thanh 0
UPDATE STUDENTS
SET Status = 0















