with 

source as (

    select * from {{ source('erp', 'person_countryregion') }}

),

renamed as (

    select
      CAST(countryregioncode AS VARCHAR) AS country_region_pk
         , CAST(name AS VARCHAR)         AS name_country
         --, CAST(modifieddate AS DATE) AS modified_date
         --Colunas técnicas ou complementares que não respondem diretamente às perguntas
    from source

)

select * from renamed


