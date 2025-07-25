--1.1
select 
    e.businessentityid,
    p.firstname,
    p.lastname,
    e.hiredate
from 
    humanresources.employee e
    join person.person p on e.businessentityid = p.businessentityid
where 
    e.hiredate > '2012-01-01'
order by 
    e.hiredate desc;
--1.2
select 
    productid,
    name,
    listprice,
    productnumber
from 
    production.product
where 
    listprice between 100 and 500
order by 
    listprice asc;
--1.3
select 
    c.customerid,
    p.firstname,
    p.lastname,
    a.city
from 
    sales.customer c
    join person.person p on c.personid = p.businessentityid
    join person.businessentityaddress bea on p.businessentityid = bea.businessentityid
    join person.address a on bea.addressid = a.addressid
where 
    a.city in ('seattle', 'portland');
--1.4
select top 15
    p.name,
    p.listprice,
    p.productnumber,
    pc.name as category
from 
    production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
where 
    p.sellenddate is null
order by 
    p.listprice desc;
--2.1
select 
    productid,
    name,
    color,
    listprice
from 
    production.product
where 
    name like '%mountain%'
    and color = 'black';

--2.2
select 
    p.firstname + ' ' + p.lastname as fullname,
    e.birthdate,
    datediff(year, e.birthdate, getdate()) as age
from 
    humanresources.employee e
    join person.person p on e.businessentityid = p.businessentityid
where 
    e.birthdate between '1970-01-01' and '1985-12-31';

--2.3
select 
    salesorderid,
    orderdate,
    customerid,
    totaldue
from 
    sales.salesorderheader
where 
    year(orderdate) = 2013 and month(orderdate) in (10, 11, 12);

--2.4
select 
    productid,
    name,
    weight,
    size,
    productnumber
from 
    production.product
where 
    weight is null and size is not null;

--3.1
select 
    pc.name as category,
    count(p.productid) as product_count
from 
    production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
group by 
    pc.name
order by 
    product_count desc;

--3.2
select 
    ps.name as subcategory,
    avg(p.listprice) as avg_price
from 
    production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
group by 
    ps.name
having 
    count(p.productid) > 5;

--3.3
select top 10
    c.customerid,
    p.firstname + ' ' + p.lastname as customer_name,
    count(soh.salesorderid) as order_count
from 
    sales.customer c
    join person.person p on c.personid = p.businessentityid
    join sales.salesorderheader soh on c.customerid = soh.customerid
group by 
    c.customerid, p.firstname, p.lastname
order by 
    order_count desc;

--3.4
select 
    datename(month, orderdate) as month_name,
    sum(totaldue) as total_sales
from 
    sales.salesorderheader
where 
    year(orderdate) = 2013
group by 
    datename(month, orderdate), month(orderdate)
order by 
    month(orderdate);

--4.1
select 
    productid,
    name,
    sellstartdate,
    year(sellstartdate) as launch_year
from 
    production.product
where 
    year(sellstartdate) = (
        select year(sellstartdate)
        from production.product
        where name = 'Mountain-100 Black, 42'
    );

--4.2
select 
    p.firstname + ' ' + p.lastname as employee_name,
    e.hiredate,
    count(*) over (partition by e.hiredate) as hired_same_day_count
from 
    humanresources.employee e
    join person.person p on e.businessentityid = p.businessentityid
where 
    e.hiredate in (
        select hiredate
        from humanresources.employee
        group by hiredate
        having count(*) > 1
    )
order by 
    e.hiredate;

--5.1
-- drop the table if it exists
if object_id('sales.productreviews', 'U') is not null
    drop table sales.productreviews;
-- recreate the table
create table sales.productreviews (
    reviewid int primary key identity,
    productid int not null,
    customerid int not null,
    rating int check (rating between 1 and 5),
    reviewdate date default getdate(),
    reviewtext nvarchar(1000),
    verifiedpurchase bit default 0,
    helpfulvotes int default 0,
    constraint fk_product foreign key (productid) references production.product(productid),
    constraint fk_customer foreign key (customerid) references sales.customer(customerid),
    constraint uq_product_customer unique (productid, customerid)
);
--6.1
alter table production.product
add lastmodifieddate datetime default getdate();

--6.2
create nonclustered index ix_person_lastname
on person.person (lastname)
include (firstname, middlename);

--6.3
alter table production.product
add constraint chk_price_gt_cost check (listprice > standardcost);

--7.1
insert into sales.productreviews (productid, customerid, rating, reviewtext, verifiedpurchase, helpfulvotes)
values 
(706, 11000, 5, 'excellent product, highly recommended!', 1, 10),
(707, 11001, 3, 'average quality, but good value.', 1, 2),
(708, 11002, 4, 'very durable and performs well.', 0, 5);

--7.2
insert into production.productcategory (name)
values ('electronics');

declare @categoryid int = scope_identity();

insert into production.productsubcategory (productcategoryid, name)
values (@categoryid, 'smartphones');

--7.3
select *
into sales.discontinuedproducts
from production.product
where sellenddate is not null;
--8.1
update production.product
set modifieddate = getdate()
where listprice > 1000 and sellenddate is null;

--8.2
update p
set p.listprice = p.listprice * 1.15,
    p.modifieddate = getdate()
from production.product p
join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
where pc.name = 'bikes';

--8.3
update e
set e.jobtitle = 'senior ' + e.jobtitle
from humanresources.employee e
where hiredate < '2010-01-01';

--9.1
delete from sales.productreviews
where rating = 1 and helpfulvotes = 0;

--9.2
delete from production.product
where not exists (
    select 1 from sales.salesorderdetail sod
    where sod.productid = production.product.productid
)
and not exists (
    select 1 from production.billofmaterials bom
    where bom.componentid = production.product.productid
)
and not exists (
    select 1 from production.productinventory pi
    where pi.productid = production.product.productid
)
and not exists (
    select 1 from production.productcosthistory pch
    where pch.productid = production.product.productid
);

--9.3
delete from purchasing.purchaseorderheader
where vendorid in (
    select businessentityid from purchasing.vendor
    where activeflag = 0
)
and not exists (
    select 1 from purchasing.purchaseorderdetail pod
    where pod.purchaseorderid = purchasing.purchaseorderheader.purchaseorderid
);

--10.1
select 
    year(orderdate) as order_year,
    sum(totaldue) as total_sales,
    avg(totaldue) as avg_order_value,
    count(*) as order_count
from sales.salesorderheader
where year(orderdate) between 2011 and 2014
group by year(orderdate)
order by order_year;

--10.2
select 
    c.customerid,
    count(soh.salesorderid) as total_orders,
    sum(soh.totaldue) as total_amount,
    avg(soh.totaldue) as avg_order_value,
    min(soh.orderdate) as first_order,
    max(soh.orderdate) as last_order
from sales.customer c
join sales.salesorderheader soh on c.customerid = soh.customerid
group by c.customerid;

--10.3
select top 20
    p.name,
    pc.name as category,
    sum(sod.orderqty) as total_quantity_sold,
    sum(sod.linetotal) as total_revenue
from sales.salesorderdetail sod
join production.product p on sod.productid = p.productid
join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
group by p.name, pc.name
order by total_revenue desc;

--10.4
with sales2013 as (
    select 
        datename(month, orderdate) as month_name,
        month(orderdate) as month_num,
        sum(totaldue) as monthly_sales
    from sales.salesorderheader
    where year(orderdate) = 2013
    group by datename(month, orderdate), month(orderdate)
)
select 
    month_name,
    monthly_sales,
    cast(100.0 * monthly_sales / sum(monthly_sales) over () as decimal(5,2)) as percentage_of_year
from sales2013
order by month_num;
--11.1
select 
    p.firstname + ' ' + isnull(p.middlename + ' ', '') + p.lastname as fullname,
    datediff(year, e.birthdate, getdate()) as age,
    datediff(year, e.hiredate, getdate()) as years_of_service,
    format(e.hiredate, 'MMM dd, yyyy') as hire_date,
    datename(month, e.birthdate) as birth_month
from humanresources.employee e
join person.person p on e.businessentityid = p.businessentityid;

--11.2
select 
    upper(p.lastname) + ', ' + upper(left(p.firstname, 1)) + lower(substring(p.firstname, 2, len(p.firstname))) +
    case when p.middlename is not null then ' ' + upper(left(p.middlename, 1)) + '.' else '' end as formatted_name,
    right(emailaddress, len(emailaddress) - charindex('@', emailaddress)) as email_domain
from person.person p
join person.emailaddress e on p.businessentityid = e.businessentityid;

--11.3
select 
    name,
    round(weight, 1) as weight_kg,
    round(weight / 0.45359237, 1) as weight_lb,
    case when weight is null then null else round(listprice / (weight / 0.45359237), 2) end as price_per_pound
from production.product;

--12.1
select 
    p.name as product_name,
    pc.name as category,
    psc.name as subcategory,
    v.name as vendor_name
from production.product p
join production.productsubcategory psc on p.productsubcategoryid = psc.productsubcategoryid
join production.productcategory pc on psc.productcategoryid = pc.productcategoryid
join purchasing.productvendor pv on p.productid = pv.productid
join purchasing.vendor v on pv.businessentityid = v.businessentityid;

--12.2
select 
    soh.salesorderid,
    pp.firstname + ' ' + pp.lastname as customer_name,
    sp.firstname + ' ' + sp.lastname as salesperson_name,
    st.name as territory_name,
    p.name as product_name,
    sod.orderqty,
    sod.linetotal
from sales.salesorderheader soh
join sales.customer c on soh.customerid = c.customerid
join person.person pp on c.personid = pp.businessentityid
join sales.salesterritory st on soh.territoryid = st.territoryid
join sales.salesperson s on soh.salespersonid = s.businessentityid
join person.person sp on s.businessentityid = sp.businessentityid
join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
join production.product p on sod.productid = p.productid;

--12.3
select 
    p.firstname + ' ' + p.lastname as employee_name,
    e.jobtitle,
    st.name as territory_name,
    st.[group] as territory_group,
    s.salesytd
from humanresources.employee e
join person.person p on e.businessentityid = p.businessentityid
join sales.salesperson s on e.businessentityid = s.businessentityid
join sales.salesterritory st on s.territoryid = st.territoryid;
--13.1
select 
    p.name as product_name,
    pc.name as category,
    isnull(sum(sod.orderqty), 0) as total_quantity_sold,
    isnull(sum(sod.linetotal), 0) as total_revenue
from production.product p
left join sales.salesorderdetail sod on p.productid = sod.productid
left join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
left join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
group by p.name, pc.name;

--13.2
select 
    st.name as territory_name,
    pp.firstname + ' ' + pp.lastname as employee_name,
    s.salesytd
from sales.salesterritory st
left join sales.salesperson s on st.territoryid = s.territoryid
left join person.person pp on s.businessentityid = pp.businessentityid;

--13.3
select 
    v.name as vendor_name,
    pc.name as category_name
from purchasing.vendor v
left join purchasing.productvendor pv on v.businessentityid = pv.businessentityid
left join production.product p on pv.productid = p.productid
left join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
left join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
union
select 
    null as vendor_name,
    pc.name as category_name
from production.productcategory pc
where pc.productcategoryid not in (
    select ps.productcategoryid
    from production.productsubcategory ps
    join production.product p on ps.productsubcategoryid = p.productsubcategoryid
    join purchasing.productvendor pv on p.productid = pv.productid
);
--14.1
with product_avg as (
    select 
        productid,
        name,
        listprice,
        avg(listprice) over () as avg_price
    from production.product
)
select 
    productid,
    name,
    listprice,
    listprice - avg_price as price_difference
from product_avg
where listprice > avg_price;
--14.1
with product_avg as (
    select 
        productid,
        name,
        listprice,
        avg(listprice) over () as avg_price
    from production.product
)
select 
    productid,
    name,
    listprice,
    listprice - avg_price as price_difference
from product_avg
where listprice > avg_price;

--14.2
select 
    p.firstname + ' ' + p.lastname as customer_name,
    count(distinct soh.salesorderid) as total_orders,
    sum(soh.totaldue) as total_amount_spent
from sales.salesorderheader soh
join sales.customer c on soh.customerid = c.customerid
join person.person p on c.personid = p.businessentityid
join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
join production.product pr on sod.productid = pr.productid
join production.productsubcategory ps on pr.productsubcategoryid = ps.productsubcategoryid
join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
where pc.name like 'mountain'
group by p.firstname, p.lastname;

--14.3
select 
    p.name,
    pc.name as category,
    count(distinct soh.customerid) as unique_customer_count
from sales.salesorderdetail sod
join production.product p on sod.productid = p.productid
join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
join sales.salesorderheader soh on sod.salesorderid = soh.salesorderid
group by p.name, pc.name
having count(distinct soh.customerid) > 100;

--14.4
select 
    c.customerid,
    count(*) as order_count,
    rank() over (order by count(*) desc) as customer_rank
from sales.salesorderheader soh
join sales.customer c on soh.customerid = c.customerid
group by c.customerid;

--15.1
create view vw_productcatalog as
select 
    p.productid,
    p.name,
    p.productnumber,
    pc.name as category,
    psc.name as subcategory,
    p.listprice,
    p.standardcost,
    case when p.standardcost = 0 then null else round(((p.listprice - p.standardcost) / p.standardcost) * 100, 2) end as profit_margin_percentage,
    isnull(pi.quantity, 0) as inventory_level,
    case when p.sellenddate is null then 'active' else 'discontinued' end as status
from production.product p
left join production.productsubcategory psc on p.productsubcategoryid = psc.productsubcategoryid
left join production.productcategory pc on psc.productcategoryid = pc.productcategoryid
left join production.productinventory pi on p.productid = pi.productid;

--15.2
create view vw_salesanalysis as
select 
    year(soh.orderdate) as order_year,
    month(soh.orderdate) as order_month,
    st.name as territory,
    sum(soh.totaldue) as total_sales,
    count(*) as order_count,
    avg(soh.totaldue) as average_order_value,
    top_product.top_product_name
from sales.salesorderheader soh
join sales.salesterritory st on soh.territoryid = st.territoryid
outer apply (
    select top 1 p.name as top_product_name
    from sales.salesorderdetail sod
    join production.product p on sod.productid = p.productid
    where sod.salesorderid = soh.salesorderid
    order by sod.linetotal desc
) as top_product
group by year(soh.orderdate), month(soh.orderdate), st.name, top_product.top_product_name;

--15.3
create view vw_employeedirectory as
select 
    p.firstname + ' ' + isnull(p.middlename + ' ', '') + p.lastname as full_name,
    e.jobtitle,
    d.name as department,
    mp.firstname + ' ' + mp.lastname as manager_name,
    e.hiredate,
    datediff(year, e.hiredate, getdate()) as years_of_service,
    ea.emailaddress,
    pp.phonenumber
from humanresources.employee e
join person.person p on e.businessentityid = p.businessentityid
left join humanresources.employee m on e.organizationnode.GetAncestor(1) = m.organizationnode
left join person.person mp on m.businessentityid = mp.businessentityid
join humanresources.employeedepartmenthistory edh on e.businessentityid = edh.businessentityid and edh.enddate is null
join humanresources.department d on edh.departmentid = d.departmentid
left join person.emailaddress ea on e.businessentityid = ea.businessentityid
left join person.personphone pp on e.businessentityid = pp.businessentityid;

--15.4

select * from vw_productcatalog where profit_margin_percentage > 50;

select * from vw_salesanalysis where order_year = 2013 order by order_month;

select * from vw_employeedirectory where years_of_service >= 10;

--16.1
select 
    case 
        when listprice > 500 then 'premium'
        when listprice between 100 and 500 then 'standard'
        else 'budget'
    end as price_category,
    count(*) as product_count,
    avg(listprice) as avg_price
from production.product
group by case 
        when listprice > 500 then 'premium'
        when listprice between 100 and 500 then 'standard'
        else 'budget'
    end;

--16.2
select 
    case 
        when datediff(year, hiredate, getdate()) >= 10 then 'veteran'
        when datediff(year, hiredate, getdate()) between 5 and 9 then 'experienced'
        when datediff(year, hiredate, getdate()) between 2 and 4 then 'regular'
        else 'new'
    end as service_level,
    count(*) as employee_count,
    avg(salariedflag * 1.0) as avg_salary_flag
from humanresources.employee
group by case 
        when datediff(year, hiredate, getdate()) >= 10 then 'veteran'
        when datediff(year, hiredate, getdate()) between 5 and 9 then 'experienced'
        when datediff(year, hiredate, getdate()) between 2 and 4 then 'regular'
        else 'new'
    end;

--16.3
select 
    case 
        when totaldue > 5000 then 'large'
        when totaldue between 1000 and 5000 then 'medium'
        else 'small'
    end as order_size,
    count(*) * 100.0 / (select count(*) from sales.salesorderheader) as percentage_distribution
from sales.salesorderheader
group by case 
        when totaldue > 5000 then 'large'
        when totaldue between 1000 and 5000 then 'medium'
        else 'small'
    end;

--17.1
select 
    name,
    isnull(cast(weight as varchar), 'not specified') as weight,
    isnull(size, 'standard') as size,
    isnull(color, 'natural') as color
from production.product;

--17.2
select 
    c.customerid,
    coalesce(ea.emailaddress, pp.phonenumber, a.addressline1) as best_contact_method
from sales.customer c
left join person.emailaddress ea on c.personid = ea.businessentityid
left join person.personphone pp on c.personid = pp.businessentityid
left join person.businessentityaddress bea on c.personid = bea.businessentityid
left join person.address a on bea.addressid = a.addressid;

--17.3
select 
    productid,
    name,
    weight,
    size,
    case 
        when weight is null and size is not null then 'missing weight'
        when weight is null and size is null then 'missing both'
        else 'ok'
    end as data_status
from production.product;

--18.1
with employee_hierarchy as (
    select 
        e.businessentityid,
        p.firstname + ' ' + p.lastname as employee_name,
        null as manager_id,
        0 as level,
        cast(p.firstname + ' ' + p.lastname as varchar(max)) as path
    from humanresources.employee e
    join person.person p on e.businessentityid = p.businessentityid
    where organizationnode.GetLevel() = 0
    union all
    select 
        e.businessentityid,
        p.firstname + ' ' + p.lastname,
        m.businessentityid,
        eh.level + 1,
        cast(eh.path + ' > ' + p.firstname + ' ' + p.lastname as varchar(max))
    from humanresources.employee e
    join person.person p on e.businessentityid = p.businessentityid
    join humanresources.employee m on e.organizationnode.GetAncestor(1) = m.organizationnode
    join employee_hierarchy eh on m.businessentityid = eh.businessentityid
)
select * from employee_hierarchy;

--18.2
select 
    p.name,
    sum(case when year(soh.orderdate) = 2013 then sod.linetotal else 0 end) as sales_2013,
    sum(case when year(soh.orderdate) = 2014 then sod.linetotal else 0 end) as sales_2014,
    case 
        when sum(case when year(soh.orderdate) = 2013 then sod.linetotal else 0 end) = 0 then null
        else round((sum(case when year(soh.orderdate) = 2014 then sod.linetotal else 0 end) - sum(case when year(soh.orderdate) = 2013 then sod.linetotal else 0 end)) * 100.0 / sum(case when year(soh.orderdate) = 2013 then sod.linetotal else 0 end), 2)
    end as growth_percentage,
    case 
        when sum(case when year(soh.orderdate) = 2014 then sod.linetotal else 0 end) > sum(case when year(soh.orderdate) = 2013 then sod.linetotal else 0 end) then 'growth'
        else 'decline'
    end as growth_category
from sales.salesorderdetail sod
join production.product p on sod.productid = p.productid
join sales.salesorderheader soh on sod.salesorderid = soh.salesorderid
group by p.name;

--19.1
select 
    p.name,
    pc.name as category,
    sum(sod.linetotal) as sales_amount,
    rank() over (partition by pc.name order by sum(sod.linetotal) desc) as rnk,
    dense_rank() over (partition by pc.name order by sum(sod.linetotal) desc) as dense_rnk,
    row_number() over (partition by pc.name order by sum(sod.linetotal) desc) as row_num
from sales.salesorderdetail sod
join production.product p on sod.productid = p.productid
join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
group by p.name, pc.name;

--19.2
with monthly_sales as (
    select 
        month(orderdate) as order_month,
        sum(totaldue) as monthly_sales
    from sales.salesorderheader
    where year(orderdate) = 2013
    group by month(orderdate)
)
select 
    order_month,
    monthly_sales,
    sum(monthly_sales) over (order by order_month rows between unbounded preceding and current row) as running_total,
    cast(100.0 * sum(monthly_sales) over (order by order_month rows between unbounded preceding and current row) /
         sum(monthly_sales) over () as decimal(5,2)) as percentage_ytd
from monthly_sales;

--19.3
with territory_monthly_sales as (
    select 
        t.name as territory,
        year(orderdate) as order_year,
        month(orderdate) as order_month,
        sum(totaldue) as sales
    from sales.salesorderheader soh
    join sales.salesterritory t on soh.territoryid = t.territoryid
    where year(orderdate) = 2013
    group by t.name, year(orderdate), month(orderdate)
)
select 
    territory,
    order_month,
    sales,
    avg(sales) over (partition by territory order by order_month rows between 2 preceding and current row) as moving_avg
from territory_monthly_sales;

--19.4
with monthly_growth as (
    select 
        month(orderdate) as order_month,
        sum(totaldue) as monthly_sales
    from sales.salesorderheader
    where year(orderdate) = 2013
    group by month(orderdate)
)
select 
    order_month,
    monthly_sales,
    lag(monthly_sales) over (order by order_month) as prev_month_sales,
    monthly_sales - lag(monthly_sales) over (order by order_month) as growth_amount,
    cast(100.0 * (monthly_sales - lag(monthly_sales) over (order by order_month)) / nullif(lag(monthly_sales) over (order by order_month), 0) as decimal(5,2)) as growth_percentage
from monthly_growth;

--19.5
with customer_total as (
    select 
        c.customerid,
        sum(totaldue) as total_purchases
    from sales.salesorderheader soh
    join sales.customer c on soh.customerid = c.customerid
    group by c.customerid
),
customer_quartiles as (
    select 
        customerid,
        total_purchases,
        ntile(4) over (order by total_purchases desc) as quartile
    from customer_total
)
select 
    customerid,
    total_purchases,
    quartile,
    avg(total_purchases) over (partition by quartile) as quartile_avg
from customer_quartiles;
--20.1
select 
    category,
    [2011],
    [2012],
    [2013],
    [2014]
from (
    select 
        pc.name as category,
        year(soh.orderdate) as sales_year,
        sod.linetotal
    from sales.salesorderdetail sod
    join production.product p on sod.productid = p.productid
    join production.productsubcategory psc on p.productsubcategoryid = psc.productsubcategoryid
    join production.productcategory pc on psc.productcategoryid = pc.productcategoryid
    join sales.salesorderheader soh on sod.salesorderid = soh.salesorderid
    where year(soh.orderdate) between 2011 and 2014
) as src
pivot (
    sum(linetotal) for sales_year in ([2011], [2012], [2013], [2014])
) as pvt;


--20.2
select 
    department,
    [M] as male_count,
    [F] as female_count
from (
    select 
        d.name as department,
        e.gender
    from humanresources.employee e
    join humanresources.employeedepartmenthistory edh 
        on e.businessentityid = edh.businessentityid and edh.enddate is null
    join humanresources.department d 
        on edh.departmentid = d.departmentid
) as src
pivot (
    count(gender) for gender in ([M], [F])
) as pvt;


--20.3
declare @sql nvarchar(max) = '';
declare @cols nvarchar(max) = '';

select @cols = string_agg(quotename(quarter), ', ') from (
    select distinct 'Q' + cast(datepart(qq, orderdate) as varchar) + '-' + cast(year(orderdate) as varchar) as quarter
    from sales.salesorderheader
) as quarters;

set @sql = '
select territory, ' + @cols + '
from (
    select 
        st.name as territory,
        ''Q'' + cast(datepart(qq, soh.orderdate) as varchar) + ''-'' + cast(year(soh.orderdate) as varchar) as quarter,
        soh.totaldue
    from sales.salesorderheader soh
    join sales.salesterritory st on soh.territoryid = st.territoryid
) as src
pivot (
    sum(totaldue) for quarter in (' + @cols + ')
) as pvt;';

exec sp_executesql @sql;

--21.1
with sold_2013 as (
    select distinct productid from sales.salesorderheader soh
    join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
    where year(orderdate) = 2013
),
sold_2014 as (
    select distinct productid from sales.salesorderheader soh
    join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
    where year(orderdate) = 2014
)
select productid, 'both' as sold_years from sold_2013
intersect
select productid, 'both' from sold_2014
union
select productid, 'only 2013' from sold_2013
except
select productid, 'only 2013' from sold_2014;

--21.2
with high_value as (
    select p.productid, pc.name as category from production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    where p.listprice > 1000
),
high_volume as (
    select p.productid, pc.name as category from sales.salesorderdetail sod
    join production.product p on sod.productid = p.productid
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    group by p.productid, pc.name
    having sum(sod.orderqty) > 1000
)
select distinct category from high_value
union
select distinct category from high_volume;

--22.1
declare @year int = year(getdate());
declare @total_sales money;
declare @avg_order money;

select @total_sales = sum(totaldue), @avg_order = avg(totaldue)
from sales.salesorderheader
where year(orderdate) = @year;

print 'Year: ' + cast(@year as varchar);
print 'Total Sales: $' + cast(@total_sales as varchar);
print 'Average Order: $' + cast(@avg_order as varchar);

--22.2
if exists (
    select 1 from production.product where productid = 706
)
    select * from production.product where productid = 706;
else
    select * from production.product where name like '%bike%';

--22.3
declare @month int = 1;
while @month <= 12
begin
    select 
        datename(month, datefromparts(2013, @month, 1)) as month_name,
        sum(totaldue) as monthly_sales
    from sales.salesorderheader
    where year(orderdate) = 2013 and month(orderdate) = @month
    group by month(orderdate);

    set @month += 1;
end

-- Create the audit_log table
if object_id('dbo.audit_log', 'U') is null
begin
    create table dbo.audit_log (
        logid int identity primary key,
        eventtype nvarchar(50),
        description nvarchar(255),
        eventdate datetime
    );
end;

-- Create the audit_log table
if object_id('dbo.audit_log', 'U') is null
begin
    create table dbo.audit_log (
        logid int identity primary key,
        eventtype nvarchar(50),
        description nvarchar(255),
        eventdate datetime
    );
end;

-- Create the error_log table
if object_id('dbo.error_log', 'U') is null
begin
    create table dbo.error_log (
        errorid int identity primary key,
        errormessage nvarchar(4000),
        error_time datetime
    );
end;

--22.4 
begin try
    begin transaction;

    update production.product
    set listprice = listprice * 1.10,
        lastmodifieddate = getdate()
    where productid = 706;

    insert into dbo.audit_log (eventtype, description, eventdate)
    values ('update', 'price updated for productid 706', getdate());

    commit transaction;
end try
begin catch
    rollback transaction;

    insert into dbo.error_log (errormessage, error_time)
    values (error_message(), getdate());
end catch;

--23.1
create function dbo.fn_customer_lifetime_value (
    @customerid int,
    @startdate date,
    @enddate date,
    @weight float = 1.0
)
returns money
as
begin
    declare @lifetime_value money;

    select @lifetime_value = sum(totaldue) * @weight
    from sales.salesorderheader
    where customerid = @customerid and orderdate between @startdate and @enddate;

    return @lifetime_value;
end;

--23.2
create function dbo.fn_products_by_price (
    @minprice money,
    @maxprice money,
    @category nvarchar(50)
)
returns @result table (
    productid int,
    name nvarchar(100),
    listprice money
)
as
begin
    if @minprice < 0 or @maxprice <= @minprice
        return;

    insert into @result
    select p.productid, p.name, p.listprice
    from production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    where p.listprice between @minprice and @maxprice and pc.name = @category;

    return;
end;

--23.3
create function dbo.fn_employees_under_manager (
    @managerid int
)
returns table
as
return (
    with manager_cte as (
        select organizationnode 
        from humanresources.employee 
        where businessentityid = @managerid
    ),
    hierarchy as (
        select 
            e.businessentityid,
            0 as level,
            e.organizationnode,
            cast('/' + cast(e.businessentityid as varchar(10)) as varchar(max)) as path
        from humanresources.employee e
        where e.businessentityid = @managerid

        union all

        select 
            e.businessentityid,
            h.level + 1,
            e.organizationnode,
            h.path + '/' + cast(e.businessentityid as varchar(10))
        from humanresources.employee e
        join hierarchy h 
            on e.organizationnode.IsDescendantOf(h.organizationnode) = 1
    )
    select 
        businessentityid,
        level,
        path
    from hierarchy
);

--24.1
create procedure dbo.sp_get_products_by_category
    @category nvarchar(50),
    @minprice money,
    @maxprice money
as
begin
    if @minprice < 0 or @maxprice <= @minprice
    begin
        print 'invalid price range';
        return;
    end

    select p.productid, p.name, p.listprice
    from production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    where pc.name = @category and p.listprice between @minprice and @maxprice;
end;

--24.2
create procedure dbo.sp_update_product_price
    @productid int,
    @newprice money
as
begin
    begin try
        begin transaction;

        if @newprice <= 0
        begin
            print 'invalid price';
            rollback transaction;
            return;
        end

        update production.product
        set listprice = @newprice,
            lastmodifieddate = getdate()
        where productid = @productid;

        insert into dbo.audit_log (eventtype, description, eventdate)
        values ('update', 'updated price for productid ' + cast(@productid as varchar), getdate());

        commit transaction;
    end try
    begin catch
        rollback transaction;
        insert into dbo.error_log (errormessage, error_time)
        values (error_message(), getdate());
    end catch
end;

--24.3
create procedure dbo.sp_sales_report
    @startdate date,
    @enddate date,
    @territoryid int
as
begin
    select 
        soh.salesorderid,
        soh.orderdate,
        soh.totaldue,
        st.name as territory
    from sales.salesorderheader soh
    join sales.salesterritory st on soh.territoryid = st.territoryid
    where soh.orderdate between @startdate and @enddate and soh.territoryid = @territoryid;
end;

--24.4
create procedure dbo.sp_process_bulk_order
    @OrderXml xml
as
begin
    set nocount on;

    begin try
        begin transaction;

       
        declare @CustomerID int;

        select @CustomerID = T.X.value('(CustomerID)[1]', 'int')
        from @OrderXml.nodes('/Order') as T(X);

        
        declare @SalesOrderID int;

        insert into sales.salesorderheader (
            customerid,
            orderdate,
            duedate,
            shipdate,
            status,
            onlineorderflag,
            subtotal,
            taxamt,
            freight
        )
        values (
            @CustomerID,
            getdate(),
            dateadd(day, 7, getdate()),
            null,
            1,
            1,
            0, 0, 0  
        );

        set @SalesOrderID = scope_identity();

       
        insert into sales.salesorderdetail (
            salesorderid,
            productid,
            orderqty,
            unitprice
        )
        select
            @SalesOrderID,
            Item.value('(ProductID)[1]', 'int'),
            Item.value('(OrderQty)[1]', 'smallint'),
            Item.value('(UnitPrice)[1]', 'money')
        from @OrderXml.nodes('/Order/OrderItems/Item') as T(Item);

        commit transaction;

       
        select 
            'Success' as Status,
            @SalesOrderID as SalesOrderID;
    end try

    begin catch
        rollback transaction;

        select 
            'Error' as Status,
            error_message() as ErrorMessage;
    end catch
end;


--24.5

create procedure dbo.sp_search_products
    @name nvarchar(100) = null,
    @category nvarchar(50) = null,
    @minprice money = null,
    @maxprice money = null
as
begin
    select top 100 with ties p.productid, p.name, p.listprice
    from production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    where (@name is null or p.name like '%' + @name + '%')
      and (@category is null or pc.name = @category)
      and (@minprice is null or p.listprice >= @minprice)
      and (@maxprice is null or p.listprice <= @maxprice)
    order by p.name;
end;

--25.1
create trigger trg_update_inventory
on sales.salesorderdetail
after insert
as
begin
    update pi
    set pi.quantity = pi.quantity - i.orderqty
    from production.productinventory pi
    join inserted i on pi.productid = i.productid;

    insert into dbo.sales_log (productid, quantity, sale_date)
    select productid, orderqty, getdate() from inserted;
end;

--25.2
create view vw_productvendor as
select pv.productid, pv.businessentityid, v.name as vendor_name
from purchasing.productvendor pv
join purchasing.vendor v on pv.businessentityid = v.businessentityid;

go
create trigger trg_instead_insert_vendor
on vw_productvendor
instead of insert
as
begin
    insert into purchasing.productvendor (productid, businessentityid)
    select productid, businessentityid from inserted;
end;

--25.3
create trigger trg_audit_price_change
on production.product
after update
as
begin
    insert into dbo.audit_log (eventtype, description, eventdate)
    select 'price_change', 'old price: ' + cast(d.listprice as varchar) + ' new price: ' + cast(i.listprice as varchar), getdate()
    from deleted d
    join inserted i on d.productid = i.productid
    where d.listprice <> i.listprice;
end;

--26.1

create index ix_active_products_2025
on production.product (productid)
where sellenddate is null;

create index ix_recent_orders_2025
on sales.salesorderheader (salesorderid)
where orderdate >= '2023-07-25';  
