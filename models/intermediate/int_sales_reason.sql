with 
reason as ( 
    
    select * 
    from {{ ref('stg_erp__sales_salesreason') }}
    
)

select * 
from reason

   


