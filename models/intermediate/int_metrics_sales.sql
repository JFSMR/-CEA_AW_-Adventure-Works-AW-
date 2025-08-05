with

-- Import raw models
orderheader as (
    select
        salesorder_pk
        , customer_fk
        , territory_fk
        , address_fk
        , COALESCE(creditcard_fk, 0) as creditcard_fk
        , COALESCE(salesperson_fk, 0) as salesperson_fk
        , status
        , sub_total
        , total_due
        , order_date
    from {{ ref('stg_erp__sales_salesorderheader') }}
)

, salesorderdetail as (
    select
        sales_item_sk
        , sales_order_detail_pk
        , sales_order_fk
        , product_fk
        , specialoffer_fk
        , order_quantity
        , unit_price
        , unitpricediscount
    from {{ ref('stg_erp__sales_salesorderdetail') }}
)

, bridge as (
    select
        sales_order_reason_pk
        , sales_order_pk
        , sales_reason_fk
    from {{ ref('int_bridge_salesorder_salesreason') }}
)

, reason as (
    select 
        sales_reason_pk
        , name_reason
        , type_reason
    from {{ ref('int_sales_reason') }}
)

, credi as (
    select 
        creditcard_pk
        , card_type
        , card_number
    from {{ ref('int_creditcard') }}
)

-- Pré-agregando as razões de venda para garantir a unicidade por pedido
, aggregated_reasons as (
    select
        br.sales_order_pk
        , listagg(rs.name_reason, ', ') within group (order by rs.name_reason) as name_reason
        , listagg(rs.type_reason, ', ') within group (order by rs.type_reason) as type_reason
    from bridge br
    inner join reason rs
        on br.sales_reason_fk = rs.sales_reason_pk
    group by
        br.sales_order_pk
)

-- Join tables
, joined as (
    select
        sd.sales_item_sk
        , sd.sales_order_detail_pk
        , sd.sales_order_fk
        , sd.product_fk
        , sd.specialoffer_fk
        , oh.customer_fk
        , oh.territory_fk
        , oh.address_fk
        , oh.creditcard_fk
        , oh.salesperson_fk
        , sd.order_quantity
        , sd.unit_price
        , sd.unitpricediscount as discount
        , oh.status
        , oh.sub_total
        , oh.total_due
        , oh.order_date
        , coalesce(ar.name_reason, 'No Reason') as name_reason
        , coalesce(ar.type_reason, 'No Reason') as type_reason
    from salesorderdetail sd
    left join orderheader oh
        on sd.sales_order_fk = oh.salesorder_pk
    left join aggregated_reasons ar
        on sd.sales_order_fk = ar.sales_order_pk
    left join credi cd
        on oh.creditcard_fk = cd.creditcard_pk
)

-- Calculated metrics
, metrics as (
    select
        sales_item_sk
        , sales_order_fk
        , product_fk
        , customer_fk
        , address_fk
        , creditcard_fk
        , salesperson_fk
        , order_quantity
        , unit_price
        , discount
        , status
        , order_date
        , name_reason
        , type_reason

        -- Calculated metrics per grouped row
        , count(distinct sales_order_fk) as total_orders
        , sum(order_quantity) as total_quantity
        , unit_price * order_quantity as gross_total
        , unit_price * order_quantity * (1 - discount) as net_total
    from joined
    group by
        sales_item_sk
        , sales_order_fk
        , product_fk
        , customer_fk
        , address_fk
        , creditcard_fk
        , salesperson_fk
        , order_quantity
        , unit_price
        , discount
        , status
        , order_date
        , name_reason
        , type_reason
)

select *
from metrics



    

