--1.All customers(names), and their postal cities, which brought more than 2000 "toys"(as stock group) in 2016
select c.CustomerName, c.PostalPostalCode
from Sales.Customers c 
join Sales.Orders o on c.CustomerID = o.CustomerID
join Sales.OrderLines ol on o.OrderID = ol.OrderID and YEAR(o.OrderDate) = 2016		
where ol.StockItemID  in
(select sisg.StockItemID
from Warehouse.StockItemStockGroups sisg where StockGroupID = 9)
group by c.CustomerName, c.PostalPostalCode
having SUM(ol.Quantity)>2000

--2.All stockitems that in the year of 2016, we imported more than we sold, with the numbers of importing and sales 
--select top 10* from Purchasing.PurchaseOrders
--select top 10* from Purchasing.PurchaseOrderLines
--select top 10* from Sales.Orders
--select top 10* from Sales.OrderLines
--select top 10* from Warehouse.StockItems

with Purchases
as
(
select si.StockItemID, si.StockItemName, SUM(pl.OrderedOuters*si.QuantityPerOuter) as "TotalQuantity"
from Purchasing.PurchaseOrders p
join Purchasing.PurchaseOrderLines pl on p.PurchaseOrderID = pl.PurchaseOrderID and YEAR(p.OrderDate) = 2016
join Warehouse.StockItems si on pl.StockItemID = si.StockItemID
group by si.StockItemID, si.StockItemName
),
Sales
as
(
select si.StockItemID, si.StockItemName, SUM(ol.Quantity) as "TotalQuantity"
from Sales.Orders o
join Sales.OrderLines ol on o.OrderID = ol.OrderID and YEAR(o.OrderDate) = 2016
join Warehouse.StockItems si on ol.StockItemID = si.StockItemID
group by si.StockItemID, si.StockItemName
)
select Purchases.StockItemID, Purchases.StockItemName
from Purchases
join Sales on Purchases.StockItemID = Sales.StockItemID
where Purchases.TotalQuantity < Sales.TotalQuantity
 
--3.All potiential loss of profit resulted from our 'Special Deals'(sum of discounted price over all sales of that product at that time)
--Use subqueries
-- select top 10 * from Sales.Invoices
-- select top 10 * from Sales.InvoiceLines
-- select top 10 * from Sales.SpecialDeals

 select sd.StockItemID, SUM(ol.UnitPrice * ol.Quantity * sd.DiscountPercentage)
 from Sales.OrderLines ol
 join Sales.SpecialDeals sd on ol.StockItemID = sd.StockItemID
 join Sales.Orders o on o.OrderID = ol.OrderID
 where o.OrderDate between sd.StartDate and sd.EndDate
 group by sd.StockItemID

