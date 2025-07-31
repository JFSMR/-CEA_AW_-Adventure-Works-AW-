with
 metrics as (
    select *
    from {{ ref('int_metrics_sales') }}
    
    
)

select *
from metrics

