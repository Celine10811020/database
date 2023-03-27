SELECT COUNT(*) AS cnt
FROM games
WHERE ABS(away_score - home_score) >= 10;
