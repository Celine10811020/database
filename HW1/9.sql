SELECT
  diff_hitting_rate AS hit_rate_diff,
  winning_rate AS win_rate
FROM (
  SELECT
    game_id,
    ROUND(diff_hitting_rate, 2) AS diff_hitting_rate,
    win_or_lose,
    AVG(win_or_lose) OVER (ORDER BY diff_hitting_rate DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS winning_rate
  FROM (
    SELECT
      game_id,
      FLOOR(diff_hitting_rate * 100) / 100 AS diff_hitting_rate,
      win_or_lose
    FROM (
      SELECT
        game_id,
        SUM(hit_rate) AS diff_hitting_rate,
        1 AS win_or_lose
      FROM (
        SELECT
          game_id,
          team,
          winner,
          CASE
            WHEN team = winner THEN hitting_rate
            ELSE hitting_rate * -1
          END AS hit_rate
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
      UNION
      SELECT
        game_id,
        SUM(hit_rate) AS diff_hitting_rate,
        0 AS win_or_lose
      FROM (
        SELECT
          game_id,
          team,
          winner,
          CASE
            WHEN team = winner THEN hitting_rate * -1
            ELSE hitting_rate
          END AS hit_rate
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
    ) AS win_or_lose_hitting_rate
    ORDER BY diff_hitting_rate DESC
  ) AS order_by_diff_hitting_rate
) AS final_one
WHERE winning_rate > 0.95
ORDER BY 
  winning_rate ASC, 
  diff_hitting_rate ASC
LIMIT 1;
