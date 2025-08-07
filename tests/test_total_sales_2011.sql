--VALIDATION TEST: GROSS SALES IN 2011
-- Requested by CEO: Carlos Silveira

-- Goal:
-- Confirm that the gross sales amount in 2011 equals $12,646,112.16,
-- as identified by the accounting audit team.




with
sales_2011 as (
   
   
select 
 round(sum(gross_total), 2) as total
from {{ ref('int_fct_sales_order') }}
where date_trunc('year', order_date) = '2011-01-01'
)
   


select total
from sales_2011
where total not between 12646112.16 and 12646112.20
