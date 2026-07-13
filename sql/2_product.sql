-- 2.1
-- List 1
select T1.product_name, round(sum(T2.quantity * T2.list_price * (1-T2.discount)),2) as total_revenue
from products T1
join order_items T2
on T1.product_id = T2.product_id
group by T1.product_name
order by total_revenue desc
limit 10
-- List 2
select T1.product_name, sum(T2.quantity) as total_quantity
from products T1
join order_items T2
on T1.product_id = T2.product_id
group by T1.product_name
order by total_quantity desc
limit 10

-- 2.2
select T3.category_name,
	round(sum(T2.quantity * T2.list_price * (1-T2.discount)),2) as total_revenue,
	sum(T2.quantity) as total_quantity
from products T1
join order_items T2
on T1.product_id = T2.product_id
join categories T3
on T1.category_id = T3.category_id
group by T3.category_name 

-- 2.3
select T1.brand_name,
	count(T2.product_id) as model_count
from brands T1
join products T2
	on T1.brand_id = T2.brand_id
group by T1.brand_name;
select T3.brand_name,
	sum(T1.quantity * T1.list_price * (1-T1.discount)) as total_revenue
from order_items T1
join products T2
on T1.product_id = T2.product_id
join brands T3
on T2.brand_id = T3.brand_id
group by T3.brand_name 

-- 2.4
select T2.model_year,
	year(T3.order_date) as year_sold,
	round(sum(T1.quantity * T1.list_price * (1-T1.discount)),2) as total_revenue,
	case when sum(T1.quantity * T1.list_price * (1-T1.discount)) < 500000 then 0
		else 1
	end as active
from order_items T1
join products T2
on T1.product_id = T2.product_id
join orders T3
on T1.order_id = T3.order_id
group by T2.model_year, year(T3.order_date)
order by T2.model_year, year_sold

-- 2.5
select T1.product_id, T1.product_name
from products T1
left join order_items T2
on T1.product_id = T2.product_id
where T2.product_id is null 

-- 2.6
select T3.category_name, round(avg(T1.discount) * 100,2) as avg_discount
from order_items T1
join products T2
on T1.product_id = T2.product_id
join categories T3
on T2.category_id = T3.category_id
group by T3.category_name