with 
source as (
    select * from {{ source('erp', 'sales_salesperson') }}
)
,
renamed as (
    select
        cast(businessentityid as int) as salesperson_pk
        ,cast(salesquota as numeric) as sales_quota
        ,cast(bonus as numeric) as bonus
        ,cast(commissionpct as numeric) as commission_pct
        ,cast(salesytd as numeric) as sales_ytd
        ,cast(saleslastyear as numeric) as sales_last_year
        ,cast(rowguid as string) as row_guid
        --,cast(modifieddate as DATE) as modified_date
    from source
)

select * from renamed
