SELECT
  game_id,
  SUM(hitting_rate) AS diff_hitting_rate
FROM (
  SELECT
    game_id,
    team,
    winner,
    CASE
      WHEN team = winner THEN hitting_rate
      ELSE hitting_rate * -1
    END AS hitting_rate
  FROM (
    SELECT
      hitters.Game AS game_id,
      Team AS team,
      winner,
      AVG(H / AB) AS hitting_rate
    FROM
      hitters
    JOIN (
      SELECT 
        Game,
        CASE
          WHEN home_score > away_score THEN home
          WHEN away_score > home_score THEN away
          ELSE 'Tie'
        END AS winner
      FROM games
      WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
    ) AS winner_in_2021
    ON hitters.Game = winner_in_2021.Game
    GROUP BY game_id, team
  ) AS game_and_hitting_rate
) AS game_and_diff_hitting_rate
GROUP BY game_id
