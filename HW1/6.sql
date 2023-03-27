SELECT 
  DISTINCT _Type AS Type
FROM pitches
WHERE _Type NOT IN (
  SELECT _Type
  FROM pitches
  WHERE MPH > 95
)
ORDER BY _Type ASC;
