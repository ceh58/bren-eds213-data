-- step 1

SELECT DISTINCT Species.Code, Species.Scientific_name
FROM Bird_eggs
LEFT JOIN Bird_nests ON Bird_eggs.Nest_ID = Bird_nests.Nest_ID
LEFT JOIN Species ON Bird_nests.Species = Species.Code
ORDER BY Species.Scientific_name;

