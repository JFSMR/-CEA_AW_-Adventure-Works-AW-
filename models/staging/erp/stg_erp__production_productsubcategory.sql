with 

source as (

    select * from {{ source('erp', 'production_productsubcategory') }}

),

renamed as (

    select
    --  Colunas úteis para análise de negócio
  CAST(productsubcategoryid AS INT)    AS product_subcategory_pk
    , CAST(productcategoryid AS INT)   AS product_category_fk
    , CAST(name AS VARCHAR)            AS product_name
    
--Colunas técnicas ou complementares que não respondem diretamente às perguntas

    --, CAST(modifieddate AS DATE)       AS modified_date
    --, CAST(rowguid AS VARCHAR)         AS rowguid


    from source

)

select * from renamed
