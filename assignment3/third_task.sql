--1-Count the total number of products in the database
select count (product_name) as total_num_of_products
from production.products
--2-Find the average, minimum, and maximum price of all products
select avg (list_price) as average_product_price,
min(list_price) as min_product_price,
max(list_price) as max_product_price
from production.products
--3-Count how many products are in each category.
select category_name ,
count(product_name) as num_of_products
from [production].[categories] c left join [production].[products] p
on c.category_id = p.category_id 
group by category_name
order by num_of_products desc
-- 4-Find the total number of orders for each store
select count([order_id]),[store_name]
from [sales].[orders] o join [sales].[stores] ss on o.[store_id] = ss.store_id
group by store_name
--5-Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers
select top 10 upper([first_name]) , lower([last_name])
from [sales].[customers]
--6-Get the length of each product name. Show product name and its length for the first 10 products.
select top 10 [product_name] , len([product_name])
from [production].[products]
--7-Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15
select top 15 '(' + left([phone],3) + ')'
from [sales].[customers]
--8-Show the current date and extract the year and month from order dates for orders 1-10
select top 10 GETDATE() as current_time1 ,year([order_date]) ,month([order_date]) 
from [sales].[orders]
--9-Join products with their categories. Show product name and category name for first 10 products
select  top 10 c.[category_name] , p.[product_name]
from [production].[categories] c inner join [production].[products] p
on c.[category_id] = p.category_id
--10-Join customers with their orders. Show customer name and order date for first 10 orders
select top 10 concat ([first_name] , ' ' , [last_name]) as customer_name , o.[order_date] 
from [sales].[customers] c inner join [sales].[orders] o on c.customer_id = o.customer_id
--11-Show all products with their brand names, even if some products don't have brands. 
--Include product name, brand name (show 'No Brand' if null)
select p.[product_name] , isnull(b.[brand_name] , 'No Brand') as brand_name
from [production].[products] p left join [production].[brands] b 
on p.brand_id = b.brand_id
--12-Find products that cost more than the average product price. Show product name and price
select [product_name] ,[list_price] 
from [production].[products] 
where [list_price] > (select avg ([list_price]) from [production].[products])
--13-Find customers who have placed at least one order. Use a subquery with IN.
-- Show customer_id and customer_name.
select [customer_id] ,[first_name] + ' ' + [last_name] as customer_name
from [sales].[customers]
where customer_id in (select [customer_id] from [sales].[orders] where [order_id] is not null)
--14-For each customer, show their name and total number of orders using a subquery in the SELECT clause
select [first_name] + ' ' + [last_name] as customer_name , (select count([order_id]) from [sales].[orders] o where o.customer_id = c.customer_id)
from [sales].[customers] c
--15- Create a simple view called easy_product_list that shows product name, category name, and price.
 --Then write a query to select all products from this view where price > 100.
 create view easy_product_list as 
 select p.[product_name] , c.[category_name] , p.[list_price] 
 from [production].[products] p left join [production].[categories] c on p.category_id = c.category_id

 select * from easy_product_list 
 where [list_price] > 100
 --16- Create a view called customer_info that shows customer ID, full name (first + last)
 --, email, and city and state combined. Then use this view to find all customers from California (CA).
 create view customer_info as 
 select [customer_id] , concat([first_name] , ' ' , [last_name]) as fullname ,[email] , CONCAT([city],[state]) as address
 from [sales].[customers]

 select  fullname
 from customer_info 
 where right(address,2) in (select state from [sales].[customers] where state = 'ca' ) 
  --17-Find all products that cost between $50 and $200.
  -- Show product name and price, ordered by price from lowest to highest.
  select [product_name] , [list_price] 
  from [production].[products]
  where [list_price] < 200 and [list_price] >50 
  order by [list_price] asc
  --18-Count how many customers live in each state.
  -- Show state and customer count, ordered by count from highest to lowest.
  select [state] , count([customer_id]) as people_in_thestate
  from [sales].[customers]
  group by [state] 
  order by people_in_thestate desc
  --19-Find the most expensive product in each category.
  --Show category name, product name, and price.
  SELECT 
    c.category_name,
    p.product_name,
    p.list_price AS most_expensive_item
FROM production.products p
INNER JOIN production.categories c ON p.category_id = c.category_id
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);
--20-Show all stores and their cities, including the total number of orders from each store.
--Show store name, city, and order count.
select s.[store_name] , s.[city] , count(o.[store_id]) as num_of_orders
from [sales].[stores] s left join [sales].[orders] o on s.store_id = o.store_id
 group by  s.[store_name] ,s.[city] 