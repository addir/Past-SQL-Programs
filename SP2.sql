/*
Create a Stored Procedure (using joins) that will display data for an instructor(HireDate is not null) in this format:

PersonID	FirstName	LastName	CourseID	Course_Teaching		Home_Phone		Cell_Phone		Work_Phone
1			Kim		Abercrombie	1050		Chemistry		(504) 621-8927		(410) 621-8927		(313) 621-8927

OR if it is a student (HireDate is null), in this format:

PersonID	FirstName	LastName	CourseID	Course_Enrolled		Personal Email				Work Email
2			Gytis		Barzdukas	2021		Composition		josephine_darakjy@darakjy.org		ezekiel@chui.com


*/

CREATE PROCEDURE Show_Instr_and_Students --Create the procedure
@desired_person numeric(3) = null

As 

Declare --Define and declare program variable
	@HiredOn datetime;

Begin  --Define program logic
	SELECT @HiredOn = P.HireDate
	FROM Person P
	WHERE P.PersonID = @desired_person;

	IF @HiredOn is not null --Where P.HireDate is not null (instructor)
		BEGIN
			SELECT P.PersonID,P.FirstName,P.LastName,CI.CourseID,Crs.Title AS [Course_Teaching], --Get PersonID, FirstName and LastName from Person / 
			'('+C.Area_Code+') '+C.Phone_Number AS [Home_Phone],								-- CourseID from CourseInstructor / Title from Course
			'('+C2.Area_Code+') '+C2.Phone_Number AS [Cell_Phone],								-- Area_Code + Phone Number to show Home_Phone, Cell_Phone, Work_Phone
			'('+C3.Area_Code+') '+C3.Phone_Number AS [Work_Phone]
	FROM Person P, ContactInfo C, CourseInstructor CI, Course Crs, ContactInfo C2, ContactInfo C3
	Where P.PersonID = @desired_person
	and P.PersonID = C.PersonID 
	and P.PersonID = CI.PersonID		-- Join the tables using self join methods
	and CI.CourseID = Crs.CourseID
	and P.PersonID = C2.PersonID
	and P.PersonID = C3.PersonID
	and C.Phone_Type like 'home'
	and C2.Phone_Type like 'cell'
	and C3.Phone_Type like 'work'
		End;
	
	ELSE --Where P.HireDate is not null (student)
		BEGIN
		SELECT P.PersonID,P.FirstName,P.LastName,SG.CourseID,Crs.Title AS [Course_Enrolled],C.Email_Type,C.Email as [Personal Email], C2.Email as [Work Email]
	FROM Person P, ContactInfo C, StudentGrade SG, Course Crs, ContactInfo C2
	Where P.PersonID = @desired_person
	and P.PersonID = C.PersonID								--Get PersonID, FirstName and LastName from Person /
	and P.PersonID = SG.StudentID							-- CourseID from StudentGrade / Title from Course / 
	and SG.CourseID = crs.CourseID							-- Email_Type and Email from ContactInfo to show Personal Email
	and P.PersonID = C2.PersonID							-- Email_Type and Email from ContactInfo2 to show Work Email 
	and C.Email_Type like 'Personal' 
	and C2.Email_Type like 'Work'

		End; --End if condition
End; --End Procedure
GO

select * from Person  --callback statements
where Person = 4 

exec Show_Instr_and_Students 4

select * from Person
where Person = 4


		

