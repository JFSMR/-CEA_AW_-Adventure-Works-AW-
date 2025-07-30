with 

source as (

    select * from {{ source('erp', 'sales_creditcard') }}

),

renamed as (

    select

     -- Colunas úteis para análise de negócio
     CAST(creditcardid AS INT)        AS creditcard_pk
     , CAST(cardtype AS VARCHAR)      AS card_type
     , CAST(cardnumber AS VARCHAR)    AS card_number

     ---Colunas técnicas ou complementares que não respondem diretamente às perguntas
     --, CAST(expmonth AS INT)        AS expmonth
     --, CAST(expyear AS INT)         AS exp_year
     --, CAST(modifieddate AS DATE)   AS modified_date 
     -- Não usaremos no projeto 

    from source

)

select * from renamed
