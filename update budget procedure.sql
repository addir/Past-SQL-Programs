/*
Create a SP named 'UpdateBudget' that will take dept id as an input parameter. 
If the dept is 'Engineering' then decrease the budget to half of the current amount. 
If it is any other department then increase the budget by 10%.

Display print results as shown:
Dept#: 1
Dept Name: Engineering
Old Budget: 232925
New Budget: 116463

Also to verify results, do a select before and after the procedure like so:

select * from Department
where DepartmentID = 1

exec Update_Budget 1

select * from Department
where DepartmentID = 1

*/

--select * from Department



CREATE PROCEDURE Update_Department   --Create the procedure
@desired_department numeric(2) = null

As 

Declare --Define and declare program variables
	@DeptName varchar(15),
	@OldBudget numeric(7),
	@NewBudget numeric(7);

Begin --Define program logic
	SELECT @DeptName = Name, @OldBudget = Budget --Get department name and budget from department table
	FROM Department
	WHERE DepartmentID = @desired_department;

	IF @DeptName = 'Engineering' --Find where department is 'Engineering'
		BEGIN
			SET @NewBudget = @OldBudget * .5 --Calculate the new budget as 50% of the old budget
			UPDATE Department SET Budget = @NewBudget WHERE DepartmentID = @desired_department; --update the old budget with new budget amount
			print 'dpt#:  ' + convert(varchar, @desired_department)+' budget changed to:  ' + convert(varchar, @NewBudget);
			--Return the statement as "dpt#: ___ budget changed to: ____
		End;

	ELSE --If the department is not "Engineering"
		BEGIN
		SET @NewBudget = @OldBudget * 1.1 --Calculate the new budget as 10% greater than old budget
		UPDATE Department SET Budget = @NewBudget WHERE DepartmentID = @desired_department;
		print 'Dpt#:  ' + convert(varchar, @desired_department) --Display desired department as "Dpt#:"
		print 'Dpt Name:  ' + convert(varchar, @DeptName) --Display DeptName as "Dpt Name:"
		print 'Old Budget:  ' + convert(varchar, @OldBudget) --Display OldBudget as "Old Budget:"
		print 'New Budget:  ' + convert(varchar, @NewBudget); --Display NewBudget as "New Budget:"
		End; --End if condition
End;  --End Procedure
GO

select * from Department --Callback statements
where DepartmentID = 2

exec Update_Department 2

select * from Department
where DepartmentID = 2