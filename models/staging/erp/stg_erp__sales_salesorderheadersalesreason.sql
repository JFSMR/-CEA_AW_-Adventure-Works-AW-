with 

source as (

    select * from {{ source('erp', 'sales_salesorderheadersalesreason') }}

),

renamed as (

    select
       cast(salesreasonid as INT) as sales_reason_pk
        , cast(salesorderid as INT) as salesorder_fk     
        , cast(modifieddate as DATE) as modified_date

    from source

)

select * from renamed
