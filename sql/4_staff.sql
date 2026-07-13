-- 4.1
drop temporary table if exists TEMP_STAFF;
create temporary table TEMP_STAFF as
select T3.staff_id,
	concat(T3.first_name,' ',T3.last_name) as staff_name,
	T3.store_id,
	round(sum(T1.quantity * T1.list_price * (1-T1.discount)),2) as total_revenue,
	count(distinct T2.order_id) as total_orders
from order_items T1
join orders T2
on T1.order_id = T2.order_id
join staffs T3
on T2.staff_id = T3.staff_id
group by T3.staff_id, staff_name, T3.store_id;
drop temporary table if exists TEMP_STORE;
create temporary table TEMP_STORE as
select store_id,
	sum(total_revenue) as store_revenue
from TEMP_STAFF
group by store_id;
select T1.staff_name, T1.store_id, T1.total_revenue, T1.total_orders,
	round(T1.total_revenue * 100 / T2.store_revenue,2) as pct_of_store
from TEMP_STAFF T1
join TEMP_STORE T2
on T1.store_id = T2.store_id
order by T1.store_id, T1.total_revenue desc

-- 4.2
drop temporary table if exists TEMP_AVG;
create temporary table TEMP_AVG as
select store_id,
	avg(total_revenue) as avg_revenue
from TEMP_STAFF
group by store_id;
select T1.staff_name, T1.store_id, T1.total_revenue, T2.avg_revenue,
	case when T1.total_revenue > T2.avg_revenue then 'above'
	when T1.total_revenue < T2.avg_revenue then 'below'
	else 'equal'
	end as compare
from TEMP_STAFF T1
join TEMP_AVG T2
on T1.store_id = T2.store_id
order by T1.store_id, T1.total_revenue desc

-- 4.3
select
	concat(T2.first_name,' ',T2.last_name) as staff_name,
	sum(case when T1.shipped_date <= T1.required_date then 1 else 0 end) as on_time,
	sum(case when T1.shipped_date > T1.required_date then 1 else 0 end) as late
from orders T1
join staffs T2
on T1.staff_id = T2.staff_id
where T1.shipped_date is not null
group by staff_name

-- 4.4
select T2.store_name,
	count(T1.staff_id) as staff_active,
	T3.store_revenue
from staffs T1
join stores T2
on T1.store_id = T2.store_id
join TEMP_STORE T3
on T1.store_id = T3.store_id
where T1.active = 1
group by T2.store_name, T3.store_revenue