with
     int_address as (
        select *
        from {{ ref('int_address_enriched') }}
    )
select *
from  int_address

