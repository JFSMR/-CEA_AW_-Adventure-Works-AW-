with
fct_sales as (
    select *
   from {{ ref('int_fct_sales_order') }}
)
 
 select * 
 from fct_sales