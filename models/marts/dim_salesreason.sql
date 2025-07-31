with 

salesreason as (

    select * from {{ ref('int_sales_reason_enriched') }}

)
 
 select *
 from salesreason