
create schema tpch_300_parquet;
use tpch_300_parquet;

drop table if exists lineitem;
create table lineitem          like tpch_300_text.lineitem_text      stored as parquet;
drop table if exists part;
create table part              like tpch_300_text.part_text          stored as parquet;
drop table if exists supplier;
create table supplier          like tpch_300_text.supplier_text      stored as parquet;
drop table if exists partsupp;
create table partsupp          like tpch_300_text.partsupp_text      stored as parquet;
drop table if exists nation;
create table nation            like tpch_300_text.nation_text        stored as parquet;
drop table if exists region;
create table region            like tpch_300_text.region_text        stored as parquet;
drop table if exists customer;
create table customer          like tpch_300_text.customer_text      stored as parquet;
drop table if exists orders;
create table orders            like tpch_300_text.orders_text        stored as parquet;

insert overwrite table lineitem    select * from tpch_300_text.lineitem;
insert overwrite table part        select * from tpch_300_text.part;
insert overwrite table supplier    select * from tpch_300_text.supplier;
insert overwrite table partsupp    select * from tpch_300_text.partsupp;
insert overwrite table nation      select * from tpch_300_text.nation;
insert overwrite table region      select * from tpch_300_text.region;
insert overwrite table customer    select * from tpch_300_text.customer;
insert overwrite table orders      select * from tpch_300_text.orders;
