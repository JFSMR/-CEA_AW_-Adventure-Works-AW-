with 

source as (

    select * from {{ source('erp', 'production_productsubcategory') }}

),

renamed as (

    select
  CAST(productsubcategoryid AS INT) AS product_subcategory_pk
    , CAST(productcategoryid AS INT) AS product_category_fk
    , CAST(name AS VARCHAR) AS name
    , CAST(modifieddate AS DATE) AS modified_date
    , CAST(rowguid AS VARCHAR) AS rowguid


    from source

)

select * from renamed
