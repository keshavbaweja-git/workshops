create database iceberg_database

create table iceberg_table (id bigint, data string, category string, cob_date date)
partitioned by (cob_date)
location 's3://<bucket>/iceberg-database/iceberg-table/'
tblproperties ( 'table_type' = 'ICEBERG' )

insert into iceberg_table (id, data, category, cob_date)
values (1, 'row1', 'A', date '2022-10-12')

insert into iceberg_table (id, data, category, cob_date)
values (2, 'row2', 'B', date '2022-10-13')

select * from iceberg_table;

drop table iceberg_table

drop database iceberg_database