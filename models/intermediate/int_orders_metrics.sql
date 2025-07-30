with ssalesorderheader as (
    select
        salesorder_pk
        , customer_fk
        , territory_fk
        , address_fk
        , creditcard_fk
        , salesperson_fk
        , status
        , sub_total
        , total_due
        , order_date
    from {{ ref('stg_erp__sales_salesorderheader') }}
),

orderdetail as (
    select 
        sales_item_pk
        , sales_order_detail_pk
        , sales_order_fk
        , product_fk
        , specialoffer_fk
        , order_quantity
        , unit_price
        , unitpricediscount
    from {{ ref('stg_erp__sales_salesorderdetail') }}
),

salesreason as (
    select 
       sales_order_pk
       , sales_reason_fk
       , name_reason
       , type_reason
    from {{ ref('int_salesreason') }}
)
,
joined as (

 select
    od.sales_item_pk
    , od.sales_order_detail_pk
    , od.sales_order_fk
    , od.product_fk
    , od.specialoffer_fk
    , od.order_quantity
    , od.unit_price
    , od.unitpricediscount
    , oh.customer_fk
    , oh.territory_fk
    , oh.address_fk
    , oh.creditcard_fk
    , oh.status
    , oh.sub_total
    , oh.total_due
    , oh.order_date
    , sr.sales_reason_fk
    , sr.name_reason
    , sr.type_reason
from orderdetail od
inner join ssalesorderheader oh
    on od.sales_order_fk = oh.salesorder_pk
inner join salesreason sr
    on oh.salesorder_pk = sr.sales_order_pk
)
,
 metrics as (
    select
        sales_item_pk
        , sales_order_detail_pk
        , sales_order_fk
        , product_fk
        , specialoffer_fk
        , order_quantity
        , unit_price
        , unitpricediscount
        , customer_fk
        , territory_fk
        , address_fk
        , creditcard_fk
        , status
        , sub_total
        , total_due
        , order_date
        , sales_reason_fk
        , name_reason
        , type_reason

        -- Calculated metrics
        , unit_price * order_quantity as gross_sales_value
        , unit_price * order_quantity * (1 - unitpricediscount) as net_sales_value
        , 1 as order_count

    from joined
)

 select * 
 from metrics
    


