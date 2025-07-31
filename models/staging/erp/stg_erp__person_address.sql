with 
--stg_erp__person_address
source as (

    select * from {{ source('erp', 'person_address')  }}

),

renamed as (

    select
       CAST(addressid AS INT)          AS address_pk
      , CAST(stateprovinceid AS VARCHAR)   AS state_province_fk      
      , CAST(addressline1 AS VARCHAR)  AS address
        ,CAST(city AS VARCHAR)         AS city

     --Colunas técnicas ou complementares que não respondem diretamente às perguntas

      --, CAST(addressline2 AS VARCHAR) AS address_line2    
     --, CAST(postalcode AS VARCHAR) AS postal_code
      --, CAST(spatiallocation AS VARCHAR) AS spatial_location
     -- , CAST(rowguid AS VARCHAR) AS rowguid
      --, CAST(modifieddate AS DATE) AS modified_date
    from source

)

select * from renamed
