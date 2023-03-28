/* K/IP前二十的選手 */
SELECT
  K_IP.Pitcher_id AS Pitcher_id,
  Name AS Pitcher_name,
  ROUND(avg_K_IP, 4) AS `avg_K/9`
FROM (
  /* 2021年中，每一位投手的AVG(9*K/IP) */
  SELECT 
    Pitcher_Id,
    AVG(9 * K / IP) AS avg_K_IP
  FROM
    pitchers
  JOIN ( 
     SELECT *
     FROM games
     WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
  ) AS 2021_game
  ON pitchers.Game = 2021_game.Game
  GROUP BY Pitcher_Id
  ORDER BY avg_K_IP DESC
) AS K_IP
JOIN players
ON players.Id = K_IP.Pitcher_Id
WHERE Pitcher_Id NOT IN (
   /* 找到先發次數大於10的選手 */
   SELECT
     Pitcher_id
   FROM (
      /* 計算2021年中投手先發的次數 */
      SELECT
        pitcher_name,
        Pitcher_id,
        COUNT(Pitcher_id) AS xian_fa_ci_shu
      FROM (
         /* 2021年中有當過先發投手的名字與ID */
         SELECT
           pitcher_name_2021_game.game_id AS game_id,
           pitcher_name_2021_game.pitcher_name AS pitcher_name,
           Pitcher_id
         FROM (
            /* 找出在2021年中當過start的選手名字 */
            SELECT DISTINCT
               Pitcher AS pitcher_name,
               pitches.Game AS game_id,
               Inning
            FROM pitches
            JOIN (
              /* 2021年中有上場的選手的ID與名字 */
              SELECT
                Game
              FROM
                games
              WHERE
                DATE_FORMAT(games.Date, '%Y') = "2021"
            ) AS game_2021
            ON pitches.Game = game_2021.Game
            WHERE 
              Inning = "T1" OR
              Inning = "B1"
         ) AS pitcher_name_2021_game
         JOIN (
            SELECT
              game_id,
              Pitcher_id,
              player_name
            FROM (
              SELECT
                pitchers.Game AS game_id,
                Pitcher_id
              FROM
                pitchers
              JOIN (
                SELECT
                  Game
                FROM
                  games
                WHERE
                  DATE_FORMAT(games.Date, '%Y') = "2021"
              ) AS game_2021
              ON pitchers.Game = game_2021.Game
            ) AS game_2021_pitcher_id
            JOIN (
              SELECT 
                Id, 
                SUBSTRING(Name, LOCATE(' ', Name) + 1, LENGTH(Name)) AS player_name 
              FROM players
            ) AS pitcher_id_player_name
            ON game_2021_pitcher_id.Pitcher_id = pitcher_id_player_name.Id
         ) AS game_id_Pitcher_id_player_name
         ON 
           pitcher_name_2021_game.game_id = game_id_Pitcher_id_player_name.game_id AND
           pitcher_name_2021_game.pitcher_name = game_id_Pitcher_id_player_name.player_name
      ) AS xian_fa_pitcher
      GROUP BY 
        pitcher_name,
        Pitcher_id
   ) AS pitcher_with_xian_fa_ci_shu
   WHERE xian_fa_ci_shu > 10
)
ORDER BY avg_K_IP DESC
LIMIT 20;

/* avg_st_pc前二十的選手 */
SELECT
  PC_ST.Pitcher_id AS Pitcher_id,
  Name AS Pitcher_name,
  ROUND(avg_st_pc, 4) AS `avg_ST/PC`
FROM (
  /* 2021年中，每一位投手的AVG(ST/PC) */
  SELECT
    Pitcher_Id,
    AVG(ST / PC) AS avg_st_pc
  FROM (
    SELECT
      Pitcher_Id,
      CAST(SUBSTRING_INDEX(PC_ST, '-', 1) AS UNSIGNED) AS PC,
      CAST(SUBSTRING_INDEX(PC_ST, '-', -1) AS UNSIGNED) AS ST
    FROM
      pitchers
    JOIN (
       SELECT *
       FROM games
       WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
    ) AS 2021_game
    ON pitchers.Game = 2021_game.Game
  ) AS pitcher_with_pc_st
  GROUP BY Pitcher_Id
  ORDER BY avg_st_pc DESC
) AS PC_ST
JOIN players
ON players.Id = PC_ST.Pitcher_Id
WHERE Pitcher_Id NOT IN (
   /* 找到先發次數大於10的選手 */
   SELECT
     Pitcher_id
   FROM (
      /* 計算2021年中投手先發的次數 */
      SELECT
        pitcher_name,
        Pitcher_id,
        COUNT(Pitcher_id) AS xian_fa_ci_shu
      FROM (
         /* 2021年中有當過先發投手的名字與ID */
         SELECT
           pitcher_name_2021_game.game_id AS game_id,
           pitcher_name_2021_game.pitcher_name AS pitcher_name,
           Pitcher_id
         FROM (
            /* 找出在2021年中當過start的選手名字 */
            SELECT DISTINCT
               Pitcher AS pitcher_name,
               pitches.Game AS game_id,
               Inning
            FROM pitches
            JOIN (
              /* 2021年中有上場的選手的ID與名字 */
              SELECT
                Game
              FROM
                games
              WHERE
                DATE_FORMAT(games.Date, '%Y') = "2021"
            ) AS game_2021
            ON pitches.Game = game_2021.Game
            WHERE 
              Inning = "T1" OR
              Inning = "B1"
         ) AS pitcher_name_2021_game
         JOIN (
            SELECT
              game_id,
              Pitcher_id,
              player_name
            FROM (
              SELECT
                pitchers.Game AS game_id,
                Pitcher_id
              FROM
                pitchers
              JOIN (
                SELECT
                  Game
                FROM
                  games
                WHERE
                  DATE_FORMAT(games.Date, '%Y') = "2021"
              ) AS game_2021
              ON pitchers.Game = game_2021.Game
            ) AS game_2021_pitcher_id
            JOIN (
              SELECT 
                Id, 
                SUBSTRING(Name, LOCATE(' ', Name) + 1, LENGTH(Name)) AS player_name 
              FROM players
            ) AS pitcher_id_player_name
            ON game_2021_pitcher_id.Pitcher_id = pitcher_id_player_name.Id
         ) AS game_id_Pitcher_id_player_name
         ON 
           pitcher_name_2021_game.game_id = game_id_Pitcher_id_player_name.game_id AND
           pitcher_name_2021_game.pitcher_name = game_id_Pitcher_id_player_name.player_name
      ) AS xian_fa_pitcher
      GROUP BY 
        pitcher_name,
        Pitcher_id
   ) AS pitcher_with_xian_fa_ci_shu
   WHERE xian_fa_ci_shu > 10
)
ORDER BY avg_st_pc DESC
LIMIT 20;
