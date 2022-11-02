create database iceberg_database

create table iceberg_table (id bigint, data string, category string)
partitioned by (category, bucket(16, id))
location 's3://<bucket-name>/iceberg-database/iceberg-table/'
tblproperties ( 'table_type' = 'ICEBERG' )

insert into iceberg_table (id, data, category)
values (1, 'row1', 'A')

select * from iceberg_table

drop table iceberg_table

drop database iceberg_database