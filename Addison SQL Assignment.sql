/* EXERCISE

1) Show me the first person that ever enrolled.
Only 1 row should be displayed.
The result should be displayed as:

Full Name			Year
Browning, Meredith	2000  
*/
SELECT top 1 lastname + ', ' + firstname 
as 'full name', Year(enrollmentdate) as 'Year'
FROM person
WHERE enrollmentdate is not null
Order by enrollmentdate



/*2) Show me all unique months for hiredate in the person table
in this format and order (8 rows):

MonthNumber		Month
1				January
2				February
3				March
6				June
7				July
8				August
10				October
12				December
*/
SELECT DISTINCT MONTH(HireDate) as MonthNumber, Datename(month,hiredate) as 'Month'
FROM  Person;
WHERE hiredate is not null


/*3) Show me everyone who was either hired
in the current month of any year or enrolled in the previous
month in the following format (25 rows):

FirstName	LastName	Hire_Date	Enrollment_Date
Gytis		Barzdukas	NULL		09/01/2005
Peggy		Justice		NULL		09/01/2001
Yan			Li			NULL		09/01/2002
Laura		Norman		NULL		09/01/2003
*/
Select * from person
WHERE Month(hiredate) = month(getdate())
OR
Month(enrollmentdate) = Month(getdate()) -1 


/*4) How many Departments have a budget greater than $200,000
   (Use Department Table)

Department
2
*/
SELECT COUNT(*) as Department
FROM Department
WHERE Budget > 200000


/* 5) Show me the total credit hours for all courses
starting with the letter 'C'

Total_Credits
11
*/
SELECT SUM(Credits) as Total_Credits
FROM Course;
WHERE Title like 'C%'


/*6) Who has the minimum GPA?

Min_GPA
1.50
*/
SELECT Min(Grade) as Min_GPA
FROM StudentGrade;
