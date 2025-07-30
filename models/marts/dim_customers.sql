with
customers as (
    select *
    from {{ ref('Int_customers_erinched') }}
)
select * 
 from customers