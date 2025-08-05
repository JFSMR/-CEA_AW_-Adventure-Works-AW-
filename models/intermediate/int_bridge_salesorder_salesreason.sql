with 
salesreason_bridge as (
    select*
    from {{ ref('stg_erp__sales_salesorderheadersalesreason') }}
)

select*
from salesreason_bridge