WITH player_season_totals AS (
    SELECT
        player_id,
        player_name,
        season,
        SUM(points) as total_points,
        COUNT(DISTINCT game_id) as games_played,
        ROUND(SUM(points) / COUNT(DISTINCT game_id), 2) as points_per_game
    FROM 
        {{ ref('stg_player_game_logs') }}
    GROUP BY 
        player_id,
        player_name,
        season
),

ranked_players AS (
    SELECT 
        player_id,
        player_name,
        season,
        total_points,
        games_played,
        points_per_game,
        ROW_NUMBER() OVER (PARTITION BY season ORDER BY total_points DESC) as scoring_rank
    FROM 
        player_season_totals
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
ORDER BY 
    season DESC