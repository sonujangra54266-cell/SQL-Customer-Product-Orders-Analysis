CREATE TABLE customerss (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);

INSERT INTO customerss VALUES
(1, 'Amit', 'Delhi', '2023-01-10'),
(2, 'Riya', 'Mumbai', '2023-02-15'),
(3, 'Karan', 'Pune', '2023-03-20'),
(4, 'Neha', 'Delhi', '2023-04-05'),
(5, 'Rahul', 'Bangalore', '2023-05-12');

CREATE TABLE productss (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price INT
);

INSERT INTO productss VALUES
(101, 'Laptop', 'Electronics', 60000),
(102, 'Mobile', 'Electronics', 30000),
(103, 'Headphones', 'Accessories', 2000),
(104, 'Chair', 'Furniture', 5000),
(105, 'Desk', 'Furniture', 8000);

CREATE TABLE orderss (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
	 CONSTRAINT fk_customer
        FOREIGN KEY (customer_id) REFERENCES customerss(customer_id),
    CONSTRAINT fk_product
        FOREIGN KEY (product_id) REFERENCES productss(product_id)
   
);

INSERT INTO orderss VALUES
(1, 1, 101, 1, '2023-06-01'),
(2, 2, 102, 2, '2023-06-05'),
(3, 3, 103, 3, '2023-06-10'),
(4, 1, 104, 1, '2023-06-15'),
(5, 4, 101, 1, '2023-06-20'),
(6, 5, 105, 2, '2023-06-25');

select * from customerss;
select * from productss;
select * from orderss;

--BEGINNER SQL QUERIES

--Q1-Display record from customerss table
Select * From Customerss;

--Q2 Show customer names and cities only.
Select customer_name, city
from customerss;

--Q3 Find all products belonging to the Electronics category.
Select  product_name , category from productss 
where lower(category) = 'electronics';

--Q4 Count the total number of orders.
select sum(quantity)
from orderss;

--Q5 Find orders placed after 2023-06-10.
select * from orderss
where order_date > '2023-06-10';

--INTERMEDIATE SQL QUERRY

--Q6 Show each order with customer name and product name.
select c.customer_name,p.product_name,c.customer_id,
o.order_id,o.order_date,o.quantity
from orderss o
join 
customerss c
on o.customer_id = c.customer_id
 join 
productss p
on o.product_id = p.product_id;

--Q7 Calculate total amount for each order
select o.order_id, p.product_name,p.price , o.quantity,
(o.quantity*p.price) as total_amount
from orderss o
join 
productss p
on o.product_id = p.product_id;

--Q8 Find total sales for each product.
select p.product_name,
sum(o.quantity*p.price) as total_sales
from orderss o
join
productss p
on o.product_id = p.product_id
group by p.product_name
order by total_sales desc;

--Q9 Find total orders placed by each customer.
select c.customer_name,
count(o.order_id) as total_order
from customerss c
join
orderss o
on o.customer_id = c.customer_id
group by c.customer_name
order by total_order desc;

--Q10 List customers who placed more than 1 order.
select c.customer_name,
count(o.order_id) as total_orders
from orderss o
join 
customerss c
on o.customer_id = c.customer_id
group by c.customer_name
having count(o.order_id)> 1
order by total_orders;

--Aggregation & Group By

--Q11 Find category-wise total sales.
select p.category,
sum(p.price*o.quantity) as total_sales
from orderss o
join 
productss p
on o.product_id = p.product_id
group by p.category
order by  total_sales desc;

--Q12 Find average order value.
select
avg(order_value) as average_order_value
from(
select order_id,
sum(o.quantity*p.price) as order_value
from orderss o  
join productss p
on o.product_id = p.product_id
group by order_id
);

--Q13 Find the maximum priced product in each category.
select product_name,category,price
from productss 
where(category,price) in (
select category,max(price)
from productss 
group by category);

--Q14 Count how many customers belong to each city.
select city,
count(customer_id) as total_customer
from customerss 
group by city
order by total_customer;

 --Joins (Very Important)
--Q15 Display all customers with their orders (including customers with no orders).
select c.customer_name,c.customer_id,
o.order_id,o.quantity
from customerss c
left join
orderss o 
on c.customer_id = o.customer_id;

--Q16 Find customers who never placed an order.
select c.customer_name,c.customer_id
from customerss c
left join
orderss o
on o.customer_id = c.customer_id
where order_id = null;

--Q17 Find products that were never sold.
select p.product_name,p.product_id
from productss p
left join
orderss o
on p.product_id = o.product_id
where o.product_id = null;

--ADVANCE QUESTION
select * from customerss;
select * from productss;
select * from orderss;

--Q18 Find the top 3 highest revenue products.
select p.product_name,
sum(p.price*o.quantity) as total_revenue
from orderss o
join 
productss p 
on o.product_id = p.product_id 
group by p.product_name 
order by total_revenue desc
limit 3;

--Q19Find the highest spending customer.
select c.customer_name,
sum(p.price*o.quantity) as total_spend
from orderss o 
join customerss c
on o.customer_id = c.customer_id 
join productss p 
on o.product_id = p.product_id
group by c.customer_name
order by total_spend desc
limit 1;

---Q20 Rank products by total sales using RANK().
select product_name,total_sales,
row_number() over(order by total_sales  desc) as rank 
from (
select p.product_name,
sum(p.price*o.quantity) as total_sales
from orderss o 
join productss p 
on o.product_id = p.product_id 
group by p.product_name
);

--Q21 Find monthly sales trend.
select
date_trunc('date',o.order_date) as month,
sum(p.price*o.o.quantity) as monthly_sales
from orderss o 
join productss p
on o.product_id =  p.product_id 
group by date_trunc('date',o.order_date)
order by month;

or
select order_date,total_sales,
rank() over(partition by order_date order by total_sales )
from(
select o.order_date,
sum(p.price*o.quantity) as total_sales
from orderss o 
join productss p 
on o.product_id = p.product_id 
group by o.order_id
);

--Q22 Find repeat customers using HAVING.
select c.customer_name,
count(o.order_id) as total_order
from orderss o
join customerss c
on o.customer_id = c.customer_id
group by c.customer_name
having count(o.order_id)>1;

--Subquery & CTE Questions

--Q23 Find customers whose total spending is above average.
with customer_spending as(
select 
c.customer_id,c.customer_name,
sum(p.price*o.quantity) as total_spend
from customerss c
join orderss o
on c.customer_id = o.customer_id
join productss p
on p.product_id = o.product_id
group by c.customer_name,c.customer_id
)
select * from customer_spending
where total_spend > (select avg(total_spend)from customer_spending);

--Q24 Use a CTE to calculate category-wise revenue.
with category_revenue AS (
   select
   p.category,
        (o.quantity * p.price) AS revenue
     from orderss o
    join productss p
        ON o.product_id = p.product_id
)
select
    category,
    SUM(revenue) AS total_revenue
from category_revenue
group by category
order by total_revenue DESC;


--Q25 Find the second highest order value.
select order_id,order_total
from(
select o.order_id,
sum(p.price*o.quantity) as order_total,
dense_rank() over (order by sum(p.price*o.quantity) desc) as rnk
from orderss o
join productss p 
on p.product_id = o.product_id
group by o.order_id 
)
where rnk = 4;

--Case Study Style Questions
--Q26 If a 10% discount is applied on Electronics,
--what will be the new total sales?
select 
sum(
case
when category ='Electronics'
then (o.quantity*p.price)*0.90
else
(o.quantity*p.price)
end
)
from orderss o
join productss p
on o.product_id = p.product_id;

--Q27 Identify customers inactive for the last 30 days.
select c.customer_name,c.customer_id,
max(o.order_date) as last_order
from orderss o
left join customerss c
on c.customer_id = o.customer_id
group by c.customer_id,c.customer_name
having max(o.order_date) < current_date - interval '30 days '
or max(o.order_date) is null;

--Q28 Find the most popular product by quantity sold.
select p.product_name,
sum(o.quantity) as total_quantity
from orderss o
join productss p
on o.product_id = p.product_id
group by p.product_name
order by total_quantity desc
limit 1;
















