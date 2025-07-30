with 

source as (

    select * from {{ source('erp', 'sales_salesorderheadersalesreason') }}

),

renamed as (

    select distinct
     {{ dbt_utils.generate_surrogate_key(['salesorderid', 'salesreasonid']) }} as sales_order_reason_pk
        ,cast(salesorderid as INT) as sales_order_pk
        ,cast(salesreasonid as INT) as sales_reason_fk
        --, CAST(modifieddate AS DATE) AS modified_date
    from source

)

select * from renamed
