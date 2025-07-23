--1
create nonclustered index ix_1
on [sales].[customers](email)
--2
create nonclustered index ix_2
on [production].[products] ([category_id],[brand_id])
--3
create nonclustered index ix_2
on  [sales].[orders]([order_date]) 
include (customer_id, store_id, order_status)
--4
create trigger tr1
on sales.customers
for insert 
as 
begin
insert into [sales].[customer_log] values (1,'welcome',getdate()) 
end 
--5
create trigger tr2
on production.products
after update
as
begin
    insert into production.price_history (product_id, old_price, new_price, change_date, changed_by)
    select 
        i.product_id,
        d.list_price,
        i.list_price,
        getdate(),
        system_user
    from inserted i
    join deleted d on i.product_id = d.product_id
    where i.list_price != d.list_price
end
--6
create trigger tr3
on production.categories
instead of delete
as
begin
    if exists (
        select 1
        from deleted d
        join production.products p
        on p.category_id = d.category_id
    )
    begin
        raiserror('Cannot delete category: products are linked to it.', 16, 1)
        return
    end
    delete from production.categories
    where category_id in (select category_id from deleted)
end
--7
create trigger tr4
on sales.order_items
after insert
as
begin
    update s
    set s.quantity = s.quantity - i.quantity
    from production.stocks s
    join inserted i on i.product_id = s.product_id
    join sales.orders o on o.order_id = i.order_id and o.store_id = s.store_id
end
--8
create trigger tr8
on sales.orders
after insert
as
begin
    insert into sales.order_audit (order_id, customer_id, store_id, staff_id, order_date, audit_timestamp)
    select 
        order_id,
        customer_id,
        store_id,
        staff_id,
        order_date,
        getdate()
    from inserted
end
