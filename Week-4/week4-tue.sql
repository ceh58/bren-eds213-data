-- Continuing with SQL
SELECT Species, COUNT(*) AS Nest_count FROM Bird_nests
    WHERE site = 'nome'
    GROUP BY Species
    HAVING Nest_count > 10
    ORDER BY Species
    LIMIT 2;

-- we can nest queries!
SELECT Scientific_name, Nest_count FROM (
    SELECT Species, COUNT(*) AS Nest_count FROM Bird_nests
    WHERE site = 'nome'
    GROUP BY Species
    HAVING Nest_count > 10
    ORDER BY Species
    LIMIT 2
) JOIN Species
ON Species = Code;

-- outer joins
CREATE TEMP TABLE a (
    cola INTEGER,
    common INTEGER
);
INSERT INTO a VALUES (1,1), (2, 2), (3, 3);
SELECT * FROM a;

CREATE TEMP TABLE b (
    common INTEGER,
    colb INTEGER
);
INSERT INTO b VALUES (2,2), (3, 3), (4, 4), (5, 5);
SELECT * FROM b;

-- the joins we've been doing so far have been "inner" joins
SELECT * FROM a JOIN b USING (common);
SELECT * FROM a JOIN b ON a.common = b.common;

-- by doing an "outer" join --- either "left" or "right" --- well add certain missing rows
SELECT * FROM a LEFT JOIN b ON a.common = b.common;
SELECT * FROM a RIGHT JOIN b ON a.common = b.common;

-- a running example: what species do *not* have any nest data?
SELECT COUNT(*) FROM Species;
SELECT COUNT(DISTINCT Species) FROM Bird_nests;
-- can use DISTINCT or not (but faster if selecting from longer tables)
SELECT Code FROM Species
    WHERE Code NOT IN (
        SELECT DISTINCT Species FROM Bird_nests);

-- method 2
SELECT Code, Species FROM Species LEFT JOIN Bird_nests
    ON Code = Species
    WHERE Species IS NULL;

-- it's also possible to join a table with itself, a so-called "self-join"

-- understanding a limitation of DuckDB
SELECT Nest_ID, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

-- let's add in Observer (Nest_ID is primary key, only one row in table, duplicated for each row of Bird_eggs)
SELECT Nest_ID, Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

SELECT * FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%';

SELECT Nest_ID, Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID, Observer;

-- DuckDB solution #2
SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

-- views: a virtual table
CREATE VIEW my_nests AS 
    SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

SELECT * FROM my_nests;
SELECT Nest_ID, Name, Num_eggs
    FROM my_nests JOIN Personnel
    ON Observer = Abbreviation;

-- view vs. temp table (view to clean, temp table if computationally expensive and want to run once)
CREATE TEMP TABLE my_nests_temp_table AS
    SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

-- what about modifications (inserts, updates, deletes) on a view? 
--- depends on theoretically possible, how smart database is

-- set operations
--- UNION, UNION ALL, INTERSECT, EXCEPT

SELECT * FROM Bird_eggs LIMIT 5;

-- adjustments for only page 14

SELECT Book_page, Year, Site, Nest_ID, Egg_num, Length*25.4 AS Length, Width*25.4 AS Width 
    FROM Bird_eggs
    WHERE Book_page LIKE 'b14%'
UNION
SELECT Book_page, Year, Site, Nest_ID, Egg_num, Length, Width 
    FROM Bird_eggs
    WHERE Book_page NOT LIKE 'b14%';

-- method #3 for running example (which species are not in bird nest table)
SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;