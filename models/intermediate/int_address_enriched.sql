with
 -- Importar os modelos: tabelas StateProvince, Address e Country

stateprovince as (
    select 
        state_province_pk
        , sales_territory_fk
        , state_province_cod_fk
        , country_region_fk
        , name_state
    from {{ ref('stg_erp__person_stateprovince') }}
)
,
    address as (
    select 
        address_pk
        , state_province_fk
        , address_line
        , city
    from {{ ref('stg_erp__person_address') }} 
    
)
,

country as (
    select 
        country_region_pk
        , name_country
    from {{ ref('stg_erp__person_countryregion') }} 
)
,
-- transformation joining the tables made with the initial of the tables

joined as (
    select 
        a.address_pk
        , a.address_line
        , a.city
        , sp.name_state
        , c.name_country
    from address a
    left join stateprovince sp
        on a.state_province_fk = sp.state_province_pk
    left join country c
        on sp.country_region_fk = c.country_region_pk

)

select * from joined
