SELECT 
  pitchers.Pitcher_Id AS Pitcher_Id, 
  players.Name AS Pitcher, 
  ROUND(SUM(pitchers.IP), 1) AS tol_innings
FROM pitchers
JOIN players ON pitchers.Pitcher_Id = players.Id
JOIN games ON pitchers.Game = games.Game
WHERE games.Date BETWEEN '2021-04-01' AND '2021-11-30'
GROUP BY pitchers.Pitcher_Id, players.Name
ORDER BY tol_innings DESC
LIMIT 3;
