SELECT
  Team,
  players.Name AS Hitter,
  avg_hit_rate,
  tol_hit,
  win_rate
FROM (
    SELECT
    Team,
    player_id,
    avg_hit_rate,
    tol_hit,
    win_rate
  FROM (
    SELECT 
      team AS Team,
      player_id,
      hitting_rate AS avg_hit_rate,
      total_hit AS tol_hit,
      win_rate,
      ROW_NUMBER() OVER (PARTITION BY team ORDER BY hitting_rate DESC) AS rate_place
    FROM (
      SELECT
        player_id,
        team,
        SUM(AB) AS total_hit,
        ROUND(AVG(hit_rate), 4) AS hitting_rate,
        win_rate
      FROM (
        SELECT 
          H, 
          AB, 
          H / AB AS hit_rate,
          Game,
          Hitter_Id AS player_id,
          new_hitters.Team AS team,
          top_winning_rate_team.winning_rate AS win_rate
        FROM (
          SELECT * 
          FROM hitters
          WHERE 
            AB > 0 AND
            Game IN (
              SELECT Game
              FROM games
              WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
            )
        ) AS new_hitters 
        JOIN (
          SELECT
            team,
            winning_rate
          FROM (
            SELECT 
              team, 
              SUM(CASE WHEN team_score > enemy_score THEN 1 ELSE 0 END) AS total_wins,
              COUNT(*) AS total_games,
              ROUND(SUM(CASE WHEN team_score > enemy_score THEN 1 ELSE 0 END) / COUNT(*), 4) AS winning_rate
            FROM (
              SELECT
                Game AS game_id,
                home AS team,
                home_score AS team_score,
                away_score AS enemy_score
              FROM games
              WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
              UNION ALL
              SELECT 
                Game AS game_id,
                away AS team,
                away_score AS team_score,
                home_score AS enemy_score
              FROM games
              WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
            ) AS new_games_table
            GROUP BY 
              team
            ORDER BY winning_rate DESC
            LIMIT 5
          ) AS top_winning_rate
        ) AS top_winning_rate_team
        ON top_winning_rate_team.team = new_hitters.Team
      ) AS hitters_hitting_rate
      GROUP BY
        player_id, team
      ORDER BY hitting_rate ASC
    ) AS new_table_2
  WHERE 
    hitting_rate IS NOT NULL AND
    total_hit >= 100
  ORDER BY win_rate DESC
  ) AS final_table
WHERE rate_place = 1
) AS really_final_one
JOIN players
ON really_final_one.player_id = players.Id;
