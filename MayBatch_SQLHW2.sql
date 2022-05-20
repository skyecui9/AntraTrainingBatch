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
