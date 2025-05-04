-- exporting data from a database

-- the whole database (creates a folder and saves .csv files)
EXPORT DATABASE 'export_adsn';

-- one table
COPY Species TO 'species_test.csv' (HEADER, DELIMITER ',');

-- specific query
COPY (SELECT COUNT(*) FROM Species) TO 'species_distinct.csv' (HEADER, DELIMITER ',');

-- exploring why grouping by Scientific_name is not quite correct (HW3)
SELECT * FROM Species LIMIT 3;

SELECT COUNT(*) FROM Species;

SELECT Scientific_name, COUNT(*) AS Num_name_occurrences
    FROM Species
    GROUP BY Scientific_name
    HAVING Num_name_occurrences >1;

CREATE TEMP TABLE t AS (
SELECT Scientific_name, COUNT(*) AS Num_name_occurrences
    FROM Species
    GROUP BY Scientific_name
    HAVING Num_name_occurrences >1
);

SELECT * FROM t;

SELECT * FROM Species s 
JOIN t ON s.Scientific_name = t.Scientific_name
OR (s.Scientific_name IS NULL AND t.Scientific_name IS NULL);

-- explicitly label columns to insert data
INSERT INTO Species
    (Common_name, Scientific_name, Code, Relevance)
    VALUES
    ('thing 2', 'another scientific name', 'efgh', NULL);

SELECT * FROM Species;

-- updates and deletes will demolist the entire table unless limited by WHERE
DELETE FROM Bird_eggs

-- strategies to save yourself?
-- SELECT first

SELECT * FROM Bird_eggs WHERE Nest_ID LIKE 'r%';

SELECT * FROM Bird_nests;

-- try the create a copy of the table
CREATE TABLE nest_temp AS (SELECT * FROM Bird_nests);
DELETE FROM nest_temp WHERE Site = 'chur';

-- other ideas (write x until ready to execute)
xDELETE FROM... WHERE ...;

