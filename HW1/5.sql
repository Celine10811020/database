SELECT
  Team,
  The_month,
  MIN(interval_time) AS time_interval
FROM (
  SELECT
    team AS Team,
    DATE_FORMAT(Date, '%Y-%m') AS The_month,
    TIME_FORMAT(TIMEDIFF(date, LAG(date) OVER (PARTITION BY team ORDER BY date)), '%H:%i') AS interval_time
  FROM (
    SELECT 
      home AS team,
      Date AS date
    FROM games
    UNION
    SELECT 
      away AS team,
      Date AS date
    FROM games
  ) AS new_table
) AS newTable
WHERE The_month = (
  SELECT
    DATE_FORMAT(games.Date, '%Y-%m') AS date
  FROM
    games
  GROUP BY
    DATE_FORMAT(games.Date, '%Y-%m')
  ORDER BY
    COUNT(DATE_FORMAT(games.Date, '%Y-%m')) DESC
  LIMIT 1
)
GROUP BY Team, The_month;
