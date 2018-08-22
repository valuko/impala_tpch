-- the query

DROP VIEW IF EXISTS q21_tmp1;
DROP VIEW IF EXISTS q21_tmp2;

CREATE VIEW q21_tmp1 as
select
  l_orderkey, cast(count(distinct l_suppkey) as int), max(l_suppkey) as max_suppkey
from
  lineitem
group by l_orderkey;

CREATE VIEW q21_tmp2 as
select
  l_orderkey, cast(count(distinct l_suppkey) as int), max(l_suppkey) as max_suppkey
from
  lineitem
where
  l_receiptdate > l_commitdate
group by l_orderkey;


select
  s_name, cast(count(1) as int) as numwait
from
  (select s_name from
(select s_name, t2.l_orderkey, l_suppkey, count_suppkey, max_suppkey 
 from q21_tmp2 t2 right outer join
      (select s_name, l_orderkey, l_suppkey from
         (select s_name, t1.l_orderkey, l_suppkey, count_suppkey, max_suppkey
          from
            q21_tmp1 t1 join
            (select s_name, l_orderkey, l_suppkey
             from 
               orders o join
               (select s_name, l_orderkey, l_suppkey
                from
                  nation n join supplier s
                  on
                    s.s_nationkey = n.n_nationkey
                    and n.n_name = 'SAUDI ARABIA'
                  join lineitem l
                  on
                    s.s_suppkey = l.l_suppkey
                where
                  l.l_receiptdate > l.l_commitdate
                ) l1 on o.o_orderkey = l1.l_orderkey and o.o_orderstatus = 'F'
             ) l2 on l2.l_orderkey = t1.l_orderkey
          ) a
          where
           (count_suppkey > 1) or ((count_suppkey=1) and (l_suppkey <> max_suppkey))
       ) l3 on l3.l_orderkey = t2.l_orderkey
    ) b
    where
     (count_suppkey is null) or ((count_suppkey=1) and (l_suppkey = max_suppkey))
  )c
group by s_name
order by numwait desc, s_name
limit 100;
