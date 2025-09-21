{{
  config(
    materialized = 'table'
  )
}}

WITH player_season_stats AS (
    SELECT 
        player_id,
        player_name,
        season,
        SUM(points) as total_points,
        COUNT(DISTINCT game_id) as games_played,
        ROUND(AVG(points), 2) as points_per_game
    FROM 
        {{ ref('stg_player_game_logs') }}
    WHERE 
        game_type = 'Regular Season'  -- Focusing on regular season stats only
    GROUP BY 
        player_id,
        player_name,
        season
),

ranked_players AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY season 
            ORDER BY total_points DESC
        ) as scoring_rank
    FROM 
        player_season_stats
)

SELECT 
    season,
    player_name,
    total_points,
    games_played,
    points_per_game
FROM 
    ranked_players
WHERE 
    scoring_rank = 1
ORDER BY 
    season DESC