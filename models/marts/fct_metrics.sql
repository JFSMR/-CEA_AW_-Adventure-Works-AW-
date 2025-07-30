with
 metrics as (
    select *
    from {{ ref('int_orders_metrics') }}
 )

 select *
 from metrics