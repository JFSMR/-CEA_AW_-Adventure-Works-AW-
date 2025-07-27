
with source as (
    select * from {{ source('erp', 'sales_salesorderheadersalesreason') }}
),

renamed as (
    select                        
        cast(salesreasonid as INT) as sales_reason_pk
        , cast(salesorderid as INT) as salesorder_fk    
        --  , cast(modifieddate as DATETIME) as modified_date
        , ROW_NUMBER() OVER (PARTITION BY salesorderid ORDER BY salesreasonid) as rowN
    from source
)

select 
    sales_reason_pk
    ,salesorder_fk
    --,modified_date
from renamed
where rowN = 1
order by salesorder_fk





