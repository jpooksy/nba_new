
    
    

select
    player_id as unique_field,
    count(*) as n_records

from NBA.staging.stg_common_player_info
where player_id is not null
group by player_id
having count(*) > 1


