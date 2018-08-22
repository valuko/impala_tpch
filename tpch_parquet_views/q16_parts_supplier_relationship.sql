-- the query
DROP VIEW IF EXISTS supplier_tmp;
DROP VIEW IF EXISTS q16_tmp;

CREATE VIEW supplier_tmp as
select 
  s_suppkey
from 
  supplier
where 
  not s_comment like '%Customer%Complaints%';

CREATE VIEW q16_tmp as
select 
  p_brand, p_type, p_size, ps_suppkey
from 
  partsupp ps join part p 
  on 
    p.p_partkey = ps.ps_partkey and p.p_brand <> 'Brand#45' 
    and not p.p_type like 'MEDIUM POLISHED%'
  join supplier_tmp s 
  on 
    ps.ps_suppkey = s.s_suppkey;


select 
  p_brand, p_type, p_size, cast(count(distinct ps_suppkey) as int) as supplier_cnt
from 
  (select 
     * 
   from
     q16_tmp 
   where p_size = 49 or p_size = 14 or p_size = 23 or
         p_size = 45 or p_size = 19 or p_size = 3 or
         p_size = 36 or p_size = 9
) q16_all
group by p_brand, p_type, p_size
order by supplier_cnt desc, p_brand, p_type, p_size
LIMIT 2147483647;
