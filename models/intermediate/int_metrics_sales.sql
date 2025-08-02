with
-- importar os modelos brutos
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

-- juntar tabelas
joined as (
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
    from salesorderdetail sd
    inner join orderheader oh
        on sd.sales_order_fk = oh.salesorder_pk
),

-- métricas calculadas
metrics as (
    select
     sales_item_sk
    ,  sales_order_fk
    ,  product_fk
    ,  specialoffer_fk
    ,  customer_fk
    ,  territory_fk
    ,  address_fk
    ,  creditcard_fk
    ,  salesperson_fk
    ,  order_quantity
    ,  discount
    ,  (unit_price * order_quantity) as gross_total
    ,  (unit_price * (1 - discount) * order_quantity) as net_total
    ,  status
    ,  sub_total
    ,  total_due
    ,  order_date
   
    from joined
)

select *
from metrics



