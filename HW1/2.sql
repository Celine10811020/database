SELECT
  Game AS Game,
  CEIL(COUNT(Inning) / 2) AS num_innings
FROM inning
GROUP BY Game
HAVING num_innings = (
  SELECT * FROM (
    SELECT CEIL(COUNT(Inning) / 2) AS temp
    FROM inning
    GROUP BY Game
    ORDER BY temp DESC
    LIMIT 1
  ) AS tmp
)
ORDER BY Game ASC;
