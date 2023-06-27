use mintclassics;
select * from products;

-- top 5 customer dengan total penjualan dan total pemesanan terbanyak
select c.customerNumber, customerName, sum(amount) as Total_Sales, sum(orderNumber) as Total_Order
from orders as o
inner join customers as c on o.customerNumber = c.customerNumber
inner join payments as p on c.customerNumber = p.customerNumber
group by 2 order by 3 desc limit 5;

-- top 5 kota dengan total penjualan dan total pemesanan terbanyak
select city, country, sum(amount) as Total_Sales, sum(orderNumber) as Total_Order
from orders as o 
inner join customers as c on o.customerNumber = c.customerNumber
inner join payments as p on c.customerNumber = p.customerNumber
group by 1 order by 3 desc limit 5;

-- Product line berdasarkan penjualan dan pemesanan terbanyak
select pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from products as pp
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
group by 1 order by 2 desc;
--
-- top 10 product berdasarkan total penjualan dan total pemesanan paling tinggi
select productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from products as pp
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
group by 1 order by 3 desc, 4 desc limit 10;

-- top 10 product berdasarkan total penjualan dan total pemesanan paling rendah
select productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from products as pp
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
group by 1 order by 3 asc, 4 asc limit 10;


-- melihat ada produk apa pada saja pada tiap warehouse
select distinct pp.productLine
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode
where w.warehouseName = 'South';



-- North: Motorcycles, Planes
-- West: Vintage Cars
-- East: Classic Cars
-- South: Train, Trucks and Buses, and Ships

-- melihat warehouse berdasarkan penjualan dan pemesanan
select w.warehouseName, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
group by 1 order by 2 desc, 3 desc;

-- melihat warehouse berdasarkan penjualan dan pemesanan product line
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
group by 2 order by 4 desc, 5 desc limit 10;

-- ---------------------------------------------------------------------------------------

-- ANALISIS WAREHOUSE NORTH
-- Produk pada warehouse North berdasarkan total penjualan dan pemesanan terbanyak
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
where w.warehouseName = 'North'
group by 2 order by 4 desc, 5 desc limit 10;

-- Produk pada warehouse North berdasarkan total penjualan dan pemesanan paling rendah
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
where w.warehouseName = 'North'
group by 2 order by 4 asc, 5 asc limit 10;

-- melihat stok barang di warehouse North
select w.warehouseName, pp.productName, pp.productLine, pp.quantityInStock
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode 
where w.warehouseName = 'North'
order by 4 desc limit 10;

select w.warehouseName, pp.productName, pp.productLine, pp.quantityInStock
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode 
where w.warehouseName = 'North'
order by 4 asc limit 10;

-- ANALISIS WAREHOUSE WEST
-- Produk pada warehouse West berdasarkan total penjualan dan pemesanan terbanyak
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
where w.warehouseName = 'West'
group by 2 order by 4 desc, 5 desc limit 10;

-- Produk pada warehouse West berdasarkan total penjualan dan pemesanan paling rendah
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
where w.warehouseName = 'West'
group by 2 order by 4 asc, 5 asc limit 10;

-- melihat stok barang di warehouse West
select w.warehouseName, pp.productName, pp.productLine, pp.quantityInStock
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode 
where w.warehouseName = 'West'
order by 4 desc limit 10;

select w.warehouseName, pp.productName, pp.productLine, pp.quantityInStock
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode 
where w.warehouseName = 'West'
order by 4 asc limit 10;

-- ANALISIS WAREHOUSE East
-- Produk pada warehouse East berdasarkan total penjualan dan pemesanan terbanyak
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
where w.warehouseName = 'East'
group by 2 order by 4 desc, 5 desc limit 10;

-- Produk pada warehouse East berdasarkan total penjualan dan pemesanan paling rendah
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
where w.warehouseName = 'East'
group by 2 order by 4 asc, 5 asc limit 10;

-- melihat stok barang di warehouse East
select w.warehouseName, pp.productName, pp.productLine, pp.quantityInStock
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode 
where w.warehouseName = 'East'
order by 4 desc limit 10;

select w.warehouseName, pp.productName, pp.productLine, pp.quantityInStock
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode 
where w.warehouseName = 'East'
order by 4 asc limit 10;

-- ANALISIS WAREHOUSE South
-- Produk pada warehouse South berdasarkan total penjualan dan pemesanan terbanyak
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
where w.warehouseName = 'South'
group by 2 order by 4 desc, 5 desc limit 10;

-- Produk pada warehouse South berdasarkan total penjualan dan pemesanan paling rendah
select w.warehouseName, productName, pp.productLine, sum(amount) as Total_Sales, sum(od.orderNumber) as Total_Order
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
inner join orders as o on od.orderNumber = o.orderNumber
inner join payments as p on o.customerNumber = p.customerNumber
where w.warehouseName = 'South'
group by 2 order by 4 asc, 5 asc limit 10;

-- melihat stok barang di warehouse South
select w.warehouseName, pp.productName, pp.productLine, pp.quantityInStock
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode 
where w.warehouseName = 'South'
order by 4 desc limit 10;

select w.warehouseName, pp.productName, pp.productLine, pp.quantityInStock
from products as pp inner join warehouses as w on pp.warehouseCode = w.warehouseCode 
where w.warehouseName = 'South'
order by 4 asc limit 10;

-- --------------------------------------------------
select warehouseName, productName, productLine, (priceEach - buyPrice) as profit
from warehouses as w
inner join products as pp on w.warehouseCode = pp.warehouseCode
inner join orderdetails as od on pp.productCode = od.productCode
where w.warehouseName = 'South'
group by 2 order by 4 asc limit 10;

select productName, productLine, (priceEach - buyPrice) as profit
from products as pp
inner join orderdetails as od on pp.productCode = od.productCode
group by 1 order by 3 asc limit 5;


