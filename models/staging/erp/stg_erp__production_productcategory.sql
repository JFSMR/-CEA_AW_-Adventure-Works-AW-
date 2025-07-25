with 

source as (

    select * from {{ source('erp', 'production_productcategory') }}

),

renamed as (

    select
    CAST(productcategoryid AS INT) AS product_category_pk
    , CAST(name AS VARCHAR) AS name   
    , CAST(modifieddate AS DATE) AS modified_date
    , CAST(rowguid AS VARCHAR) AS rowguid


    from source

)

select * from renamed
