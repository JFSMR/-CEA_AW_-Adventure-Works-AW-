with
products as (
    select
         product_pk
        ,product_subcategory_fk
        ,product_model_fk
        ,name_product
        ,list_price
    from {{ ref('stg_erp__production_product') }}
)

,subcategory as (
    select 
         product_subcategory_pk
        ,product_category_fk
        ,product_name as name_subcategory
    from {{ ref('stg_erp__production_productsubcategory') }}
)

,category as (
    select 
         product_category_pk
        ,productc_name as name_category
    from {{ ref('stg_erp__production_productcategory') }}
)

,joined as (
    select
         p.product_pk
        ,p.name_product
        ,p.list_price
        ,s.product_subcategory_pk as product_subcategory_id
        ,s.name_subcategory
        ,c.product_category_pk as product_category_id
        ,c.name_category
    from products p
    left join subcategory s
        on p.product_subcategory_fk = s.product_subcategory_pk
    inner join category c
        on s.product_category_fk = c.product_category_pk
)

select * from joined
