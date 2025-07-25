with 

source as (

    select * from {{ source('erp', 'sales_creditcard') }}

),

renamed as (

    select
     CAST(creditcardid AS INT) AS creditcard_pk
    , CAST(cardtype AS VARCHAR) AS card_type
    , CAST(cardnumber AS VARCHAR) AS card_number
    , CAST(expmonth AS INT) AS expmonth
    , CAST(expyear AS INT) AS exp_year
    , CAST(modifieddate AS DATE) AS modified_date

    from source

)

select * from renamed
