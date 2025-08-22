--remove duplicates

select orderID,
case 
when shipping_date is null then 'pending'
else 'shipped'
end as current_status
from orders;

alter table orders
drop column shipping_date;

select * from orders;

select 
case
when couponcode is null or trim(couponcode) = '' then 'no code'
else couponcode
end as coupon_code
from orders;


update orders
set couponcode = 'no code'
where couponcode is null or trim(couponcode) = '' ;

select * from orders;
  
  
##this is to check the duplicates in order id
select  *
FROM orders
WHERE orderID IN (
  SELECT orderID
  FROM orders
  GROUP BY orderID
  HAVING COUNT(*) > 1
);
##no duplicates found

select trim(shipping_add) as shipping_address
from orders;

select 
orderID, customerID, order_date,
row_number() over (partition by customerID order by order_date) as order_rank
from orders;

## CTE for delivered orders
with delivered_orders as(
select * from orders
where orderstatus = 'delivered'
)
select product, count(*) as delivered_count
from delivered_orders
group by product;


## multiple cte for delivered orders and top products.
with delivered_orders as(
select * from orders where orderstatus = 'delivered'
),
top_products as(
select product, count(*) as delivered_count
from delivered_orders
group by product
order by delivered_count desc
limit 5
)
select * from top_products;

--- 📈 Which product generates the most revenue?
select product, sum(totalprice) as revenue
from orders
group by product
order by revenue desc;
--- chair generates the most revenue.

--- 🧾 Which payment method is most used for high-value orders?
select payment_method, count(*) as count
from orders 
where totalprice > 1000
group by payment_method
order by count desc;

--- 🧍 Top 5 customers by total spend
select customerID, sum(totalprice) as total_spend
from orders
group by customerID
order by total_spend desc
limit 5;










