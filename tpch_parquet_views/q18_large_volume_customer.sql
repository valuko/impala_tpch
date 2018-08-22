-- the query

DROP VIEW IF EXISTS q18_tmp;

CREATE VIEW q18_tmp as
select 
  l_orderkey, sum(l_quantity) as t_sum_quantity
from 
  lineitem
group by l_orderkey;

select 
  c_name,c_custkey,o_orderkey,o_orderdate,cast(o_totalprice*1000 as int)/1000,sum(l_quantity)
from 
  customer c join orders o 
  on 
    c.c_custkey = o.o_custkey
  join q18_tmp t 
  on 
    o.o_orderkey = t.l_orderkey and t.t_sum_quantity > 300
  join lineitem l 
  on 
    o.o_orderkey = l.l_orderkey
group by c_name,c_custkey,o_orderkey,o_orderdate,cast(o_totalprice*1000 as int)
order by cast(o_totalprice*1000 as int) desc,o_orderdate
limit 100;

