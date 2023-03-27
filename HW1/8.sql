SELECT
  2020_player.Pitcher_id,
  AVG(avg_K_IP) AS 2020_avg_K_IP
FROM (
  SELECT DISTINCT
    Pitcher_id,
    K,
    IP,
    9 * K / IP AS avg_K_IP
  FROM
    games
  JOIN
    pitchers
  ON pitchers.Game = games.Game
  WHERE 
    (DATE_FORMAT(games.Date, '%Y') = "2020" OR
    DATE_FORMAT(games.Date, '%Y') = "2021") AND
    IP > 0
  ORDER BY Pitcher_Id ASC
) AS 2020_player
JOIN (
  SELECT 
    new_two_team_player.Pitcher_Id AS Pitcher_Id
  FROM (
    SELECT DISTINCT
      Pitcher_id
    FROM (
      SELECT
        Team,
        team_player.Pitcher_id,
        ROW_NUMBER() OVER (PARTITION BY Pitcher_id ORDER BY Team ASC) AS team_num
      FROM (
        SELECT DISTINCT
          Team,
          Pitcher_id
        FROM
          games
        JOIN
          pitchers
        ON pitchers.Game = games.Game
        WHERE 
          (DATE_FORMAT(games.Date, '%Y') = "2020" OR
          DATE_FORMAT(games.Date, '%Y') = "2021") AND
          IP > 0
        ORDER BY Pitcher_Id ASC
      ) AS team_player
    ) AS two_team_player
    WHERE team_num = 2
  ) AS new_two_team_player
  JOIN (
    SELECT DISTINCT
      Pitcher_id
    FROM (
      SELECT
        player_year.Pitcher_id,
        date,
        ROW_NUMBER() OVER (PARTITION BY Pitcher_id ORDER BY date ASC) AS year_num
      FROM (
        SELECT DISTINCT
          Pitcher_id,
          DATE_FORMAT(games.Date, '%Y') AS date
        FROM
          games
        JOIN
          pitchers
        ON pitchers.Game = games.Game
        WHERE 
          (DATE_FORMAT(games.Date, '%Y') = "2020" OR
          DATE_FORMAT(games.Date, '%Y') = "2021") AND
          IP > 0
        ORDER BY Pitcher_Id ASC
      ) AS player_year
      JOIN (
        SELECT
          Pitcher_Id,
          SUM(IP) AS total_inning
        FROM
          pitchers
        JOIN
          games
        ON pitchers.Game = games.Game
        WHERE 
          (DATE_FORMAT(games.Date, '%Y') = "2020" OR
          DATE_FORMAT(games.Date, '%Y') = "2021") AND
          IP > 0
        GROUP BY Pitcher_Id
        HAVING total_inning > 50
        ORDER BY Pitcher_Id ASC
      ) AS fifty_inning_player
      ON player_year.Pitcher_Id = fifty_inning_player.Pitcher_Id
    ) AS two_year_player
    WHERE year_num = 2
  ) AS new_two_year_player
  ON new_two_team_player.Pitcher_Id = new_two_year_player.Pitcher_Id
) AS changed_player
ON 2020_player.Pitcher_Id = changed_player.Pitcher_Id
GROUP BY Pitcher_Id
