-- Extracts key fields from the sales order header table, including customer, territory, address, credit card, salesperson, status, financial totals, and order date.
with orderheader as (
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

-- Retrieves detailed item-level data per sales order: products, quantity, unit price and discounts.
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

-- Aggregates item-level data by order to compute total quantity, gross total (pre-discount), and net total (post-discount).
sales_aggregated as (
    select
        sales_order_fk
      , sum(order_quantity) as total_quantity_by_order
      , sum(unit_price * order_quantity) as gross_total_by_order
      , sum(unit_price * order_quantity * (1 - discount)) as net_total_by_order
    from salesorderdetail
    group by sales_order_fk
),

-- Bridge table linking sales orders to their respective reason identifiers.
bridge as (
  select
      sales_order_pk
    , sales_reason_fk
  from {{ ref('int_orderheadersalesreason') }}
),

-- Fetches details about sales reasons, including their name and type.
reason as (
  select
      sales_reason_pk
    , name_reason
    , type_reason
  from {{ ref('int_sales_reason') }}
),

-- Retrieves credit card data used in orders, such as type and number.
credi as (
  select
      creditcard_pk
    , card_type
    , card_number
  from {{ ref('int_creditcard') }}
),

-- Joins all intermediate data sets to create an enriched fact-level view of sales orders.
-- Includes credit card info, sales reasons, product, and calculated metrics per order.
joined as (
  select
      oh.salesorder_pk as sales_order_fk
    , oh.customer_fk
    , oh.address_fk
    , oh.creditcard_fk
    , oh.salesperson_fk
    , oh.status
    , oh.order_date
    , sa.gross_total_by_order
    , sa.net_total_by_order
    , sa.total_quantity_by_order
    , coalesce(b.sales_reason_fk, -1) as sales_reason_fk
    , coalesce(r.name_reason, 'Não Informado') as name_reason
    , coalesce(r.type_reason, 'Não Informado') as type_reason
    , coalesce(cd.card_type, 'Não Informado') as card_type
    , coalesce(cd.card_number, 'Não Informado') as card_number
    , sod.product_fk
    , sod.unit_price
    , sod.discount
    , sod.order_quantity 
    , row_number() over (partition by oh.salesorder_pk order by b.sales_reason_fk) as row_num_per_order
  from orderheader oh
  left join sales_aggregated sa on oh.salesorder_pk = sa.sales_order_fk
  left join bridge b on oh.salesorder_pk = b.sales_order_pk
  left join reason r on b.sales_reason_fk = r.sales_reason_pk
  left join credi cd on oh.creditcard_fk = cd.creditcard_pk
  inner join salesorderdetail sod on oh.salesorder_pk = sod.sales_order_fk
),

-- Calculates final metrics, aggregates data per sales order, and assigns a surrogate key for each fact row.
metrics as (
  select
      row_number() over (order by sales_order_fk, sales_reason_fk) as sales_order_fact_sk
    , sales_order_fk
    , customer_fk
    , address_fk
    , creditcard_fk
    , product_fk
    , sales_reason_fk
    , status
    , order_date
    , name_reason
    , type_reason
    , card_type
    , card_number
    , unit_price
    , discount
    , order_quantity
    , count(distinct sales_order_fk) as total_orders
    , sum(total_quantity_by_order) as total_quantity
    , sum(case when row_num_per_order = 1 then gross_total_by_order else 0 end) as gross_total
    , sum(case when row_num_per_order = 1 then net_total_by_order else 0 end) as net_total
  from joined
  group by
      sales_order_fk
    , customer_fk
    , address_fk
    , creditcard_fk
    , product_fk
    , sales_reason_fk
    , order_quantity
    , unit_price
    , discount
    , status
    , order_date
    , name_reason
    , type_reason
    , card_type
    , card_number
)

-- Final result with all computed metrics.
select * from metrics
