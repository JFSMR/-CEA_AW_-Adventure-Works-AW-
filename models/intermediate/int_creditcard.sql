with
creditcard as (
    select
     creditcard_pk
     , card_type
     , card_number
    from {{ ref('stg_erp__sales_creditcard') }}
)

select*
from creditcard