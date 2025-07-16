--1-Write a query that classifies all products into price categories
select [product_name] , [list_price] ,
case 
when [list_price] < 300 then 'Economy'
when [list_price] < 1000 then 'Standard'
when [list_price] < 2500 then 'premium'
else 'laxury'
end as price_category
from [production].[products]

--2-Create a query that shows order processing information with user-friendly status descriptions:
select customer_id , 
case 

when  [order_status] = 1  then 'Order Received'

when  [order_status] = 2  then 'in Preparation'
when  [order_status] = 3  then 'Order Cancelled'
when  [order_status] = 4  then 'Order Delivered'
end as status_description
, 
case
when  [order_status] = 1 and DATEDIFF(DAY , [order_date] ,[shipped_date]) > 5 then 'URGENT'
when  [order_status] = 2 and DATEDIFF(DAY , [order_date] ,[shipped_date]) > 3 then 'HIGH'
else 'NORMAL'
end as prioritylevel

from [sales].[orders]

--3-Write a query that categorizes staff based on the number of orders they've handled
select CONCAT( s.[first_name],' ' ,s.[last_name]) as staffname , count ([order_id]) as num_of_orders,
case 
when count ([order_id]) = 0 then 'new staff'
when count ([order_id]) <= 10 then 'Junior Staff'
when count ([order_id]) <= 25 then 'Senior  Staff'
when count ([order_id]) > 25 then 'Expert  Staff'
end as experience
from [sales].[staffs] s left join [sales].[orders] o on o.staff_id = s.staff_id 
group by   CONCAT( s.[first_name],' ' ,s.[last_name])

--4-.Create a query that handles missing customer contact information
select * , isnull(phone , 'Phone Not Available')
from [sales].[customers]

select * , coalesce(phone , email ,'No Contact Method')
from [sales].[customers]
--5-Write a query that safely calculates price per unit in stockWrite a query that safely calculates price per unit in stock
SELECT 
    p.product_id,
    p.product_name,
    s.store_id,
    s.quantity,
    p.list_price,
    ISNULL(p.list_price / NULLIF(s.quantity, 0), 0) AS price_per_unit,
    CASE 
        WHEN s.quantity = 0 THEN 'Out of Stock'
        WHEN s.quantity <= 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status

FROM production.products p
INNER JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.store_id = 1;
--6-Create a query that formats complete addresses safely
SELECT 
    customer_id,
    first_name + ' ' + last_name AS full_name,
    COALESCE(city, 'No City') AS city,
    COALESCE(state, 'No State') AS state,
    COALESCE(zip_code, 'No ZIP') AS zip,

    COALESCE(city, '') + ', ' +
    COALESCE(state, '') + ' ' +
    COALESCE(zip_code, '') AS formatted_address

FROM sales.customers;
--7-Use a CTE to find customers who have spent more than $1,500 total
WITH CustomerSpending AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
    FROM sales.orders o
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    c.email,
    cs.total_spent
FROM CustomerSpending cs
INNER JOIN sales.customers c ON cs.customer_id = c.customer_id
WHERE cs.total_spent > 1500
ORDER BY cs.total_spent DESC;

--8-Create a multi-CTE query for category analysis
WITH CategoryRevenue AS (
    SELECT 
        c.category_id,
        c.category_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM production.categories c
    JOIN production.products p ON c.category_id = p.category_id
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY c.category_id, c.category_name
),
CategoryAverageOrder AS (
    SELECT 
        c.category_id,
        AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order_value
    FROM production.categories c
    JOIN production.products p ON c.category_id = p.category_id
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY c.category_id
)
SELECT 
    r.category_name,
    r.total_revenue,
    a.avg_order_value,
    CASE 
        WHEN r.total_revenue > 50000 THEN 'Excellent'
        WHEN r.total_revenue > 20000 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_rating
FROM CategoryRevenue r
JOIN CategoryAverageOrder a ON r.category_id = a.category_id
ORDER BY r.total_revenue DESC;
--9-Use CTEs to analyze monthly sales trends

WITH monthly_sales AS (
    SELECT 
        MONTH(o.order_date) AS order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS monthly_sales
    FROM sales.orders o 
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY MONTH(o.order_date)
),
sales_with_previous AS (
    SELECT 
        order_month,
        monthly_sales,
        LAG(monthly_sales) OVER (ORDER BY order_month) AS previous_month_sales
    FROM monthly_sales
)
SELECT 
    order_month,
    monthly_sales,
    previous_month_sales,
        CASE 
            WHEN previous_month_sales IS NULL OR previous_month_sales = 0 THEN NULL
            ELSE ((monthly_sales - previous_month_sales) / previous_month_sales) * 100
        END
     AS growth_percentage
FROM sales_with_previous;

--10-Create a query that ranks products within each category
with ranked_products as (
    select 
        c.category_name,
        p.product_name,
        p.list_price,
        row_number() over (
            partition by c.category_name 
            order by p.list_price desc
        ) as row_num,
        rank() over (
            partition by c.category_name 
            order by p.list_price desc
        ) as rank_num,
        dense_rank() over (
            partition by c.category_name 
            order by p.list_price desc
        ) as dense_rank_num
    from production.products p
    join production.categories c on p.category_id = c.category_id
)
select 
    category_name,
    product_name,
    list_price,
    row_num as row_number,
    rank_num as rank,
    dense_rank_num as dense_rank
from ranked_products
where row_num <= 3
order by category_name, row_num;
--11-Rank customers by their total spending
 with customer_spending as (
    select 
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) as customer_name,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spent
    from sales.customers c
    join sales.orders o on c.customer_id = o.customer_id
    join sales.order_items oi on o.order_id = oi.order_id
    group by c.customer_id, c.first_name, c.last_name
),
ranked_customers as (
    select 
        customer_id,
        customer_name,
        total_spent,
        rank() over (order by total_spent desc) as spending_rank,
        ntile(5) over (order by total_spent desc) as spending_group
    from customer_spending
)
select 
    customer_id,
    customer_name,
    total_spent,
    spending_rank,
    spending_group,
    case spending_group
        when 1 then 'VIP'
        when 2 then 'Gold'
        when 3 then 'Silver'
        when 4 then 'Bronze'
        else 'Standard'
    end as tier
from ranked_customers
order by spending_rank;
--12-Create a comprehensive store performance ranking
with store_metrics as (
    select 
        s.store_id,
        s.store_name,
        s.city,
        count(distinct o.order_id) as total_orders,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
    from sales.stores s
    left join sales.orders o on s.store_id = o.store_id
    left join sales.order_items oi on o.order_id = oi.order_id
    group by s.store_id, s.store_name, s.city
),
ranked_stores as (
    select 
        store_id,
        store_name,
        city,
        total_orders,
        total_revenue,
        rank() over (order by total_revenue desc) as revenue_rank,
        rank() over (order by total_orders desc) as orders_rank,
        percent_rank() over (order by total_revenue) as revenue_percentile,
        percent_rank() over (order by total_orders) as orders_percentile
    from store_metrics
)
select *
from ranked_stores
order by revenue_rank;

--13-Create a PIVOT table showing product counts by category and brand
select * from (
    select 
        c.category_name,
        b.brand_name
    from production.products p
    inner join production.categories c on p.category_id = c.category_id
    inner join production.brands b on p.brand_id = b.brand_id
    where b.brand_name in ('Electra', 'Haro', 'Trek', 'Surly')
) as source_table
pivot (
    count(brand_name)
    for brand_name in ([Electra], [Haro], [Trek], [Surly])
) as pivot_table;

--14-Create a PIVOT showing monthly sales revenue by store
SELECT 
    store_name,
    ISNULL([Jan], 0) AS Jan,
    ISNULL([Feb], 0) AS Feb,
    ISNULL([Mar], 0) AS Mar,
    ISNULL([Apr], 0) AS Apr,
    ISNULL([May], 0) AS May,
    ISNULL([Jun], 0) AS Jun,
    ISNULL([Jul], 0) AS Jul,
    ISNULL([Aug], 0) AS Aug,
    ISNULL([Sep], 0) AS Sep,
    ISNULL([Oct], 0) AS Oct,
    ISNULL([Nov], 0) AS Nov,
    ISNULL([Dec], 0) AS Dec,
    
    ISNULL([Jan], 0) + ISNULL([Feb], 0) + ISNULL([Mar], 0) +
    ISNULL([Apr], 0) + ISNULL([May], 0) + ISNULL([Jun], 0) +
    ISNULL([Jul], 0) + ISNULL([Aug], 0) + ISNULL([Sep], 0) +
    ISNULL([Oct], 0) + ISNULL([Nov], 0) + ISNULL([Dec], 0) AS total
FROM (
    SELECT 
        s.store_name,
        DATENAME(MONTH, o.order_date) AS order_month,
        oi.quantity * oi.list_price * (1 - oi.discount) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
) AS source
PIVOT (
    SUM(revenue)
    FOR order_month IN (
        [Jan], [Feb], [Mar], [Apr], [May], [Jun],
        [Jul], [Aug], [Sep], [Oct], [Nov], [Dec]
    )
) AS pivot_table
ORDER BY store_name;

--15-PIVOT order statuses across stores\SELECT 
  select 
    store_name,
    isnull([Pending], 0) as pending,
    isnull([Processing], 0) as processing,
    isnull([Completed], 0) as completed,
    isnull([Rejected], 0) as rejected
from (
    select 
        s.store_name,
        case o.order_status
            when 1 then 'Pending'
            when 2 then 'Processing'
            when 3 then 'Rejected'
            when 4 then 'Completed'
        end as status
    from sales.orders o
    join sales.stores s on o.store_id = s.store_id
) as src
pivot (
    count(status)
    for status in ([Pending], [Processing], [Completed], [Rejected])
) as p;
--16-Create a PIVOT comparing sales across years
with yearly_sales as (
    select 
        b.brand_name,
        year(o.order_date) as order_year,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
    from sales.orders o
    join sales.order_items oi on o.order_id = oi.order_id
    join production.products p on oi.product_id = p.product_id
    join production.brands b on p.brand_id = b.brand_id
    where year(o.order_date) in (2016, 2017, 2018)
    group by b.brand_name, year(o.order_date)
),
pivoted_sales as (
    select 
        brand_name,
        isnull([2016], 0) as y2016,
        isnull([2017], 0) as y2017,
        isnull([2018], 0) as y2018
    from yearly_sales
    pivot (
        sum(total_revenue)
        for order_year in ([2016], [2017], [2018])
    ) as p
)
select 
    brand_name,
    y2016,
    y2017,
    y2018,
    case when y2016 = 0 then null else round(((y2017 - y2016) / y2016) * 100.0, 2) end as growth_16_17,
    case when y2017 = 0 then null else round(((y2018 - y2017) / y2017) * 100.0, 2) end as growth_17_18
from pivoted_sales
order by brand_name;
--17-Use UNION to combine different product availability statuses
select 
    p.product_id, 
    p.product_name, 
    'In Stock' as status
from production.products p
join production.stocks s on p.product_id = s.product_id
where s.quantity > 0

union

select 
    p.product_id, 
    p.product_name, 
    'Out of Stock' as status
from production.products p
left join production.stocks s on p.product_id = s.product_id
where s.quantity = 0 or s.quantity is null

union

select 
    p.product_id, 
    p.product_name, 
    'Discontinued' as status
from production.products p
where not exists (
    select 1 
    from production.stocks s 
    where s.product_id = p.product_id
);
--18-.Use INTERSECT to find loyal customers
select distinct customer_id
from sales.orders
where year(order_date) = 2017
intersect
select distinct customer_id
from sales.orders
where year(order_date) = 2018;

--19-Use multiple set operators to analyze product distribution
select distinct product_id, 'Available in All Stores' as status
from production.stocks
where store_id = 1
intersect
select distinct product_id, 'Available in All Stores'
from production.stocks
where store_id = 2
intersect
select distinct product_id, 'Available in All Stores'
from production.stocks
where store_id = 3

union

select product_id, 'Only in Store 1' as status
from (
    select distinct product_id
    from production.stocks
    where store_id = 1

    except

    select distinct product_id
    from production.stocks
    where store_id = 2
) as only_in_store1;

--20-Complex set operations for customer retention
select distinct customer_id, 'Lost' as status
from sales.orders
where year(order_date) = 2016
except
select distinct customer_id, 'Lost'
from sales.orders
where year(order_date) = 2017

union all

select distinct customer_id, 'New' as status
from sales.orders
where year(order_date) = 2017
except
select distinct customer_id, 'New'
from sales.orders
where year(order_date) = 2016

union all

select distinct customer_id, 'Retained' as status
from sales.orders
where year(order_date) = 2016
intersect
select distinct customer_id, 'Retained'
from sales.orders
where year(order_date) = 2017;
