with 

source as (

    select * from {{ source('erp', 'sales_salesreason') }}

),

renamed as (

    select
        cast(salesreasonid as int) as sales_reason_pk
        , cast(name as VARCHAR) as name_reason
        , cast(reasontype as VARCHAR) as type_reason

        --Colunas técnicas ou complementares que não respondem diretamente às perguntas

       -- , cast(modifieddate as DATE) 

    from source

)

select * from renamed
