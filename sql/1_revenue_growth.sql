-- 1.1
select
	year(T1.order_date) as order_year,
	round(sum(T2.quantity * T2.list_price * (1-T2.discount)),2) as total_revenue
from orders T1
join order_items T2
on T1.order_id = T2.order_id
group by year (T1.order_date)
order by order_year

-- 1.2
select T1.store_id
	,year(T1.order_date) as order_year
	,month(T1.order_date) as order_month
	,round(sum(T2.quantity * T2.list_price * (1-T2.discount)),2) as revenue
from orders T1
join order_items T2
on T1.order_id = T2.order_id
group by T1.store_id, year(T1.order_date), month(T1.order_date)
order by T1.store_id, order_year, order_month 

-- 1.3
drop temporary table if exists TEMP1;
create temporary table TEMP1 as 
select T1.store_id
	,year(T1.order_date) as order_year
	,sum(T2.quantity * T2.list_price * (1-T2.discount)) as revenue
from orders T1
join order_items T2
on T1.order_id = T2.order_id
group by T1.store_id, year(T1.order_date);
drop temporary table if exists TEMP2;
create temporary table TEMP2 as 
select *
from TEMP1;
select 
	A.store_id
	,A.order_year
	,round(A.revenue,2) as current_revenue
	,round(B.revenue,2) as previous_revenue
	,round((A.revenue-B.revenue)/B.revenue * 100,2) as growth
from TEMP1 A
join TEMP2 B
on A.store_id = B.store_id
and A.order_year = B.order_year + 1
order by A.store_id, A.order_year

-- 1.4
drop temporary table if exists TEMP_TOTAL;
create temporary table TEMP_TOTAL as
select sum(quantity * list_price * (1 - discount)) as total_revenue
from order_items;
drop temporary table if exists TEMP_STORE;
create temporary table TEMP_STORE as
select T1.store_id, sum(T2.quantity * T2.list_price * (1 - T2.discount)) as store_revenue
from orders T1
join order_items T2 
on T1.order_id = T2.order_id
group by T1.store_id;
select
    T1.store_id,
    round(T1.store_revenue, 2) as store_revenue,
    round(T1.store_revenue / T2.total_revenue * 100, 2)  pct_of_total
from TEMP_STORE T1
join TEMP_TOTAL T2;

-- 1.5 
select case
	when month(T1.order_date) between 1 and 3 then 'Q1'
	when month (T1.order_date) between 4 and 6 then 'Q2'
	when month (T1.order_date) between 7 and 9 then 'Q3'
	else 'Q4'
	end as quarter
	,round(sum(T2.quantity * T2.list_price * (1-T2.discount)),2) as revenue
from orders T1
join order_items T2
on T1.order_id = T2.order_id
group by quarter
order by revenue desc	