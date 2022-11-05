create database iceberg_database

create table iceberg_table_sales 
(order_id string, item_id string, customer_id string, sales_datetime timestamp)
partitioned by (hour(sales_datetime))
location 's3://646297494209-us-east-1-modern-data-lake-storage/iceberg-database/iceberg-table-sales/'
tblproperties ( 'table_type' = 'ICEBERG' )

insert into iceberg_table_sales 
(order_id, item_id, customer_id, sales_datetime)
values ('O-01', 'P-100', 'C-1000', timestamp '2022-10-12 13:30:30')

insert into iceberg_table_sales 
(order_id, item_id, customer_id, sales_datetime)
values ('O-02', 'P-102', 'C-1000', timestamp '2022-10-12 15:30:30')

select * from iceberg_table_sales 
where date(sales_datetime) = date '2022-10-12'

select * from iceberg_table_sales 
for system_time as of timestamp '2022-10-30 23:59:59'
where date(sales_datetime) >= date '2022-10-01' 
and date(sales_datetime) <= date '2022-10-31' 

select count(*), date(sales_datetime) 
from iceberg_table_sales 
for system_time as of timestamp '2022-10-30 23:59:59'
group by date(sales_datetime)

select * from iceberg_table_sales 
for system_time as of timestamp '2022-11-30 23:59:59'