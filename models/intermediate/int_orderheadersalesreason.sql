with

  orderheadersalesreason as (
    select
        sales_order_reason_pk
        , sales_order_pk
        , sales_reason_fk
    from {{ ref('stg_erp__sales_salesorderheadersalesreason') }}
)

select * from orderheadersalesreason
