--CREATE TABLE regions (
--	region_id INT IDENTITY(1,1) PRIMARY KEY,
--	region_name VARCHAR (25) DEFAULT NULL
--);

--CREATE TABLE countries (
--	country_id CHAR (2) PRIMARY KEY,
--	country_name VARCHAR (40) DEFAULT NULL,
--	region_id INT NOT NULL,
--	FOREIGN KEY (region_id) REFERENCES regions (region_id) ON DELETE CASCADE ON UPDATE CASCADE
--);

--CREATE TABLE locations (
--	location_id INT IDENTITY(1,1) PRIMARY KEY,
--	street_address VARCHAR (40) DEFAULT NULL,
--	postal_code VARCHAR (12) DEFAULT NULL,
--	city VARCHAR (30) NOT NULL,
--	state_province VARCHAR (25) DEFAULT NULL,
--	country_id CHAR (2) NOT NULL,
--	FOREIGN KEY (country_id) REFERENCES countries (country_id) ON DELETE CASCADE ON UPDATE CASCADE
--);

--CREATE TABLE jobs (
--	job_id INT IDENTITY(1,1) PRIMARY KEY,
--	job_title VARCHAR (35) NOT NULL,
--	min_salary DECIMAL (8, 2) DEFAULT NULL,
--	max_salary DECIMAL (8, 2) DEFAULT NULL
--);

--CREATE TABLE departments (
--	department_id INT IDENTITY(1,1) PRIMARY KEY,
--	department_name VARCHAR (30) NOT NULL,
--	location_id INT DEFAULT NULL,
--	FOREIGN KEY (location_id) REFERENCES locations (location_id) ON DELETE CASCADE ON UPDATE CASCADE
--);

--CREATE TABLE employees (
--	employee_id INT IDENTITY(1,1) PRIMARY KEY,
--	first_name VARCHAR (20) DEFAULT NULL,
--	last_name VARCHAR (25) NOT NULL,
--	email VARCHAR (100) NOT NULL,
--	phone_number VARCHAR (20) DEFAULT NULL,
--	hire_date DATE NOT NULL,
--	job_id INT NOT NULL,
--	salary DECIMAL (8, 2) NOT NULL,
--	manager_id INT DEFAULT NULL,
--	department_id INT DEFAULT NULL,
--	FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE ON UPDATE CASCADE,
--	FOREIGN KEY (department_id) REFERENCES departments (department_id) ON DELETE CASCADE ON UPDATE CASCADE,
--	FOREIGN KEY (manager_id) REFERENCES employees (employee_id)
--);

--CREATE TABLE dependents (
--	dependent_id INT IDENTITY(1,1) PRIMARY KEY,
--	first_name VARCHAR (50) NOT NULL,
--	last_name VARCHAR (50) NOT NULL,
--	relationship VARCHAR (25) NOT NULL,
--	employee_id INT NOT NULL,
--	FOREIGN KEY (employee_id) REFERENCES employees (employee_id) ON DELETE CASCADE ON UPDATE CASCADE
--);

--SELECT * FROM dependents
--SELECT * FROM jobs
--SELECT * FROM employees
--SELECT * FROM departments


-- INNER JOIN - EMPLOYEES HIRED ON OR AFTER 1990 AND SORTING BY HIRED DATE FIELD
Use Employee_DB
SELECT 
	d.department_name, 
	e.first_name, e.last_name, e.salary, 
	e.hire_date 
 FROM employees e
INNER JOIN 
departments d ON e.department_id = d.department_id
where e.hire_date >= '01-01-1990'
ORDER BY 4

--select * from employees
--select * from departments


-- CALCULATING THE STAFF SALARY EXPENSES FOR EACH DEPARTMENT USING INNER JOIN

SELECT departments.department_name,departments.department_id, 
SUM(employees.salary) as Employee_Sal
FROM departments
Inner Join
employees ON departments.department_id = employees.department_id
GROUP BY departments.department_name, departments.department_id
ORDER BY 3


-- FINDING THE 2nd highest SALARY USING SUBQUIRY

SELECT TOP 1 first_name, last_name, salary as max_sal
FROM employees
where salary < (select max(salary) as max_sal from employees)
order by 3 desc

-- Finding the 2nd and 3rd highest salary using window function

select top 1 * from (SELECT  first_name,last_name, salary, 
DENSE_RANK() OVER (ORDER BY SALARY DESC) AS d_rank
FROM employees) x
where x.d_rank in (2,3)






