with 

source as (

    select * from {{ source('erp', 'production_productcategory') }}

),

renamed as (

    select
        cast(productcategoryid AS INT) AS produto_category_pk
        , cast(name AS VARCHAR )       AS category_name


       -- , casts(rowguid
        --, casts(modifieddate

    from source

)

select * from renamed
