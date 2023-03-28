//player_name, game_2021, start：2021年裏當過start的選手名字
SELECT DISTINCT
   Pitcher,
   pitches.Game,
   Inning
FROM pitches
JOIN (
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

//game_2021, pitcher_id：2021年裏的選手ID
SELECT
  pitchers.Game,
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

//Id, player_name：選手ID與名字
SELECT 
  Id, 
  SUBSTRING(Name, LOCATE('.', Name) + 2, LENGTH(Name)) AS player_name 
FROM players 
ORDER BY player_name ASC;

//game_2021, pitcher_id, player_name：2021年裏選手ID與名字
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

//game_id, pitcher_name, pitcher_id：2021年裏，先發投手的名字和ID
SELECT
  pitcher_name_2021_game.game_id,
  pitcher_name_2021_game.pitcher_name,
  Pitcher_id
FROM (
   SELECT DISTINCT
      Pitcher AS pitcher_name,
      pitches.Game AS game_id,
      Inning
   FROM pitches
   JOIN (
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

//先發的次數
SELECT
  pitcher_name,
  Pitcher_id,
  COUNT(Pitcher_id) AS xian_fa_ci_shu
FROM (
   SELECT
     pitcher_name_2021_game.game_id AS game_id,
     pitcher_name_2021_game.pitcher_name AS pitcher_name,
     Pitcher_id
   FROM (
      SELECT DISTINCT
         Pitcher AS pitcher_name,
         pitches.Game AS game_id,
         Inning
      FROM pitches
      JOIN (
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

//pitcher_id, pitcher_name：找出先發次數小於等於10的投手
SELECT
  Pitcher_id,
  pitcher_name
FROM (
   SELECT
     pitcher_name,
     Pitcher_id,
     COUNT(Pitcher_id) AS xian_fa_ci_shu
   FROM (
      SELECT
        pitcher_name_2021_game.game_id AS game_id,
        pitcher_name_2021_game.pitcher_name AS pitcher_name,
        Pitcher_id
      FROM (
         SELECT DISTINCT
            Pitcher AS pitcher_name,
            pitches.Game AS game_id,
            Inning
         FROM pitches
         JOIN (
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
WHERE xian_fa_ci_shu <= 10

//：2021年每位投手的AVG(9*K/IP)
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

//：2021年每位投手的AVG(ST)/AVG(PC)
SELECT
  Pitcher_Id,
  AVG(ST) / AVG(PC) AS avg_st_avg_pc
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
ORDER BY avg_st_avg_pc DESC

//：將pitch作分類
SELECT
  Pitcher,
  COUNT(CASE WHEN Pitch = "Ball" THEN 1 ELSE 0 END) AS ball,
  COUNT(CASE WHEN Pitch = "Single" THEN 1 ELSE 0 END) AS single,
  COUNT(CASE WHEN Pitch = "Strike Looking" THEN 1 ELSE 0 END) AS strike_looking,
  COUNT(CASE WHEN Pitch = "Line Out" THEN 1 ELSE 0 END) AS line_out,
  COUNT(CASE WHEN Pitch = "Foul Ball" THEN 1 ELSE 0 END) AS goul_ball,
  COUNT(CASE WHEN Pitch = "Ground Out" THEN 1 ELSE 0 END) AS ground_out,
  COUNT(CASE WHEN Pitch = "Fly Out" THEN 1 ELSE 0 END) AS fly_out,
  COUNT(CASE WHEN Pitch = "Strike Swinging" THEN 1 ELSE 0 END) AS Strike_swinging
FROM (
   SELECT
     Pitcher,
     Pitch
   FROM pitches
   JOIN (
      SELECT *
      FROM games
      WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
   ) AS 2021_game
   ON pitches.Game = 2021_game.Game
) AS pitcher_with_pitch_result
GROUP BY Pitcher
