with 

source as (

    select * from {{ source('erp', 'sales_salesterritory') }}

),

renamed as (

    select

    CAST(territoryid AS INT) AS sales_territory_pk
        , CAST(name AS VARCHAR) AS name
        , CAST(countryregioncode AS VARCHAR) AS country_region_code_fk
        , CAST(salesytd AS NUMERIC(18,2)) AS sales_ytd
        , CAST(saleslastyear AS NUMERIC(18,2)) AS sales_last_year
        -- , CAST(costytd AS FLOAT) AS cost_ytd          -- Ocultado por estar zerado
        -- , CAST(costlastyear AS FLOAT) AS cost_last_year -- Ocultado por estar zerado
        , CAST(rowguid AS VARCHAR) AS rowguid
        , CAST(modifieddate AS DATE) AS modified_date

    from source

)

select * from renamed
