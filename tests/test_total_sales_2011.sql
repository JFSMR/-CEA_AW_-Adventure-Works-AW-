-- VALIDATION TEST: GROSS SALES IN 2011
-- Requested by CEO: Carlos Silveira

-- Goal:
-- Confirm that the gross sales amount in 2011 equals $12,646,112.16,
-- as identified by the accounting audit team.

SELECT
    SUM(gross_total) AS gross_sales_2011
FROM {{ ref('your_model_name') }}
WHERE EXTRACT(YEAR FROM order_date) = 2011
HAVING gross_sales_2011 = 12646112.16






with sales_2011 as (
  select round(sum(gross_total), 2) as total
  from {{ ref('int_metrics_sales') }}
  where order_date between '2011-01-01' and '2011-12-31'
) 

select total
from sales_2011
where total not between 12646112.16 and 12646112.20
