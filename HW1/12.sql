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
  AVG(ST / PC) AS avg_st_avg_pc
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
  SUM(CASE WHEN Pitch = "Ball" THEN 1 ELSE 0 END) AS ball,
  SUM(CASE WHEN Pitch = "Foul Ball" THEN 1 ELSE 0 END) AS foul_ball,
  SUM(CASE WHEN Pitch = "Single" THEN 1 ELSE 0 END) AS single,
  SUM(CASE WHEN Pitch = "Double" THEN 1 ELSE 0 END) AS `double`,
  SUM(CASE WHEN Pitch = "Triple" THEN 1 ELSE 0 END) AS triple,
  SUM(CASE WHEN Pitch = "Home Run" THEN 1 ELSE 0 END) AS home_run,
  SUM(CASE WHEN Pitch = "Strike Looking" THEN 1 ELSE 0 END) AS strike_looking,
  SUM(CASE WHEN Pitch = "Strike Swinging" THEN 1 ELSE 0 END) AS strike_swinging,
  SUM(CASE WHEN Pitch = "Line Out" THEN 1 ELSE 0 END) AS line_out,
  SUM(CASE WHEN Pitch = "Ground Out" THEN 1 ELSE 0 END) AS ground_out,
  SUM(CASE WHEN Pitch = "Fly Out" THEN 1 ELSE 0 END) AS fly_out,
  SUM(CASE WHEN Pitch = "Pop Out" THEN 1 ELSE 0 END) AS pop_out,
  SUM(CASE WHEN Pitch = "Foul Out " THEN 1 ELSE 0 END) AS foul_out,
  SUM(CASE WHEN Pitch = "Batters Fielders Choice (runner Out)" THEN 1 ELSE 0 END) AS better_fielders_choice,
  COUNT(*) AS total
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

//：一共會幾種投法
SELECT
  Pitcher,
  COUNT(_Type) AS num_type
FROM (
   SELECT DISTINCT
     Pitcher,
     _Type
   FROM pitches
   JOIN (
      SELECT *
      FROM games
      WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
   ) AS 2021_game
   ON pitches.Game = 2021_game.Game
) AS pitcher_with_pitch_result
GROUP BY Pitcher
ORDER BY Pitcher

//K/IP前二十的選手
SELECT
  player_list.Pitcher_id,
  pitcher_name,
  ROUND(avg_K_IP, 4) AS `avg_K/9`
FROM (
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
 ) player_list
 JOIN (
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
 ON player_list.Pitcher_id = K_IP.Pitcher_Id
 ORDER BY avg_K_IP DESC
 LIMIT 20;
  
//前20高的avg_st_pc
SELECT
  player_list.Pitcher_id,
  pitcher_name,
  ROUND(avg_st_pc, 4) AS `avg_ST/PC`
FROM (
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
 ) player_list
 JOIN (
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
 ON player_list.Pitcher_id = PC_ST.Pitcher_Id
 ORDER BY avg_st_pc DESC
 LIMIT 20;
  
//會幾種投法
SELECT
  player_list.Pitcher_id,
  pitcher_name,
  num_type
FROM (
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
 ) player_list
 JOIN (
   SELECT
     Pitcher,
     COUNT(_Type) AS num_type
   FROM (
      SELECT DISTINCT
        Pitcher,
        _Type
      FROM pitches
      JOIN (
         SELECT *
         FROM games
         WHERE DATE_FORMAT(games.Date, '%Y') = "2021"
      ) AS 2021_game
      ON pitches.Game = 2021_game.Game
   ) AS pitcher_with_pitch_result
   GROUP BY Pitcher
   ORDER BY Pitcher
) AS pitch_type
ON player_list.pitcher_name = pitch_type.Pitcher
WHERE num_type >= 6;
