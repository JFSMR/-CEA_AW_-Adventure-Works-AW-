with 

source as (

    select * from {{ source('erp', 'production_product') }}

),

renamed as (

    select

 
    CAST(productid AS INT) AS product_pk
  , CAST(productsubcategoryid AS INT) AS product_subcategory_fk
  , CAST(productmodelid AS INT) AS product_model_fk
  , CAST(safetystocklevel AS INT) AS safety_stock_level
  , CAST(reorderpoint AS INT) AS reorder_point
  , CAST(daystomanufacture AS INT) AS days_to_manufacture
  , CAST(standardcost AS NUMERIC(18,2)) AS standard_cost
  , CAST(listprice AS NUMERIC(18,2)) AS list_price
  , CAST(weight AS NUMERIC(18,2)) AS weight
  , CAST(makeflag AS BOOLEAN) AS make_flag
  , CAST(finishedgoodsflag AS BOOLEAN) AS finished_goods_flag
  , CAST(name AS VARCHAR) AS name
  , CAST(productnumber AS VARCHAR) AS product_number
  , CAST(color AS VARCHAR) AS color
  , CAST(size AS VARCHAR) AS size
  , CAST(sizeunitmeasurecode AS VARCHAR) AS size_unit_measure_code
  , CAST(weightunitmeasurecode AS VARCHAR) AS weight_unit_measure_code
  , CAST(productline AS VARCHAR) AS product_line
  , CAST(class AS VARCHAR) AS class
  , CAST(style AS VARCHAR) AS style
  , CAST(sellstartdate AS DATE) AS sell_start_date
  , CAST(sellenddate AS DATE) AS sell_end_date
  , CAST(discontinueddate AS DATE) AS discontinued_date
  , CAST(modifieddate AS DATE) AS modified_date
  , CAST(rowguid AS VARCHAR) AS rowguid


    from source

)

select * from renamed
