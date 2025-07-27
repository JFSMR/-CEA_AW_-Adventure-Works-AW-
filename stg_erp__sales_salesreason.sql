with 

source as (

    select * from {{ source('erp', 'sales_salesreason') }}

),

renamed as (

    select
        
    CAST(salesreasonid AS INT) AS sales_reason_pk
  , CAST(name AS VARCHAR) AS name
  , CAST(reasontype AS VARCHAR) AS reason_type
  , CAST(modifieddate AS DATE) AS modified_date


    from source

)

select * from renamed
