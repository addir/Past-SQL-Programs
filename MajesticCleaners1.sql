--QUERY 1
select top 10 c.FirstName,c.LastName,
(p.CashAmount+p.ChangeAmount+p.GiftAmount+p.TenderAmount) 
as totalamount from Payments p 
join Customers c on c.CustomerID=p.CustomerID
where (YEAR(p.PayDate) = 2014)
order by totalamount desc 
 --------------------------------------------
 --QUERY 2
select Zip,count(Zip) as ZipCustomers
from Customers
group by Zip Having COUNT(Zip)>10 

---------------------------------------------
--QUERY 3
select sum(i.Total) Total,i.DepartmentID Department 
from Invoices i,Customers c 
where c.FirstName Like '%Daryl%' and c.LastName Like '%Vanhoose%' 
group by i.DepartmentID   

---------------------------------------------
--QUERY 4
select top 4 i.DepartmentID,
COUNT(i.DepartmentID) used
from Invoices i 
group by i.DepartmentID, 
i.DepartmentID Having (COUNT(i.DepartmentID))>1
---------------------------------------------
--QUERY 5

SELECT customers.CustomerID, CONCAT(FirstName,' ',LastName) 'Full Name', OrderID, StoreID, RackDate, PickupDate,
ElapsedDays = DATEDIFF(DAY, RackDate, '2014-05-15 00:00:00.0000000')
FROM Customers, Invoices
WHERE RackDate < '5/16/2013' AND PickupDate is Null
ORDER BY ElapsedDays Desc


---------------------------------------------------------------
--QUERY 6

CREATE PROCEDURE disp_out_orders
@firstname varchar(15) = null,
@lastname varchar(15) = null

AS

DECLARE custcursor CURSOR FOR
SELECT I.OrderID, I.StoreID, I.Pieces, I.Total, O.OrderDate
FROM Invoices As I
	Inner Join Orders As O
	ON  I.OrderID = O.OrderID AND I.StoreID = O.StoreID
	Inner Join Customers As C
	ON O.CustomerID = C.CustomerID
WHERE C.FirstName like '%'+@firstname+'%' AND
C.LastName like '%'+@lastname+'%' AND I.PickupDate is NULL;


DECLARE
@OrderNo numeric (7),
@StoreNo numeric (5),
@InvPieces numeric (4),
@TotAmt numeric (8,2),
@OrderDate datetime;

BEGIN
	SET @InvPieces=0;

	SELECT @InvPieces = count(*) 
	FROM Invoices I
		Inner Join Orders As O
		ON  I.OrderID = O.OrderID
		Inner Join Customers As C
		ON O.CustomerID = C.CustomerID 
	WHERE C.FirstName like '%'+@firstname+'%' 
	AND C.LastName like '%'+@lastname+'%' 
	AND I.PickupDate is NULL;

	PRINT @firstname + ' has ' + convert(varchar,@InvPieces) +
	' outstanding invoices';
	
	OPEN custcursor;



	FETCH FROM custcursor INTO
	@OrderNO, @StoreNo, @InvPieces, @TotAmt, @OrderDate;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @firstname + @lastname + convert(varchar, @OrderNO) +
		convert(varchar, @StoreNo) +
		' has ' + convert(varchar,@InvPieces)
		+ ' outstanding invoices' + ' with a total of: '
		+ convert(varchar, @TotAmt) + ' ordered on '  + 
		convert(varchar,@OrderDate);
	

	FETCH NEXT FROM custcursor INTO
	@OrderNO, @StoreNo, @InvPieces, @TotAmt, @OrderDate;

	END;

CLOSE custcursor;
DEALLOCATE custcursor;

END;