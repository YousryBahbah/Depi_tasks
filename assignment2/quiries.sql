
SELECT *
FROM production.products
WHERE list_price > 1000;

SELECT *
FROM sales.customers
WHERE state = 'CA' OR state = 'NY';

SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2023;

SELECT *
FROM sales.customers
WHERE email LIKE '%@gmail.com';

SELECT *
FROM sales.staffs
WHERE active = 0;

SELECT TOP 5 *
FROM production.products
ORDER BY list_price DESC;

SELECT TOP 10 *
FROM sales.orders
ORDER BY order_date DESC;

SELECT TOP 3 *
FROM sales.customers
ORDER BY last_name ASC;

SELECT *
FROM sales.customers
WHERE phone IS NULL;

SELECT *
FROM sales.staffs
WHERE manager_id IS NOT NULL;

SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.categories AS c
JOIN production.products AS p ON c.category_id = p.category_id
GROUP BY c.category_name;

SELECT state, COUNT(customer_id) AS customer_count
FROM sales.customers
GROUP BY state;

SELECT b.brand_name, AVG(p.list_price) AS average_list_price
FROM production.brands AS b
JOIN production.products AS p ON b.brand_id = p.brand_id
GROUP BY b.brand_name;

SELECT s.first_name, s.last_name, COUNT(o.order_id) AS order_count
FROM sales.staffs AS s
LEFT JOIN sales.orders AS o ON s.staff_id = o.staff_id
GROUP BY s.first_name, s.last_name;

SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM sales.customers AS c
JOIN sales.orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 2;

SELECT *
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

SELECT *
FROM sales.customers
WHERE city LIKE 'S%';

SELECT *
FROM sales.orders
WHERE order_status IN (2, 4);

SELECT *
FROM production.products
WHERE category_id IN (1, 2, 3);

SELECT *
FROM sales.staffs
WHERE store_id = 1 OR phone IS NULL;