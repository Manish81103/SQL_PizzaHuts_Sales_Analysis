/*====================================== Questions ============================================================*/

-- Q1. Retrieve the total number of orders placed. 

SELECT 
    COUNT(order_id) as total_orders
FROM
    orders;
    
-- Q2. Calculate the total revenue of pizzas with their category .
    
select pt.category,sum(od.quantity * pz.price) as revenue
from order_details od
join pizzas pz
on od.pizza_id = pz.pizza_id
join pizza_types pt
on pz.pizza_type_id = pt.pizza_type_id
group by 1
order by 2 desc;    
 
   
-- Q3.Calculate the total revenue generated from pizza sales. 

create view v_total_revenue as
SELECT SUM(od.quantity * pz.price)
FROM order_details od
JOIN pizzas pz ON od.pizza_id = pz.pizza_id;

select * from v_total_revenue;


-- Q4.Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) AS hour, COUNT(order_id)
FROM
    orders
GROUP BY Hour;


-- Q5.find the number of pizzas in each category.
SELECT 
    category, COUNT(name) as number_of_pizzas
FROM
    pizza_types
GROUP BY category
order by 2 desc;

        
-- Q6. Find the top 5 highest-priced pizza and their category also.

SELECT 
    pt.name, pt.category, pz.price
FROM
    pizzas pz
        JOIN
    pizza_types pt ON pz.pizza_type_id = pt.pizza_type_id
ORDER BY pz.price DESC
LIMIT 5;


-- Q7.Identify the most common pizza size ordered.

SELECT 
    pz.size, sum(od.quantity) AS order_count
FROM
    pizzas pz
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pz.size
ORDER BY order_count DESC
LIMIT 1;


-- Q8.Find the top 5 most ordered pizza size and their category .

SELECT 
    pz.size, pt.category, count(od.order_details_id) AS order_count
FROM
    order_details od
        JOIN
    pizzas pz ON od.pizza_id = pz.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = pz.pizza_type_id
GROUP BY pz.size , pt.category
ORDER BY order_count DESC
LIMIT 5;


-- Q9.List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, sum(od.quantity) AS quantities
FROM
    pizza_types pt
        JOIN
    pizzas pz ON pt.pizza_type_id = pz.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = pz.pizza_id
GROUP BY pt.name
ORDER BY quantities DESC
LIMIT 5;


-- Q10.Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, sum(od.quantity) AS quantity
FROM
    order_details od
        JOIN
    pizzas pz ON od.pizza_id = pz.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = pz.pizza_type_id
GROUP BY pt.category
ORDER BY quantity DESC;


-- Q11.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    round(avg(quantity),0) as avg_order
FROM
    (SELECT 
        date, SUM(od.quantity) quantity
    FROM
        orders ord
    JOIN order_details od ON ord.order_id = od.order_id
    GROUP BY date) AS t;
    
-- Q12.Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name, SUM(pz.price * od.quantity) AS total_revenue
FROM
    pizzas pz
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = pz.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;


-- Q13.Calculate the percentage contribution of each pizza category to total revenue.

select pt.category,
round(sum(pz.price*od.quantity) / (select * from v_total_revenue) *100,2) as percentage
from pizzas pz
join 
order_details od 
on pz.pizza_id = od.pizza_id
join 
pizza_types pt
on pt.pizza_type_id = pz.pizza_type_id
group by pt.category;



-- Q14.write a query to return month wise sales and order the sales from highest to lowest amount.

SELECT monthname(date) AS months,SUM(od.quantity * pz.price) AS total_sales
FROM orders os
JOIN order_details od 
ON os.order_id = od.order_id
JOIN pizzas pz
ON od.pizza_id = pz.pizza_id
GROUP BY 1
ORDER BY 2 desc;


-- Q15.compare the previous month's sales with current month's sales.

select months,sales,
lag(sales) over() as previous_month_sales,sales-lag(sales) over() as difference
from
(select monthname(ord.date) as months,sum(od.quantity*pz.price) as sales
from order_details od
join pizzas pz
on od. pizza_id= pz.pizza_id
join orders ord
on ord.order_id = od.order_id
group by 1) t;



-- Q16. Write a query to find the month when total sales crossed 500,000.

select * from 
(select *, sum(sales) over(rows between unbounded preceding and current row) as cumsum
from
(select monthname(ord.date) as month, sum(od.quantity*pz.price) as sales
from order_details od
join pizzas pz
on od.pizza_id = pz.pizza_id
join orders ord
on ord.order_id = od.order_id
group by  monthname(ord.date)) t) 
t1
where t1.cumsum > 500000
limit 1;








