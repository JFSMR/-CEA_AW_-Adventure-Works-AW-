with
customer as (
    select *
    from {{ ref('int_customer_enriched') }}

)
select * 
 from customer