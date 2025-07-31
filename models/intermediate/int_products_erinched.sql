with

products as (
    select
          product_pk
        , product_subcategory_fk
        , name_product
        , list_price 
    from {{ ref('stg_erp__production_product') }}
),


subcategory as (
    select 
          sub_category_pk
        , produto_category_fk
        , sub_name_catergory
    from {{ ref('stg_erp__production_productsubcategory') }}
),


category as (
    select 
          produto_category_pk
        , category_name
    from {{ ref('stg_erp__production_productcategory') }}
),


joined as (
    select
          p.product_pk
        , p.product_subcategory_fk     
        , p.name_product
        , p.list_price
        , c.category_name
        , s.sub_name_catergory
    from products p
        left join subcategory s 
            on p.product_subcategory_fk = s.sub_category_pk
        inner join category c
            on s.produto_category_fk = c.produto_category_pk
)


select *
from joined
