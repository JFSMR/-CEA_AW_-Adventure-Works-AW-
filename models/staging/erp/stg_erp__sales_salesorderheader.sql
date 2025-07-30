with 

source as (

    select * from {{ source('erp', 'sales_salesorderheader') }}

),

renamed as (
SELECT
    -- Colunas úteis para análise de negócio
     CAST(salesorderid AS INT)                   AS salesorder_pk              
    ,CAST(customerid AS INT)                     AS customer_fk                
    ,CAST(territoryid AS INT)                    AS territory_fk               
    ,CAST(billtoaddressid AS INT)                AS address_fk              
    ,CAST(creditcardid AS INT)                   AS creditcard_fk
    ,CAST(salespersonid AS INT)                  AS salesperson_fk                
    ,CAST(status AS INT)                         AS status 
    ,CAST(subtotal AS NUMERIC(18,2))             AS sub_total                  
    ,CAST(totaldue AS NUMERIC(18,2))             AS total_due                 
    ,CAST(orderdate AS DATE)                     AS order_date                  

    -- Colunas não necessárias para responder às perguntas de negócio
    -- ,CAST(freight AS NUMERIC(18,2))             AS freight                     
    -- ,CAST(taxamt AS NUMERIC(18,2))              AS taxamt                    
    -- ,CAST(shiptoaddressid AS INT)               AS shiptoaddress_fk       
    -- ,CAST(shipmethodid AS INT)                  AS shipmethod_fk      
    -- ,CAST(currencyrateid AS INT)                AS currencyrate_fk   
    -- ,CAST(revisionnumber AS INT)                AS revisionnumber       
    -- ,CAST(duedate AS DATE)                      AS due_date                  
    -- ,CAST(shipdate AS DATE)                     AS ship_date            
    -- ,CAST(modifieddate AS DATE)                 AS modifie_ddate             
    -- ,CAST(onlineorderflag AS BOOLEAN)           AS online_order_flag        
    -- ,CAST(purchaseordernumber AS VARCHAR)       AS purchase_order_number      
    -- ,CAST(accountnumber AS VARCHAR)             AS account_number         
    -- ,CAST(creditcardapprovalcode AS VARCHAR)    AS credit_card_approval_code 
    -- ,CAST(rowguid AS VARCHAR)                   AS rowguid             
    -- ,CAST(comment AS VARCHAR)                   AS comment                
       
FROM source


)

select * from renamed
