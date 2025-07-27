with 

source as (

    select * from {{ source('erp', 'sales_salesorderdetail') }}

),

renamed as (

    select
       
        CAST(salesorderdetailid AS INT) AS sales_order_detail_pk
         , CAST(salesorderid AS VARCHAR) AS sales_order_fk     
         , CAST(productid AS INT) AS product_fk                
         , CAST(specialofferid AS INT) AS specialoffer_fk         
         , CAST(carriertrackingnumber AS VARCHAR) AS carriertrackingnumber
         , CAST(orderqty AS INT) AS order_quantity
         , CAST(unitprice AS NUMERIC(18,2)) AS unit_price
         , CAST(unitpricediscount AS NUMERIC(18,2)) AS unitpricediscount
         , CAST(modifieddate AS DATE) AS modifieddate
         , CAST(rowguid AS VARCHAR) AS rowguid

    from source

)

select * from renamed
