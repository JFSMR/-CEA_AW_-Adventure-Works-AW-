with 

source as (

    select * from {{ source('erp', 'sales_customer') }}

),

renamed as (

    select
       CAST(customerid AS INT)                  AS customer_pk
       , CAST(personid AS INT)                  AS person_fk
       , CAST(storeid AS INT)                   AS store_fk
       , CAST(territoryid AS INT)               AS territory_fk
       --, CAST(rowguid AS VARCHAR)               AS rowguid
       --, CAST(modifieddate AS DATE)             AS modified_date

    from source

)

select * from renamed
