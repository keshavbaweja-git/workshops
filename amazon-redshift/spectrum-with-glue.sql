create external schema myspectrum_schema 
from data catalog 
database 'myspectrum_db' 
iam_role 'arn:aws:iam::<account-id>:role/myspectrum_role'
create external database if not exists;

-- s3://redshift-downloads is a public accessible s3 bucket
create external table myspectrum_schema.sales(
salesid integer,
listid integer,
sellerid integer,
buyerid integer,
eventid integer,
dateid smallint,
qtysold smallint,
pricepaid decimal(8,2),
commission decimal(8,2),
saletime timestamp)
row format delimited
fields terminated by '\t'
stored as textfile
location 's3://redshift-downloads/tickit/spectrum/sales/'
table properties ('numRows'='172000');

select count(*) from myspectrum_schema.sales;
select count(*) from tickit.event;

explain
select top 10 myspectrum_schema.sales.eventid, 
sum(myspectrum_schema.sales.pricepaid) 
from myspectrum_schema.sales, tickit.event
where myspectrum_schema.sales.eventid = tickit.event.eventid
and myspectrum_schema.sales.pricepaid > 30
group by myspectrum_schema.sales.eventid
order by 2 desc;