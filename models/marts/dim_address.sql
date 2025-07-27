with
     in_address as (
        select *
        from {{ ref('int_address_enriched') }}
    )
select *
from  in_address

