-- inspecting dataset
use PortofolioDB;
SELECT * FROM sales_data_sample;

-- checking the unique values from column
select distinct STATUS from sales_data_sample; -- nice to vizz
select distinct YEAR_ID from sales_data_sample; 
select distinct PRODUCTLINE from sales_data_sample;
select distinct COUNTRY from sales_data_sample; -- nice to vizz
select distinct TERRITORY from sales_data_sample;
select distinct DEALSIZE from sales_data_sample;

-- Analysis
-- Grouping Sales by Product Line
select PRODUCTLINE, SUM(SALES) as REVENUE from sales_data_sample
group by PRODUCTLINE
order by 2 desc;
-- [dari hasilnya dapat dilihat bahwa classic cars adalah product line dengan revenue paling tinggi]

-- Grouping Sales by Year
select YEAR_ID, sum(SALES) as REVENUE from sales_data_sample
group by YEAR_ID
order by 2 desc;
-- [dapat dilihat bahwa tahun 2004 adalah yang paling tinggi, dan tahun 2005 adalah yang paling rendah]

-- Look at the year 2005, in what month did the sales take place
select distinct MONTH_ID from sales_data_sample
where YEAR_ID = 2003;
-- [dapat dilihat bahwa penjualan dilakukan hanya 5 bulan pd 2005, berbeda dengan 2003 dan 2004 (12 bulan)]

-- Grouping Sales by Dealsize
select DEALSIZE, sum(SALES) as REVENUE from sales_data_sample
group by DEALSIZE
order by 2 desc;
-- [dapat dilihat bahwa Medium adalah yang paling tinggi dan large adalah yang paling rendah]

-- In what month the sales number at highest in year of 2004?
select MONTH_ID, sum(SALES) as REVENUE, count(ORDERNUMBER) as ORDER_NUMBER from sales_data_sample
where YEAR_ID = 2004
group by MONTH_ID
order by 2 desc;
-- [3 bulan dengan revenue paling tinggi adalah bulan Nov, Okt, dan Ags]

-- What productline sold the most in November 2004?
select MONTH_ID, PRODUCTLINE, sum(SALES) as REVENUE, count(ORDERNUMBER) as ORDER_NUMBER from sales_data_sample
where MONTH_ID = 11 and YEAR_ID = 2004
group by MONTH_ID, PRODUCTLINE
order by 3 desc;
-- [ classic cars dan vintage cars adalah 2 produk dengan revenue tertinggi pada Nov 2004]

-- RFM (recency-frequency-monetary) ANALYSIS -> indexing technique to segment customers
-- recency (last order), freq (count of total order), monetary (total money spent)
with rfm as
(
	select CUSTOMERNAME, sum(sales) as MonetaryValue, avg(sales) as AvgMonetaryValue, count(ORDERNUMBER) as Frequency,
	max(ORDERDATE) as last_order_date, (select max(ORDERDATE) from sales_data_sample) as max_order_date, 
	DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from sales_data_sample)) as Recency
	from sales_data_sample
	group by CUSTOMERNAME
)
select *,
	NTILE(4) OVER (order by Recency desc) as rfm_recency,
    NTILE(4) OVER (order by Frequency) as rfm_frequency,
    NTILE(4) OVER (order by AvgMonetaryValue) as rfm_monetary
from rfm;
-- [dari output tersebut dapat dilihat beberapa customer mempunyai tingkat recency yang rendah, siapa saja mereka?]

-- Customer who have transaction 5 days ago?
with rfm as
(
	select CUSTOMERNAME, sum(sales) as MonetaryValue, avg(sales) as AvgMonetaryValue, count(ORDERNUMBER) as Frequency,
	max(ORDERDATE) as last_order_date, (select max(ORDERDATE) from sales_data_sample) as max_order_date, 
	DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from sales_data_sample)) as Novelty
	from sales_data_sample
	group by CUSTOMERNAME
)
select * from rfm
where Novelty < 5;
-- [terdapat 6 customer dgn tingkat recency < 5, yaitu Euro shopping channel, mini gifts dist ltd, petit auto, dll]

-- coba
DROP TABLE IF EXISTS #rfm
;with rfm as
(
	select CUSTOMERNAME, sum(sales) as MonetaryValue, avg(sales) as AvgMonetaryValue, count(ORDERNUMBER) as Frequency,
	max(ORDERDATE) as last_order_date, (select max(ORDERDATE) from sales_data_sample) as max_order_date, 
	DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from sales_data_sample)) as Recency
	from sales_data_sample
	group by CUSTOMERNAME
),
rfm_calc as
(
	select r.*,
		NTILE(4) OVER (order by Recency) as rfm_recency,
		NTILE(4) OVER (order by Frequency) as rfm_frequency,
		NTILE(4) OVER (order by AvgMonetaryValue) as rfm_monetary
	from rfm r
)
select *, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
concat(rfm_recency,rfm_frequency,rfm_monetary) as rfm_cell_string
into #rfm
from rfm_calc;

select * from #rfm;
-- [semakin kecil rfm_recency -> masih baru membeli (semakin kecil semakin baik)]
-- [semakin besar rfm_frequency -> frek. beli semakin besar (semakin besar semakin baik)]
-- [semakin besar rfm_monetary -> spending makin bsar (semakin besar semakin baik)]

-- lost customer -> mid freq or mid monetary, and havenot purchase lately
-- slipping away, cannot lose -> high freq, or big spender, but not purchase lately
-- new customer -> purchase lately, low frequency
-- aktif -> purchase lately, mid or high freq, and low or mid monetary
-- loyal -> purchase lately, mid or high freq, high monetary

select CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,
	case 
		when rfm_cell_string in (311, 312, 313, 314, 321, 322, 411, 412, 413, 414, 421, 422, 423, 431) then 'lost_customers'
		when rfm_cell_string in (323, 324, 331, 332, 333, 334, 341, 342, 343, 344, 424, 432, 433, 434, 441, 442, 443, 444) then 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
		when rfm_cell_string in (111, 112, 113, 114, 121, 122, 123, 211, 212, 213, 214, 221, 222) then 'new customers'
		when rfm_cell_string in (124, 131, 132, 141, 142, 223, 231, 232, 241, 242) then 'active' --(Customers who buy often & recently, but at low price points)
		when rfm_cell_string in (133, 134, 143, 144, 224, 233, 234, 243, 244) then 'loyal'
	end rfm_segment

from #rfm;

-- analisis: penjualan di kota-kota tertentu
-- which city has the highest revenue in UK?
select CITY, sum(SALES) as Revenue from sales_data_sample
where COUNTRY = 'UK'
group by CITY
order by 2 desc;
-- [ dapat dilihat bahwa manchester adalah kota dengan penjualan yang paling tinggi di UK]

-- apa produk dengan penjualan terbaik di UK pada tahun 2004?
select COUNTRY, YEAR_ID, PRODUCTLINE, sum(SALES) as Revenue from sales_data_sample
where COUNTRY = 'UK' and YEAR_ID = 2004
group by COUNTRY, PRODUCTLINE, YEAR_ID
order by 4 desc;
-- [ dapat dilihat bahwa pada tahun 2004, classic cars dan vintage cars adalah produk yg paling banyak di jual di UK.
select * from sales_data_sample;

-- what productline has the highest revenue in 2004?
select CITY, YEAR_ID, PRODUCTLINE, sum(SALES) as Revenue from sales_data_sample
where CITY = 'Manchester' and YEAR_ID = 2004
group by CITY, YEAR_ID, PRODUCTLINE
order by 4 desc;
-- [ sama seperti di UK, dapat dilihat bahwa pada tahun 2004, di Manchester juga adalah classic cars dan vintage cars sbg produk dengan penjualan tertinggi.

select * from sales_data_sample;