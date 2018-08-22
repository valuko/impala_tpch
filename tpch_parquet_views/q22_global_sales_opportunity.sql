
-- the query
DROP VIEW IF EXISTS q22_customer_tmp;
DROP VIEW IF EXISTS q22_customer_tmp1;
DROP VIEW IF EXISTS q22_orders_tmp;

CREATE VIEW q22_customer_tmp as
select 
  c_acctbal, c_custkey, substr(c_phone, 1, 2) as cntrycode
from 
  customer
where 
  substr(c_phone, 1, 2) = '13' or
  substr(c_phone, 1, 2) = '31' or
  substr(c_phone, 1, 2) = '23' or
  substr(c_phone, 1, 2) = '29' or
  substr(c_phone, 1, 2) = '30' or
  substr(c_phone, 1, 2) = '18' or
  substr(c_phone, 1, 2) = '17';
 
CREATE VIEW q22_customer_tmp1 as
select
  avg(c_acctbal)
from
  q22_customer_tmp
where
  c_acctbal > 0.00;

CREATE VIEW q22_orders_tmp AS
select 
  o_custkey 
from 
  orders
group by 
  o_custkey;


select
  cntrycode, CAST(count(1) AS INT) as numcust, sum(c_acctbal) as totacctbal
from
(
  select cntrycode, c_acctbal, avg_acctbal from
  q22_customer_tmp1 ct1 join
  (
    select cntrycode, c_acctbal from
      q22_orders_tmp ot 
      right outer join q22_customer_tmp ct 
      on
        ct.c_custkey = ot.o_custkey
    where
      o_custkey is null
  ) ct2
) a
where
  c_acctbal > avg_acctbal
group by cntrycode
order by cntrycode
LIMIT 2147483647;

