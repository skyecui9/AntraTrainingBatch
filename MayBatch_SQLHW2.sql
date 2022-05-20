USE AdventureWorks2019
GO

/*1. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. 
Join them and produce a result set similar to the following.
 Country                        Province*/
 SELECT pc.Name 'Country', ps.Name 'Province' FROM person.CountryRegion pc 
	JOIN person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode
		ORDER BY pc.Name

/*2. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the 
countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
Country                        Province*/
 SELECT pc.Name 'Country', ps.Name 'Province' FROM person.CountryRegion pc 
	JOIN person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode
		WHERE pc.Name IN ('Germany', 'Canada')
			ORDER BY pc.Name

 --Using Northwind Database: (Use aliases for all the Joins)
 USE Northwind
 GO

--3. List all Products that has been sold at least once in last 25 years.
SELECT p.ProductName FROM Products p
	WHERE p.ProductID IN(
		SELECT od.ProductID FROM [Order Details] od
			WHERE od.OrderID IN(
				SELECT o.OrderID from Orders o
					Where o.OrderDate > '1997-05-19'))

--4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode, COUNT(o.ShipPostalCode) ZipCount FROM Orders o  
	WHERE o.OrderDate > '1997-05-19'
		GROUP BY o.ShipPostalCode
			Order by ZipCount DESC

--5. List all city names and number of customers in that city.     
SELECT O.ShipCity, COUNT(DISTINCT o.CustomerID) NumberofCustomers FROM Orders o
	GROUP BY o.ShipCity
	
--6. List city names which have more than 2 customers, and number of customers in that city
SELECT O.ShipCity, COUNT(DISTINCT o.CustomerID) NumberofCustomers FROM Orders o
	GROUP BY o.ShipCity
		HAVING COUNT(DISTINCT o.CustomerID) > 2
			ORDER BY NumberofCustomers DESC

--7. Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, SUM(od.Quantity) CountofProducts
	FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
		JOIN [Order Details] od ON o.OrderID = od.OrderID
		GROUP BY c.ContactName
			ORDER BY CountofProducts DESC

--8. Display the customer ids who bought more than 100 Products with count of products.
SELECT o.CustomerID, SUM(od.Quantity) CountofProducts
	FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
		GROUP BY o.CustomerID
			HAVING SUM(od.Quantity) > 100
				ORDER BY CountofProducts DESC

--9. List all of the possible ways that suppliers can ship their products. Display the results as below
    --Supplier Company Name                Shipping Company Name
SELECT DISTINCT su.CompanyName SupplierCompanyName, sh.CompanyName ShippingCompanyName
	FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
		JOIN Products p ON od.ProductID = p.ProductID
		JOIN Suppliers su ON p.SupplierID = su.SupplierID
		JOIN Shippers sh ON o.ShipVia = sh.ShipperID
			ORDER BY su.CompanyName

--10. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
	FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
		JOIN Products p ON od.ProductID = p.ProductID
			ORDER BY o.OrderDate DESC


--11. Displays pairs of employees who have the same job title. ???
SELECT e.FirstName + '  '+ e.LastName EmployeeName FROM Employees e
	WHERE e.Title IN (
		SELECT e2.Title FROM Employees e2
			GROUP BY e2.Title
				HAVING COUNT(e2.Title) >= 2)



--12. Display all the Managers who have more than 2 employees reporting to them.
SELECT e.FirstName + '  '+ e.LastName ManagerName FROM Employees e
	WHERE e.EmployeeID IN(
		SELECT e2.ReportsTo FROM Employees e2
			GROUP BY e2.ReportsTo
				HAVING COUNT(e2.ReportsTo) >2)

--13. Display the customers and suppliers by city. The results should have the following columns ???
/*
City
Name
Contact Name
Type (Customer or Supplier)
*/

SELECT c.City, c.CompanyName, c.ContactName, 'Customers' PartnerType FROM Customers c
UNION 
SELECT s.City, s.CompanyName, s.ContactName, 'Suppliers' PartnerType FROM Suppliers s

--14. List all cities that have both Employees and Customers.
SELECT DISTINCT c.City FROM Customers c
	WHERE c.City IN(
		SELECT e.City FROM Employees e)

--15. List all cities that have Customers but no Employee.
--a. Use sub-query
SELECT DISTINCT c.City FROM Customers c
	WHERE c.City NOT IN(
		SELECT e.City FROM Employees e)

--b. Do not use sub-query
SELECT DISTINCT c.City FROM Customers c 
	LEFT JOIN Employees e ON c.City = e.City
		WHERE e.EmployeeID IS NULL

--16. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(od.Quantity) TotalOrderQuantities FROM [Order Details] od 
	JOIN Products p ON od.ProductID = p.ProductID
		GROUP BY p.ProductName
			ORDER BY TotalOrderQuantities DESC
