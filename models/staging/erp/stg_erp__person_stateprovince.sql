with 

source as (

    select * from {{ source('erp', 'person_stateprovince') }}

),

renamed as (

    select
       
    CAST(stateprovinceid AS INT) AS state_province_pk
  , CAST(territoryid AS INT) AS sales_territory_fk
  , CAST(stateprovincecode AS VARCHAR) AS state_province_cod_fk
  , CAST(countryregioncode AS VARCHAR) AS country_region_fk
  , CAST(name AS VARCHAR) AS name_state
  --, CAST(isonlystateprovinceflag AS BOOLEAN) AS is_only_state_province_flag
  --, CAST(rowguid AS VARCHAR) AS rowguid
 -- , CAST(modifieddate AS DATE) AS modified_date -- Não iremos usar no projeto


    from source

)

select * from renamed
