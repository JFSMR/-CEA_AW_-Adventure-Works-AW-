-- CTE: Order Header - contains the main order information
with order_header as (
    select
          salesorder_pk as sales_order_id              
        , customer_fk                                  
        , territory_fk                                 
        , address_fk                                   
        , coalesce(creditcard_fk, 0) as creditcard_fk  
        , coalesce(salesperson_fk, 0) as salesperson_fk
        , ship_date 
        , order_date
        , status
    from {{ ref('stg_erp__sales_salesorderheader') }}
),

-- CTE: Sales Order Detail - contains detailed line items of each order
sales_order_detail as (
    select
          sales_order_fk        
        , product_fk            
        , order_quantity
        , unit_price
        , unitpricediscount as discount
        
    from {{ ref('stg_erp__sales_salesorderdetail') }}
),

-- CTE: Aggregated Sales - calculates order-level aggregated metrics
sales_aggregated as (
    select
          sales_order_fk as sales_order_id              
        , sum(order_quantity) as total_quantity
        , sum(unit_price * order_quantity) as gross_total
        , sum(unit_price * order_quantity * (1 - discount)) as net_total
    from sales_order_detail
    group by sales_order_fk
),

-- CTE: Sales Reason Bridge - links orders to sales reasons (many-to-many)
sales_reason_bridge as (
    select
          sales_order_pk as sales_order_id    
        , sales_reason_fk                     
    from {{ ref('int_orderheadersalesreason') }}
),

-- CTE: Sales Reason - dimension table for reasons associated with sales
sales_reason as (
    select
          sales_reason_pk                    
        , name_reason
        , type_reason
    from {{ ref('int_sales_reason') }}
),

-- CTE: Credit Card - dimension table for credit card information
credit_card as (
    select
          creditcard_pk                      
        , card_type
        , card_number
    from {{ ref('int_creditcard') }}
),

-- CTE: Joined - enriches order data with sales reason, credit card, and aggregated metrics
joined as (
    select
          oh.sales_order_id                   
        , oh.customer_fk                                      
        , oh.address_fk                       
        , oh.creditcard_fk                    
        , coalesce(cc.card_type, 'Not Provided') as card_type
        , coalesce(cc.card_number, '0000-0000-0000-0000') as card_number                
        , coalesce(rb.sales_reason_fk, -1) as sales_reason_fk
        , coalesce(sr.name_reason, 'Not Provided') as name_reason
        , coalesce(sr.type_reason, 'Not Provided') as type_reason
        , sod.product_fk                     
        , oh.order_date
        , oh.status
        , oh.ship_date
        , sa.total_quantity
        , sa.gross_total
        , sa.net_total
        , row_number() over (
            partition by oh.sales_order_id 
            order by rb.sales_reason_fk
          ) as row_num
    from order_header oh
    left join sales_aggregated sa on oh.sales_order_id = sa.sales_order_id
    left join sales_reason_bridge rb on oh.sales_order_id = rb.sales_order_id
    left join sales_reason sr on rb.sales_reason_fk = sr.sales_reason_pk
    left join credit_card cc on oh.creditcard_fk = cc.creditcard_pk
    left join sales_order_detail sod on oh.sales_order_id = sod.sales_order_fk
),

-- CTE: Metrics - final fact table structure with surrogate key
metrics as (
    select
          row_number() over (order by sales_order_id, sales_reason_fk
          ) as sales_order_fact_sk              
        , sales_order_id                        
        , customer_fk                                                    
        , address_fk                            
        , creditcard_fk                                            
        , sales_reason_fk                       
        , product_fk                            
        , card_type
        , card_number
        , name_reason
        , type_reason
        , order_date
        , ship_date
        , case 
            when status = 5 then 'Shipped'
        end as status  
        , case when row_num = 1 then total_quantity else 0 end as total_quantity
        , case when row_num = 1 then gross_total else 0 end as gross_total
        , case when row_num = 1 then net_total else 0 end as net_total
    from joined
)

-- Final SELECT: total gross and net sales per order date
select *
from metrics
