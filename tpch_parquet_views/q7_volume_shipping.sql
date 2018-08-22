-- the query
DROP VIEW IF EXISTS q7_volume_shipping_tmp;

CREATE VIEW q7_volume_shipping_tmp as
select 
  * 
from
  (
    select 
      n1.n_name as supp_nation, n2.n_name as cust_nation, n1.n_nationkey as s_nationkey,      
      n2.n_nationkey as c_nationkey
from 
  nation n1 join nation n2 
  on 
    n1.n_regionkey = n2.n_regionkey
    and
    n1.n_name = 'FRANCE' and n2.n_name = 'GERMANY'
    UNION ALL
select 
  n1.n_name as supp_nation, n2.n_name as cust_nation, n1.n_nationkey as s_nationkey, 
  n2.n_nationkey as c_nationkey
from 
  nation n1 join nation n2 
  on 
    n1.n_regionkey = n2.n_regionkey
    and
    n2.n_name = 'FRANCE' and n1.n_name = 'GERMANY'
) a;


select 
  supp_nation, cust_nation, l_year, sum(volume) as revenue
from 
  (
    select
      supp_nation, cust_nation, year(l_shipdate) as l_year, 
      l_extendedprice * (1 - l_discount) as volume
    from
      q7_volume_shipping_tmp t join
        (select l_shipdate, l_extendedprice, l_discount, c_nationkey, s_nationkey 
         from supplier s join
           (select l_shipdate, l_extendedprice, l_discount, l_suppkey, c_nationkey 
            from customer c join
              (select l_shipdate, l_extendedprice, l_discount, l_suppkey, o_custkey 
               from orders o join lineitem l 
               on 
                 o.o_orderkey = l.l_orderkey and l.l_shipdate >= '1995-01-01' 
                 and l.l_shipdate <= '1996-12-31'
               ) l1 on c.c_custkey = l1.o_custkey
            ) l2 on s.s_suppkey = l2.l_suppkey
         ) l3 on l3.c_nationkey = t.c_nationkey and l3.s_nationkey = t.s_nationkey
   ) shipping
group by supp_nation, cust_nation, l_year
order by supp_nation, cust_nation, l_year
LIMIT 2147483647;
