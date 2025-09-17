
  create or replace   view NBA.dbt_parker.mart_season_scoring_leaders
  
   as (
    WITH player_season_stats AS (
    SELECT
        player_id,
        player_name,
        season,
        SUM(points) as total_pts,
        COUNT(DISTINCT game_id) as games_played,
        ROUND(SUM(points)::FLOAT / COUNT(DISTINCT game_id), 2) as points_per_game
    FROM 
        NBA.staging.stg_player_game_logs
    GROUP BY 
        player_id,
        player_name,
        season
),

ranked_players AS (
    SELECT 
        season,
        player_id,
        player_name,
        total_points,
        games_played,
        points_per_game,
        ROW_NUMBER() OVER (PARTITION BY season ORDER BY total_points DESC) as scoring_rank
    FROM 
        player_season_stats
)

SELECT
    season,
    player_id,
    player_name,
    total_points,
    games_played,
    points_per_game
FROM 
    ranked_players
WHERE 
    scoring_rank = 1
  );

