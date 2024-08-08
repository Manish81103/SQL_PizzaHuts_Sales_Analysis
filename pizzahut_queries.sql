/*====================================== Questions ============================================================*/

-- Q1. Retrieve the total number of orders placed. 

SELECT 
    COUNT(order_id) as total_orders
FROM
    orders;
 
   
-- Q2.Calculate the total revenue generated from pizza sales. 

SELECT 
    SUM(od.quantity * pz.price) AS total_revenue
FROM
    order_details od
        JOIN
    pizzas pz ON od.pizza_id = pz.pizza_id;


-- Q3.Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) AS hour, COUNT(order_id)
FROM
    orders
GROUP BY Hour;


-- Q4.find the number of pizzas in each category.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

        
-- Q5. Find the top 5 highest-priced pizza and their category also.

SELECT 
    pt.name, pt.category, pz.price
FROM
    pizzas pz
        JOIN
    pizza_types pt ON pz.pizza_type_id = pt.pizza_type_id
ORDER BY pz.price DESC
LIMIT 5;


-- Q6.Identify the most common pizza size ordered.

SELECT 
    pz.size, sum(od.quantity) AS order_count
FROM
    pizzas pz
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pz.size
ORDER BY order_count DESC
LIMIT 1;


-- Q7.Find the top 5 most ordered pizza size and their category .

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


-- Q8.List the top 5 most ordered pizza types along with their quantities.

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


-- Q9.Join the necessary tables to find the total quantity of each pizza category ordered.

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


-- Q10.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    round(avg(quantity),0)
FROM
    (SELECT 
        date, SUM(od.quantity) quantity
    FROM
        orders ord
    JOIN order_details od ON ord.order_id = od.order_id
    GROUP BY date) AS t;
    
-- Q11.Determine the top 3 most ordered pizza types based on revenue.

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


-- Q12.Calculate the percentage contribution of each pizza category to total revenue.

select pt.category,round(sum(pz.price*od.quantity) /(SELECT SUM(od.quantity * pz.price)
FROM order_details od
JOIN pizzas pz 
ON od.pizza_id = pz.pizza_id)*100,2) as revenue

from pizzas pz
join order_details od 
on pz.pizza_id = od.pizza_id
join pizza_types pt
on pt.pizza_type_id = pz.pizza_type_id
group by pt.category;



