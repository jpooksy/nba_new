select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select full_name
from NBA.staging.stg_common_player_info
where full_name is null



      
    ) dbt_internal_test