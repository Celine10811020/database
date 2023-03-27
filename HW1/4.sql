SELECT
  players.Name AS Hitter,
  ROUND(AVG(hitters.num_P / (hitters.AB + hitters.K + hitters.BB)), 4) AS `avg_P/PA`,
  ROUND(AVG(hitters.AB), 4) AS avg_AB,
  ROUND(AVG(hitters.BB), 4) AS avg_BB,
  ROUND(AVG(hitters.K), 4) AS avg_K,
  SUM(hitters.AB + hitters.K + hitters.BB) AS tol_PA
FROM hitters
JOIN players ON hitters.Hitter_Id = players.Id
WHERE hitters.AB + hitters.K + hitters.BB > 0
GROUP BY hitters.Hitter_Id
HAVING tol_PA >= 20
ORDER BY `avg_P/PA` DESC
LIMIT 3;
