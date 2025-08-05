with 
reason as ( 
    
    select * 
    from {{ ref('stg_erp__SALES_SALESREASON') }}
    
)

select * 
from reason

   


