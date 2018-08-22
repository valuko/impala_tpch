-- the query
DROP VIEW IF EXISTS q4_order_priority_tmp;
DROP TABLE IF EXISTS q4_order_priority_tmp;

CREATE TABLE q4_order_priority_tmp as
select 
  DISTINCT l_orderkey 
from 
  lineitem 
where 
  l_commitdate < l_receiptdate;

select o_orderpriority, cast(count(1) as int) as order_count 
from 
  orders o join q4_order_priority_tmp t 
  on 
o.o_orderkey = t.o_orderkey and o.o_orderdate >= '1993-07-01' and o.o_orderdate < '1993-10-01' 
group by o_orderpriority 
order by o_orderpriority
LIMIT 100;
