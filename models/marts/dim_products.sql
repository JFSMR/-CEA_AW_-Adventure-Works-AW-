with 

products as (

    select * from {{ ref('int_products_erinched') }}
)
 
 select *
 from products