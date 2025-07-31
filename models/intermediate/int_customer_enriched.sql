with

customer as (
    select 
        customer_pk
        , person_fk
        , territory_fk
    from {{ ref('stg_erp__sales_customer') }}
),

person as (
    select        
        person_pk
        , person_type
        , first_name || '     ' || last_name as full_name
    from {{ ref('stg_erp__person_person') }}

)
,
 territory as (
    select 
     sales_territory_pk
     , country_name
     , country_region_fk
    from {{ ref('stg_erp__sales_salesterritory') }}
 )


select
    c.customer_pk
    , p.full_name
    , c.person_fk         as person_id
    , c.territory_fk      as territory_id
    , p.person_type
    , country_name
    , country_region_fk    as country_region
    
from customer c
left join person p
    on c.person_fk = p.person_pk
left join territory t
    on c.territory_fk = t.sales_territory_pk

