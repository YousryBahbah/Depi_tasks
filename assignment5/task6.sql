--1
declare @customer_id int = 1
declare @total_spending decimal(10,2)

select @total_spending = sum(oi.quantity * oi.list_price)
from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where o.customer_id = @customer_id

if @total_spending > 5000
    print 'vip customer - total spending: $' + cast(@total_spending as varchar(20))
else
    print 'regular customer - total spending: $' + cast(@total_spending as varchar(20))
--2
declare @threshold decimal(10,2) = 1500
declare @count int

select @count = count(*)
from production.products
where list_price > @threshold

print 'number of products above $' + cast(@threshold as varchar(10)) + ' is: ' + cast(@count as varchar(10))
--3
declare @staff_id int = 2
declare @year int = 2017
declare @total_sales decimal(10,2)

select @total_sales = sum(oi.quantity * oi.list_price)
from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(o.order_date) = @year and o.staff_id = @staff_id

print 'total sales for staff ' + cast(@staff_id as varchar(10)) + ' in year ' + cast(@year as varchar(4)) + ' is $' + cast(@total_sales as varchar(20))
--4
select 
    @@servername as server_name,
    @@version as sql_server_version,
    @@rowcount as last_rows_affected
--5
declare @quantity int

select @quantity = quantity
from production.stocks
where product_id = 1 and store_id = 1

if @quantity > 20
    print 'well stocked'
else if @quantity between 10 and 20
    print 'moderate stock'
else
    print 'low stock - reorder needed'
--6
declare @batch_size int = 3
declare @updated int = 0

while exists (select top 1 * from production.stocks where quantity < 5 and product_id not in (select top (@updated) product_id from production.stocks where quantity < 5))
begin
    update top (@batch_size) production.stocks
    set quantity = quantity + 10
    where quantity < 5 and product_id not in (
        select top (@updated) product_id from production.stocks where quantity < 5
    )

    set @updated = @updated + @batch_size

    print 'updated batch of 3 low-stock products'
end
--7
select 
    product_id,
    product_name,
    list_price,
    case 
        when list_price < 300 then 'budget'
        when list_price between 300 and 800 then 'mid-range'
        when list_price between 801 and 2000 then 'premium'
        else 'luxury'
    end as price_category
from production.products
--8
if exists (select * from sales.customers where customer_id = 5)
begin
    select count(*) as order_count
    from sales.orders
    where customer_id = 5
end
else
begin
    print 'customer does not exist'
end
--9
create function dbo.CalculateShipping (@total decimal(10,2))
returns decimal(5,2)
as
begin
    declare @shippingCost decimal(5,2)

    if @total > 100
        set @shippingCost = 0
    else if @total between 50 and 99.99
        set @shippingCost = 5.99
    else
        set @shippingCost = 12.99

    return @shippingCost
end
--10
create function dbo.GetProductsByPriceRange (@min_price decimal(10,2), @max_price decimal(10,2))
returns table
as
return (
    select p.product_id, p.product_name, p.list_price, c.category_name, b.brand_name
    from production.products p
    join production.categories c on p.category_id = c.category_id
    join production.brands b on p.brand_id = b.brand_id
    where p.list_price between @min_price and @max_price
)
--11
create function dbo.GetCustomerYearlySummary (@cust_id int)
returns @summary table (
    order_year int,
    total_orders int,
    total_spent decimal(10,2),
    average_order_value decimal(10,2)
)
as
begin
    insert into @summary
    select 
        year(o.order_date),
        count(distinct o.order_id),
        sum(oi.quantity * oi.list_price),
        avg(oi.quantity * oi.list_price)
    from sales.orders o
    join sales.order_items oi on o.order_id = oi.order_id
    where o.customer_id = @cust_id
    group by year(o.order_date)

    return
end
--12
create function dbo.CalculateBulkDiscount (@quantity int)
returns int
as
begin
    declare @discount int

    if @quantity between 1 and 2
        set @discount = 0
    else if @quantity between 3 and 5
        set @discount = 5
    else if @quantity between 6 and 9
        set @discount = 10
    else
        set @discount = 15

    return @discount
end
--13
create procedure sp_GetCustomerOrderHistory 
    @cust_id int, 
    @start_date date = null, 
    @end_date date = null
as
begin
    select 
        o.order_id, o.order_date,
        sum(oi.quantity * oi.list_price) as order_total
    from sales.orders o
    join sales.order_items oi on o.order_id = oi.order_id
    where o.customer_id = @cust_id
        and (@start_date is null or o.order_date >= @start_date)
        and (@end_date is null or o.order_date <= @end_date)
    group by o.order_id, o.order_date
end
--14
create procedure sp_RestockProduct 
    @store_id int, 
    @product_id int, 
    @restock_quantity int,
    @old_quantity int output,
    @new_quantity int output,
    @success bit output
as
begin
    select @old_quantity = quantity
    from production.stocks
    where store_id = @store_id and product_id = @product_id

    update production.stocks
    set quantity = quantity + @restock_quantity
    where store_id = @store_id and product_id = @product_id

    select @new_quantity = quantity
    from production.stocks
    where store_id = @store_id and product_id = @product_id

    set @success = 1
end
--15
create procedure sp_ProcessNewOrder 
    @customer_id int,
    @product_id int,
    @quantity int,
    @store_id int
as
begin
    begin try
        begin transaction

        declare @order_id int

        insert into sales.orders (customer_id, store_id, order_date)
        values (@customer_id, @store_id, getdate())

        set @order_id = scope_identity()

        insert into sales.order_items (order_id, item_id, product_id, quantity, list_price)
        values (@order_id, 1, @product_id, @quantity, 
               (select list_price from production.products where product_id = @product_id))

        commit
    end try
    begin catch
        rollback
        print 'error processing order'
    end catch
end
--16
create procedure sp_SearchProducts
    @name varchar(100) = null,
    @category_id int = null,
    @min_price decimal(10,2) = null,
    @max_price decimal(10,2) = null,
    @sort_col varchar(50) = 'list_price'
as
begin
    declare @sql nvarchar(max)

    set @sql = '
    select product_id, product_name, list_price
    from production.products
    where 1 = 1'

    if @name is not null
        set @sql += ' and product_name like ''%' + @name + '%'''

    if @category_id is not null
        set @sql += ' and category_id = ' + cast(@category_id as varchar)

    if @min_price is not null
        set @sql += ' and list_price >= ' + cast(@min_price as varchar)

    if @max_price is not null
        set @sql += ' and list_price <= ' + cast(@max_price as varchar)

    set @sql += ' order by ' + @sort_col

    exec sp_executesql @sql
end
--17
declare @start_date date = '2017-01-01'
declare @end_date date = '2017-03-31'

select staff_id,
    sum(oi.quantity * oi.list_price) as total_sales,
    case 
        when sum(oi.quantity * oi.list_price) > 30000 then '15%'
        when sum(oi.quantity * oi.list_price) > 15000 then '10%'
        else '5%'
    end as bonus_rate
from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where o.order_date between @start_date and @end_date
group by staff_id
--18
select s.product_id, s.quantity,
    case 
        when s.quantity < 5 and p.category_id = 1 then 'reorder 20 units'
        when s.quantity < 5 and p.category_id = 2 then 'reorder 30 units'
        when s.quantity between 5 and 10 then 'monitor stock'
        else 'stock ok'
    end as restock_action
from production.stocks s
join production.products p on s.product_id = p.product_id

--19
select c.customer_id, c.first_name, c.last_name,
    isnull(sum(oi.quantity * oi.list_price), 0) as total_spent,
    case 
        when sum(oi.quantity * oi.list_price) >= 10000 then 'gold'
        when sum(oi.quantity * oi.list_price) >= 5000 then 'silver'
        when sum(oi.quantity * oi.list_price) >= 1000 then 'bronze'
        else 'new'
    end as loyalty_tier
from sales.customers c
left join sales.orders o on c.customer_id = o.customer_id
left join sales.order_items oi on o.order_id = oi.order_id
group by c.customer_id, c.first_name, c.last_name
--20
create procedure sp_DiscontinueProduct
    @product_id int,
    @replacement_id int = null
as
begin
    if exists (select * from sales.order_items where product_id = @product_id)
    begin
        print 'cannot discontinue: product used in orders'
        return
    end

    if @replacement_id is not null
    begin
        update sales.order_items
        set product_id = @replacement_id
        where product_id = @product_id
    end

    delete from production.stocks where product_id = @product_id
    delete from production.products where product_id = @product_id

    print 'product discontinued successfully'
end
