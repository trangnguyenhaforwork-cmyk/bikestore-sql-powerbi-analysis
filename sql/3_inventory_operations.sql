-- 3.1
select T3.store_name, T2.product_name, T1.quantity
from stocks T1
join products T2
on T1.product_id = T2.product_id
join stores T3
on T1.store_id = T3.store_id
order by T3.store_name, T2.product_name

-- 3.2
drop temporary table if exists TEMP_STOCK;
create temporary table TEMP_STOCK as
select T2.product_name,
	sum(T1.quantity) as total_quantity
from stocks T1
join products T2
on T1.product_id = T2.product_id
group by T2.product_name;
drop temporary table if exists TEMP_GRAND;
create temporary table TEMP_GRAND as
select sum(total_quantity) as grand_total
from TEMP_STOCK;
select product_name, total_quantity,
	round(total_quantity * 100 / (select grand_total from TEMP_GRAND),2) as pct_of_total
from TEMP_STOCK
order by total_quantity desc;

-- 3.3
select T2.product_name,
	sum(case when T1.store_id = 1 then T1.quantity else 0 end) as santacruz_qty,
	sum(case when T1.store_id = 2 then T1.quantity else 0 end) as baldwin_qty,
	sum(case when T1.store_id = 3 then T1.quantity else 0 end) as rowlett_qty
from stocks T1
join products T2
on T1.product_id = T2.product_id
group by T2.product_name;

-- 3.4
select T2.store_name,
	sum(case when T1.shipped_date <= T1.required_date then 1 else 0 end) as on_time,
	sum(case when T1.shipped_date > T1.required_date then 1 else 0 end) as late
from orders T1
join stores T2
on T1.store_id = T2.store_id
where T1.shipped_date is not null
group by T2.store_name