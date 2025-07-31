with 

source as (

    select * from {{ source('erp', 'production_productsubcategory') }}

),

renamed as (

    select
     cast(productsubcategoryid AS INT )  AS sub_category_pk
        , cast(productcategoryid AS INT) AS produto_category_fk
        , CAST(name AS  VARCHAR)         AS sub_name_catergory

        --, rowguid,
        --, modifieddate

    from source

)

select * from renamed
