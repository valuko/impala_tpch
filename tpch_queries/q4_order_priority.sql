DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS lineitem;
DROP TABLE IF EXISTS q4_order_priority_tmp;
DROP TABLE IF EXISTS q4_order_priority;

-- create tables and load data
create external table orders (O_ORDERKEY INT, O_CUSTKEY INT, O_ORDERSTATUS STRING, O_TOTALPRICE DOUBLE, O_ORDERDATE STRING, O_ORDERPRIORITY STRING, O_CLERK STRING, O_SHIPPRIORITY INT, O_COMMENT STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE LOCATION '/tpch/orders';
Create external table lineitem (L_ORDERKEY INT, L_PARTKEY INT, L_SUPPKEY INT, L_LINENUMBER INT, L_QUANTITY DOUBLE, L_EXTENDEDPRICE DOUBLE, L_DISCOUNT DOUBLE, L_TAX DOUBLE, L_RETURNFLAG STRING, L_LINESTATUS STRING, L_SHIPDATE STRING, L_COMMITDATE STRING, L_RECEIPTDATE STRING, L_SHIPINSTRUCT STRING, L_SHIPMODE STRING, L_COMMENT STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE LOCATION '/tpch/lineitem';

-- create the target table
CREATE TABLE q4_order_priority_tmp (O_ORDERKEY INT);
CREATE TABLE q4_order_priority (O_ORDERPRIORITY STRING, ORDER_COUNT INT);

-- the query
INSERT OVERWRITE TABLE q4_order_priority_tmp 
select 
  DISTINCT l_orderkey 
from 
  lineitem 
where 
  l_commitdate < l_receiptdate;
INSERT OVERWRITE TABLE q4_order_priority 
select o_orderpriority, cast(count(1) as int) as order_count 
from 
  orders o join q4_order_priority_tmp t 
  on 
o.o_orderkey = t.o_orderkey and o.o_orderdate >= '1993-07-01' and o.o_orderdate < '1993-10-01' 
group by o_orderpriority 
order by o_orderpriority
LIMIT 2147483647;
