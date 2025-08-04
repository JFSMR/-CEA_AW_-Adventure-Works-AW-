with
-- import raw models
orderheader as (
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

salesorderdetail as (
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
),

-- join tables
joined as (
    select
      sd.sales_item_sk
    , sales_order_detail_pk      
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
    from salesorderdetail sd
    inner join orderheader oh
        on sd.sales_order_fk = oh.salesorder_pk
),

-- calculated metrics
metrics as (
    select
        sales_item_sk
        , sales_order_fk as sales_order_id
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

        -- calculated metrics per grouped row
        , count(distinct sales_order_fk) as total_orders
        , sum(order_quantity) as total_quantity
        , unit_price * order_quantity as gross_total
        , unit_price * order_quantity * (1 - discount) as net_total

    from joined
    group by
        sales_item_sk
        , sales_order_id
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
)

select *
from metrics
