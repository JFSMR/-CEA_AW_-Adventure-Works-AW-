with 

source as (

    select * from {{ source('erp', 'sales_salesorderdetail') }}

),

renamed as (

    select

   {{ dbt_utils.generate_surrogate_key(['salesorderdetailid', 'salesorderid']) }} as sales_item_sk
     , CAST(salesorderdetailid AS INT)                                            AS sales_order_detail_pk      
      , CAST(salesorderid AS VARCHAR)                                             AS sales_order_fk             
      , CAST(productid AS INT)                                                    AS product_fk                 
      , CAST(specialofferid AS INT)                                               AS specialoffer_fk            
      , CAST(orderqty AS INT)                                                     AS order_quantity             
      , CAST(unitprice AS NUMERIC(18,4))                                          AS unit_price                 
      , CAST(unitpricediscount AS NUMERIC(18,4))                                  AS unitpricediscount          


    from source

)

select * from renamed
