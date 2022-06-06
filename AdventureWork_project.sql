--AdventureWorks database
--Concatenate the name columns
Use AdventureWorks
select	CONCAT(FirstName+' ',MiddleName+' ',LastName) as Full_Name,
		CONCAT_WS(' ',FirstName,MiddleName,LastName) as 'Full Name', Phone
		from [Person].[Contact];

--Creating row number and extracting the second and third row
select * from 
(select ROW_NUMBER() over(order by FirstName, MiddleName, LastName) as row_num, * 
from [Person].[Contact]) x1
where x1.row_num between 2 and 3
order by ContactID;

-- Using rank to find the duplicate names in [Person].[Contact] table.

select * 
	from (
	select FirstName, MiddleName, LastName, concat_ws(' ',FirstName, MiddleName, LastName) as FullName ,
	rank() over(partition by concat_ws(' ',FirstName, MiddleName, LastName) order by FirstName) as rank_
	from [Person].[Contact]
	) x
where x.rank_ > 1;

--Checking the results for dup FullNames

select top 20 FirstName, MiddleName, LastName, concat_ws(' ',FirstName, MiddleName, LastName) as FullName 
	from Person.Contact
	where LastName in ('Wright','Bueno','Wang')
	order by FullName;

--Create View of employees for each department and group

Alter view Employees_View as(
	select e.EmployeeID, MiddleName, LastName, concat_ws(' ',FirstName, MiddleName, LastName) as FullName,
	hd.Name as Department, hd.GroupName
	from [HumanResources].[Employee] e join [Person].[Contact] pc on e.ContactID = pc.ContactID 
	join [HumanResources].[EmployeeDepartmentHistory] edh on edh.EmployeeID = e.EmployeeID 
	join [HumanResources].[Department] hd on edh.DepartmentID = hd.DepartmentID);
	
-- Self join
/*Finding employees that work in different departments but under the same group using self join. 
Also using case statement for this condition*/

select ee2.*, case when ee1.EmployeeID = ee2.EmployeeID 
	 and ee1.GroupName = ee2.GroupName and ee1.Department <> ee2.Department then 'Yes'
	Else 'No ' end as 'Same Group but different department'
	from Employees_View ee1 inner join Employees_View ee2 on ee1.EmployeeID = ee2.EmployeeID
where ee1.EmployeeID = ee2.EmployeeID and ee1.GroupName = ee2.GroupName and ee1.Department <> ee2.Department; 

-- Creating CTE to obtain average pay rate and number of employees who has same title

with Employee_CTE
as
(	select e.Title, e_pay.Rate ,
	count(e.Title) over(partition by e.Title) as Num_Title_Emp,
	avg(e_pay.Rate) over (partition by e.Title) as Avg_Payrate 
	from  [HumanResources].[EmployeePayHistory] e_pay join [HumanResources].[Employee] e 
	on e_pay.EmployeeID = e.EmployeeID
	group by e.Title, e_pay.Rate
)
select * from Employee_CTE;

-- Case statement, adding job grades column

select e_pay.Rate, e.Title, case 
				when e_pay.Rate < 10 then 'Level 1'
				when e_pay.Rate between 10 and 20 then 'Level 2'
				when e_pay.Rate between 20 and 40 then 'Level 3'
				when e_pay.Rate between 40 and 70 then 'Level 4'
				when e_pay.Rate >70 then 'Level 5'
				end as 'Job_Grades'
			from  [HumanResources].[EmployeePayHistory] e_pay join [HumanResources].[Employee] e
			on e_pay.EmployeeID = e.EmployeeID;
		
select * from Employees_View;

-- Creating procedure with two parameters, by department and hired year.

Alter proc emp_dept @department nvarchar(20) = 'Marketing', @year1 int ='2000'
as
select v.*, cast(e3.HireDate as date) as Hire_Date, year(e3.HireDate) as Hired_Year
from Employees_View v join HumanResources.Employee e3
on v.EmployeeID = e3.EmployeeID
where Department = @department and year(e3.HireDate)=@year1
Order by LastName;

exec emp_dept Production;

