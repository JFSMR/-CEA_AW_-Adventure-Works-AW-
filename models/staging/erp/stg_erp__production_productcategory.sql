with 

source as (

    select * from {{ source('erp', 'production_productcategory') }}

),

renamed as (

    select

     --  Colunas úteis para análise de negócio
    CAST(productcategoryid AS INT)   AS product_category_pk
    , CAST(name AS VARCHAR)          AS productc_name  

    -- Colunas técnicas ou complementares que não respondem diretamente às perguntas
    --, CAST(modifieddate AS DATE)     AS modified_date
    -- , CAST(rowguid AS VARCHAR)       AS rowguid


    from source

)

select * from renamed
