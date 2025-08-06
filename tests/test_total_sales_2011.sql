--VALIDATION TEST: GROSS SALES IN 2011
-- Requested by CEO: Carlos Silveira

-- Goal:
-- Confirm that the gross sales amount in 2011 equals $12,646,112.16,
-- as identified by the accounting audit team.




with
sales_2011 as (
    select 
    sum(gross_total) as gross_total
  from {{ ref('int_fct_sales_order') }}
  where extract(year from order_date) = 2011
)

select gross_total
from sales_2011
where gross_total not between 12646112.16 and 12646112.20
