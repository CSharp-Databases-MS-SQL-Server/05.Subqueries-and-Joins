--01. Employee Address
SELECT TOP(5) e.EmployeeID, e.JobTitle, 
			  a.AddressID, a.AddressText
	FROM Employees AS e
	LEFT JOIN Addresses AS a
	ON e.AddressID = a.AddressID
	ORDER BY a.AddressID


--02. Addresses with Towns
SELECT TOP(50) Employees.FirstName, 
			   Employees.LastName,
			   Towns.Name AS Town,
			   Addresses.AddressText
	FROM Employees
	JOIN Addresses ON Employees.AddressID = Addresses.AddressID
	JOIN Towns ON Addresses.TownID = Towns.TownID
		ORDER BY FirstName, LastName


--03. Sales Employees
SELECT 
	   e.EmployeeID,
	   e.FirstName,
	   e.LastName,
	   d.Name AS DepartmentName
	FROM Employees AS e
	LEFT JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Sales'


--04. Employee Departments
SELECT TOP(5)
		e.EmployeeID,
		e.FirstName,
		e.Salary,
		d.Name AS DepartmentName
	FROM Employees AS e
	LEFT JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE Salary > 15000
	ORDER BY e.DepartmentID


--05. Employees Without Projects
SELECT TOP(3)
		e.EmployeeID, e.FirstName
	FROM Employees AS e
	LEFT JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	WHERE ep.EmployeeID IS NULL
	ORDER BY e.EmployeeID


--06. Employees Hired After
SELECT 
		e.FirstName,
		e.LastName,
		e.HireDate,
		d.Name AS DeptName
	FROM Employees AS e
	LEFT JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE HireDate > '1.1.1999' AND d.Name = 'Sales' OR d.Name = 'Finance'
	ORDER BY HireDate


--07. Employees With Project
SELECT TOP(5)
		e.EmployeeID,
		e.FirstName,
		p.Name AS ProjectName
	FROM Employees AS e
	INNER JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	INNER JOIN Projects AS p
	ON ep.ProjectID = p.ProjectID
	WHERE p.StartDate > '08.13.2002' AND p.EndDate IS NULL
	ORDER BY e.EmployeeID



--08. Employee 24
SELECT 
		e.EmployeeID,
		e.FirstName,
		CASE
			WHEN YEAR(p.StartDate) >= 2005 THEN NULL
			ELSE p.Name
		END AS ProjectName
	FROM Employees AS e
	LEFT JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	LEFT JOIN Projects AS p
	ON ep.ProjectID = p.ProjectID
	WHERE e.EmployeeID = 24
 

 --09. Employee Manager
SELECT 
		e1.EmployeeID,
		e1.FirstName,
		e1.ManagerID,
		e2.FirstName AS ManagerName
	FROM Employees e1
	LEFT JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID 
		WHERE e1.ManagerID IN (3, 7)
		ORDER BY e1.EmployeeID

--10. Employees Summary
SELECT TOP(50)
		e1.EmployeeID,
		e1.FirstName + ' ' + e1.LastName AS EmployeeName,
		e2.FirstName + ' ' + e2.LastName AS ManagerName,
		d.Name AS DepartmentName
	FROM Employees AS e1
	LEFT JOIN Departments AS d
	ON e1.DepartmentID = d.DepartmentID
	LEFT JOIN Employees e2
	ON e1.ManagerID = e2.EmployeeID
	ORDER BY e1.EmployeeID


--11. Min Average Salary
SELECT TOP(1) AVG(Salary) AS MinAverageSalary  
	FROM Employees
		GROUP BY DepartmentID
		ORDER BY MinAverageSalary  