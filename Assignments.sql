--1.List of Persons’ full name, all their fax and phone numbers, as well as the phone number and fax of the company they are working for (if any). 
Select FullName,PhoneNumber, FaxNumber From Application.People 
Union All
Select CustomerName,PhoneNumber, FaxNumber From Sales.Customers Where CustomerCategoryID = 1

--2.If the customer's primary contact person has the same phone number as the customer’s phone number, list the customer companies. 
Select a.CustomerName From Sales.Customers as a
left Join Application.People as b on a.PrimaryContactPersonID = b.PersonID
where a.PhoneNumber = b.PhoneNumber

-- 3.List of customers to whom we made a sale prior to 2016 but no sale since 2016-01-01.
Select  c.CustomerName From Sales.Customers as c
Left Join Sales.Orders as o on c.CustomerID = o.CustomerID
And o.OrderDate>= '2016-01-01'
Where o.CustomerID is null

-- 4.List of Stock Items and total quantity for each stock item in Purchase Orders in Year 2013.
Select a.StockItemID,SUM(a.QuantityPerOuter) as "Total Quantity"
From Warehouse.StockItems a
Left Join Warehouse.StockItemTransactions b on a.StockItemID = b.StockItemID
Left Join Purchasing.PurchaseOrders c on b.PurchaseOrderID = c.PurchaseOrderID
Where Year(OrderDate) = 2013
Group by a.StockItemID 
Order by StockItemID Asc
