create database iceberg_database

create table iceberg_table (id bigint, data string, category string, cob_date date)
partitioned by (cob_date)
location 's3://<bucket>/iceberg-database/iceberg-table/'
tblproperties ( 'table_type' = 'ICEBERG' )

insert into iceberg_table (id, data, category, cob_date)
values (1, 'row1', 'A', date '2022-10-12')

insert into iceberg_table (id, data, category, cob_date)
values (2, 'row2', 'B', date '2022-10-13')

insert into iceberg_table (id, data, category, cob_date)
values (3, 'row3', 'C', date '2022-10-14')

select * from iceberg_table

update iceberg_table set data='row22' where id=2

select * from iceberg_table for system_time as of timestamp '2022-11-30 23:59:59'

drop table iceberg_table

drop database iceberg_database

select current_date, current_time
