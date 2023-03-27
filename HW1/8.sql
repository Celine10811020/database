SELECT
  Pitcher,
  cnt,
  `2020_avg_K/9`,
  `2021_avg_K/9`,
  CONCAT(`2020_PC`, '-', `2020_ST`) AS `2020_PC-ST`,
  CONCAT(`2021_PC`, '-', `2021_ST`) AS `2021_PC-ST`
FROM (
  SELECT 
    *
  FROM (
    SELECT
      'Changed' AS Pitcher,
      COUNT(*) AS cnt,
      ROUND(AVG(2020_avg_K_IP), 4) AS `2020_avg_K/9`,
      ROUND(AVG(2020_PC), 4) AS `2020_PC`,
      ROUND(AVG(2020_ST), 4) AS `2020_ST`
    FROM (
      SELECT
        2020_player.Pitcher_id AS Pitcher_id,
        AVG(avg_K_IP) AS 2020_avg_K_IP,
        AVG(PC) AS 2020_PC,
        AVG(ST) AS 2020_ST
      FROM (
        SELECT
          Pitcher_id,
          CAST(SUBSTRING_INDEX(PC_ST, '-', 1) AS UNSIGNED) AS PC,
          CAST(SUBSTRING_INDEX(PC_ST, '-', -1) AS UNSIGNED) AS ST,
          PC_ST,
          K,
          IP,
          9 * K / IP AS avg_K_IP
        FROM
          games
        JOIN
          pitchers
        ON pitchers.Game = games.Game
        WHERE 
          DATE_FORMAT(games.Date, '%Y') = "2020" AND
          Pitcher_id IN (
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
          ) AND
          IP > 0
        ORDER BY Pitcher_Id ASC
      ) AS 2020_player
      GROUP BY Pitcher_Id
    ) AS 2020_changed_player
  ) AS 2020_changed_K
  JOIN (
    SELECT
      ROUND(AVG(2021_avg_K_IP), 4) AS `2021_avg_K/9`,
      ROUND(AVG(2021_PC), 4) AS `2021_PC`,
      ROUND(AVG(2021_ST), 4) AS `2021_ST`
    FROM (
      SELECT
        2021_player.Pitcher_id AS Pitcher_id,
        AVG(avg_K_IP) AS 2021_avg_K_IP,
        AVG(PC) AS 2021_PC,
        AVG(ST) AS 2021_ST
      FROM (
        SELECT
          Pitcher_id,
          PC_ST,
          CAST(SUBSTRING_INDEX(PC_ST, '-', 1) AS UNSIGNED) AS PC,
          CAST(SUBSTRING_INDEX(PC_ST, '-', -1) AS UNSIGNED) AS ST,
          K,
          IP,
          9 * K / IP AS avg_K_IP
        FROM
          games
        JOIN
          pitchers
        ON pitchers.Game = games.Game
        WHERE 
          DATE_FORMAT(games.Date, '%Y') = "2021" AND
          Pitcher_id IN (
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
          ) AND
          IP > 0
        ORDER BY Pitcher_Id ASC
      ) AS 2021_player
      GROUP BY Pitcher_Id
    ) AS 2021_changed_player
  ) AS 2021_changed_K
  UNION
  SELECT *
  FROM (
    SELECT
      'Unchanged' AS Pitcher,
      COUNT(*) AS cnt,
      ROUND(AVG(2020_avg_K_IP), 4) AS `2020_avg_K/9`,
      ROUND(AVG(2020_PC), 4) AS `2020_PC`,
      ROUND(AVG(2020_ST), 4) AS `2020_ST`
    FROM (
      SELECT
        2020_player.Pitcher_id AS Pitcher_id,
        AVG(avg_K_IP) AS 2020_avg_K_IP,
        AVG(PC) AS 2020_PC,
        AVG(ST) AS 2020_ST
      FROM (
        SELECT
          Pitcher_id,
          PC_ST,
          CAST(SUBSTRING_INDEX(PC_ST, '-', 1) AS UNSIGNED) AS PC,
          CAST(SUBSTRING_INDEX(PC_ST, '-', -1) AS UNSIGNED) AS ST,
          K,
          IP,
          9 * K / IP AS avg_K_IP
        FROM
          games
        JOIN
          pitchers
        ON pitchers.Game = games.Game
        WHERE 
          DATE_FORMAT(games.Date, '%Y') = "2020" AND
          Pitcher_id IN (
            SELECT * 
            FROM (
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
          ) AS new_player_list
          WHERE Pitcher_id NOT IN (
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
          )
        ) AND
        IP > 0
      ORDER BY Pitcher_Id ASC
      ) AS 2020_player
      GROUP BY Pitcher_Id
    ) AS 2020_changed_player
  ) AS 2020_changed_K
  JOIN (
    SELECT
      ROUND(AVG(2021_avg_K_IP), 4) AS `2021_avg_K/9`,
      ROUND(AVG(2021_PC), 4) AS `2021_PC`,
      ROUND(AVG(2021_ST), 4) AS `2021_ST`
    FROM (
      SELECT
        2021_player.Pitcher_id AS Pitcher_id,
        AVG(avg_K_IP) AS 2021_avg_K_IP,
        AVG(PC) AS 2021_PC,
        AVG(ST) AS 2021_ST
      FROM (
        SELECT
          Pitcher_id,
          PC_ST,
          CAST(SUBSTRING_INDEX(PC_ST, '-', 1) AS UNSIGNED) AS PC,
          CAST(SUBSTRING_INDEX(PC_ST, '-', -1) AS UNSIGNED) AS ST,
          K,
          IP,
          9 * K / IP AS avg_K_IP
        FROM
          games
        JOIN
          pitchers
        ON pitchers.Game = games.Game
        WHERE 
          DATE_FORMAT(games.Date, '%Y') = "2021" AND
          Pitcher_id IN (
            SELECT * 
            FROM (
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
          ) AS new_player_list
          WHERE Pitcher_id NOT IN (
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
          )
        ) AND
        IP > 0
      ORDER BY Pitcher_Id ASC
      ) AS 2021_player
      GROUP BY Pitcher_Id
    ) AS 2021_changed_player
  ) AS 2021_changed_K
) AS last_final_one;
