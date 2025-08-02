-- Veracity test of the amount of $12,646,112.16 requested by CEO Carlos Silveira

with
 sales_2011 as (

  select round(sum(gross_total), 2) as total
  from {{ ref('int_metrics_sales') }}
  where order_date between '2011-01-01' and '2011-12-31'
) 

select total
from sales_2011

where total not between 12646112.16 and 12646112.20
