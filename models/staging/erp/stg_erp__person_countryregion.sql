with 

source as (

    select * from {{ source('erp', 'person_countryregion') }}

),

renamed as (

    select
      CAST(countryregioncode AS VARCHAR) AS country_region_pk
         , CAST(name AS VARCHAR) AS name_country
         --, CAST(modifieddate AS DATE) AS modified_date
        -- não faz parte do escpo do projeto

    from source

)

select * from renamed
