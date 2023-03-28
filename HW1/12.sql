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
