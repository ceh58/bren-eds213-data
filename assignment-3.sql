-- Problem 1:
-- Create temp table
CREATE TEMP TABLE mytable (
    col1 REAL
);

-- Add values 
INSERT INTO mytable (col1)
VALUES
  (1),
  (2),
  (3),
  (NULL),
  (5);

  -- AVG col1 (without NULL: 2.75, with NULL: 2.2)
  --- returns 2.75
  SELECT AVG(col1) AS Avg_Col1
  FROM mytable;

  -- Part 1: AVG does not include the NULL value. 
  --- We know this because the real numbers add to 11. 
  --- If "NULL" was included, 11 would be divided by 5 values to obtain 2.2. 
  --- Instead, 11 is divided by 4 values (not including NULL) to obtain 2.75.

SELECT SUM(col1)/COUNT(*) FROM mytable;
SELECT SUM(col1)/COUNT(col1) FROM mytable;

-- Part 2: The first query is correct (average = 2.2; this includes the NULL value). 
--- If we want the average from col1, which includes 5 rows (values), we need to divide the sum by 5.
--- COUNT(*) returns 5 as the number of rows (values) to average by.
--- COUNT(col1) returns 4 as the number of rows(values) to average by.


-- Problem 2:
SELECT Site_name, MAX(Area) FROM Site;

SELECT * FROM Site;

SELECT Site_name, AVG(Area) FROM Site;
SELECT Site_name, COUNT(*) FROM Site;
SELECT Site_name, SUM(Area) FROM Site;

SELECT MAX(Area) FROM Site;

SELECT Site_name, Area AS Max_area
FROM Site
WHERE Area = (SELECT MAX(Area) FROM Site);

SELECT Site_name, Area AS Max_area
FROM Site
ORDER BY Area DESC
LIMIT 1;

-- list the scientific names of bird species in descending order of their maximum average egg volumes.
--- 1. compute the average volume of the eggs in each nest
--- 2. nests of each species compute the maximum of those average volumes
--- 3. list by species in descending order of maximum volume.
--- (egg_width)^2 * egg_length * (3.14/6)

-- group bird eggs by nest (i.e., Nest_ID) and compute average volumes
CREATE TEMP TABLE Averages AS
    SELECT Nest_ID, AVG((3.14/6)*(Width*Width)*Length) AS Avg_volume
        FROM Bird_eggs
        GROUP BY Nest_ID;

SELECT * FROM Averages;

-- join that table with Bird_nests, so that you can group by species

SELECT Species, MAX(Avg_volume)
FROM Bird_nests JOIN Averages USING (Nest_ID)
GROUP BY Species;


-- create temp table Averages with average egg volume (Avg_volume) by Nest_ID
CREATE TEMP TABLE Averages AS
    SELECT Nest_ID, AVG((3.14/6)*(Width*Width)*Length) AS Avg_volume
        FROM Bird_eggs
        GROUP BY Nest_ID;

-- join Averages with Bird_nests by Nest_ID and group by species (A) to get A.Max_volume,
--- then join with Species (B) by Species = Code to get B.Scientific_name
SELECT B.Scientific_name, A.Max_volume
FROM (
  SELECT Species, MAX(Avg_volume) AS Max_volume
  FROM Bird_nests
  JOIN Averages USING (Nest_ID)
  GROUP BY Species) A
JOIN Species B ON A.Species = B.Code
ORDER BY Max_volume DESC;