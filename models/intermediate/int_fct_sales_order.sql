with

-- CTE for staging sales order header data
orderheader as (
  select
      salesorder_pk
    , customer_fk
    , territory_fk
    , address_fk
    , coalesce(creditcard_fk, 0) as creditcard_fk
    , coalesce(salesperson_fk, 0) as salesperson_fk
    , status
    , sub_total
    , total_due
    , order_date
  from {{ ref('stg_erp__sales_salesorderheader') }}
),

-- CTE for staging sales order detail data, aliasing unitpricediscount as discount
salesorderdetail as (
    select
        sales_item_sk
      , sales_order_detail_pk
      , sales_order_fk
      , product_fk
      , specialoffer_fk
      , order_quantity
      , unit_price
      , unitpricediscount as discount
    from {{ ref('stg_erp__sales_salesorderdetail') }}
),

-- New CTE to aggregate metrics at the order level to avoid fan-out issues
sales_aggregated as (
    select
        sales_order_fk
      , sum(order_quantity) as total_quantity_by_order
      , sum(unit_price * order_quantity) as gross_total_by_order
      , sum(unit_price * order_quantity * (1 - discount)) as net_total_by_order
    from salesorderdetail
    group by sales_order_fk
),

-- CTE for the bridge table linking sales orders to sales reasons
bridge as (
  select
      sales_order_pk
    , sales_reason_fk
  from {{ ref('int_orderheadersalesreason') }}
),

-- CTE for the sales reason dimension table
reason as (
  select
      sales_reason_pk
    , name_reason
    , type_reason
  from {{ ref('int_sales_reason') }}
),

-- CTE for the credit card dimension table
credi as (
  select
      creditcard_pk
    , card_type
    , card_number
  from {{ ref('int_creditcard') }}
),

-- CTE to join all the previous CTEs into a single view
joined as (
  select
      oh.salesorder_pk as sales_order_fk
    , oh.customer_fk
    , oh.territory_fk
    , oh.address_fk
    , oh.creditcard_fk
    , oh.salesperson_fk
    , oh.status
    , oh.order_date
    , sa.gross_total_by_order
    , sa.net_total_by_order
    , sa.total_quantity_by_order
    -- Use COALESCE to handle NULL values for BI dashboards
    , coalesce(r.sales_reason_pk, -1) as sales_reason_pk
    , coalesce(r.name_reason, 'Não Informado') as name_reason
    , coalesce(r.type_reason, 'Não Informado') as type_reason
    , coalesce(cd.card_type, 'Não Informado') as card_type
    , coalesce(cd.card_number, 'Não Informado') as card_number
    -- CRUCIAL CORREÇÃO : Use ROW_NUMBER para identificar a primeira linha de cada pedido
    -- Isso permitirá que a soma seja feita apenas uma vez
    , row_number() over (partition by oh.salesorder_pk order by r.sales_reason_pk) as row_num_per_order
  from orderheader oh
  left join sales_aggregated sa
    on oh.salesorder_pk = sa.sales_order_fk
  left join bridge b
    on oh.salesorder_pk = b.sales_order_pk
  left join reason r
    on b.sales_reason_fk = r.sales_reason_pk
  left join credi cd
    on oh.creditcard_fk = cd.creditcard_pk
),

-- CTE to calculate aggregated metrics for each sales item
metrics as (
  select
      -- Add the surrogate key for the fact table
      row_number() over (order by sales_order_fk, sales_reason_pk) as sk_sales_order_fact
    , sales_order_fk
    , customer_fk
    , address_fk
    , creditcard_fk
    , salesperson_fk
    , status
    , order_date
    , sales_reason_pk
    , name_reason
    , type_reason
    , card_type
    , card_number
    , count(distinct sales_order_fk) as total_orders
    , sum(total_quantity_by_order) as total_quantity
    -- CRUCIAL CORREÇÃO : Use a agregação condicional para somar o gross_total
    -- apenas uma vez por pedido, mesmo com a duplicação de linhas.
    , sum(case when row_num_per_order = 1 then gross_total_by_order else 0 end) as gross_total
    , sum(case when row_num_per_order = 1 then net_total_by_order else 0 end) as net_total
  from joined
  group by
      sales_order_fk
    , customer_fk
    , address_fk
    , creditcard_fk
    , salesperson_fk
    , status
    , order_date
    , sales_reason_pk
    , name_reason
    , type_reason
    , card_type
    , card_number
)

select * from metrics