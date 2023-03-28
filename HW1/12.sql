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
