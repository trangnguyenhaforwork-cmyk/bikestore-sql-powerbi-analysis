-- 5.1
drop temporary table if exists TEMP_CUST;
create temporary table TEMP_CUST as
select T2.store_id, T2.customer_id,
	round(sum(T1.quantity * T1.list_price * (1-T1.discount)),2) as revenue
from order_items T1
join orders T2
on T1.order_id = T2.order_id
group by T2.store_id, T2.customer_id;
drop temporary table if exists TEMP_COPY;
create temporary table TEMP_COPY as
select * from TEMP_CUST;
select *
from TEMP_CUST T1
where(
	select count(*)
	from TEMP_COPY T2
	where T2.store_id = T1.store_id
	and T2.revenue > T1.revenue
	) < 10
order by store_id,revenue desc;

drop temporary table if exists TEMP_CUS_CAT;
create temporary table TEMP_CUS_CAT as
select T5.category_name, T2.customer_id,
	round(sum(T1.quantity * T1.list_price * (1-T1.discount)),2) as revenue
from order_items T1
join orders T2
on T1.order_id = T2.order_id
join products T4
on T1.product_id = T4.product_id
join categories T5
on T4.category_id = T5.category_id
group by T5.category_name, T2.customer_id;
drop temporary table if exists TEMP_CUS_CAT_COPY;
create temporary table TEMP_CUS_CAT_COPY as
select * from TEMP_CUS_CAT;
select *
from TEMP_CUS_CAT T1
where (
	select count(*)
	from TEMP_CUS_CAT_COPY T2
	where T2.category_name = T1.category_name
	and T2.revenue > T1.revenue
	) < 10
order by category_name, revenue desc

-- 5.2
drop temporary table if exists TEMP_ACT;
create temporary table TEMP_ACT as
select customer_id,
	max(order_date) as last_order_date,
	count(distinct order_id) as total_orders
from orders
group by customer_id;
select min(order_date), max(order_date) 
-- Tính ra max: Lùi xuống 6 tháng để lấy mốc do lấy max = chỉ tính ai mua đúng hôm max mới là active
from orders;
select avg(total_orders)
from TEMP_ACT;
select *
	,case when last_order_date < '2018-06-28' then 'inactive'
	else 'active'
	end as status
	,case when total_orders >=2 then 'frequent'
	else 'infrequent'
	end as frequency
from TEMP_ACT

-- 5.3
select T2.customer_id,
	round(sum(T1.quantity * T1.list_price * (1-T1.discount)),2) as total_amt,
	avg(T1.quantity) as avg_qty_per_pur
from order_items T1
join orders T2
on T1.order_id = T2.order_id
group by T2.customer_id

-- ĐK KH VIP: Amt >= 3000, số đơn >=3
select T1.customer_id,
	round(sum(T2.quantity * T2.list_price * (1-T2.discount)),2) as total_amt,
	count(distinct T1.order_id) as total_orders
from orders T1
join order_items T2
on T1.order_id = T2.order_id
group by T1.customer_id
having round(sum(T2.quantity * T2.list_price * (1-T2.discount)),2) >= 3000
	and count(distinct T1.order_id) >= 3