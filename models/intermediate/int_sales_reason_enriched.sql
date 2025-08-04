with salesreason as (
    select 
        sales_order_pk
      , sales_reason_fk
    from {{ ref('stg_erp__sales_salesorderheadersalesreason') }}
)

, reason as (
    select 
        sales_reason_pk
      , name_reason
      , type_reason
    from {{ ref('stg_erp__SALES_SALESREASON') }}
)

, joined as (
    select 
        r.sales_reason_pk
      , s.sales_order_pk as sales_order_id            
      , r.name_reason
      , r.type_reason
    from salesreason s
    left join reason r
        on s.sales_reason_fk = r.sales_reason_pk
)

select
    sales_reason_pk
  , sales_order_id    
  , name_reason
  , type_reason
from joined
