-- Review of SQL SELECT 
SELECT Nest_ID, AVG(3.14/6*Width*Width*Length) AS Avg_volume
    FROM Bird_eggs
    WHERE Nest_ID LIKE '14%'
    GROUP BY Nest_ID
    HAVING Avg_volume > 10000
    ORDER BY Avg_volume DESC
    LIMIT 3 OFFSET 17;

-- first, evaluates "where" clause
-- second, puts into groups
-- third, calculates average for each nest_id
-- fourth, "having" to filter

-- can group by a whole expression
SELECT substring(Nest_ID, 1, 3), AVG(3.14/6*Width*Width*Length) AS Avg_volume
    FROM Bird_eggs
    WHERE Nest_ID LIKE '14%'
    GROUP BY substring(Nest_ID, 1, 3)
    HAVING Avg_volume > 10000
    ORDER BY Avg_volume DESC;


CREATE TABLE a (col INT);
INSERT INTO a VALUES (1), (2), (3), (4);
CREATE TABLE b (col INT);
INSERT INTO b VALUES (0), (1);
SELECT * FROM a;
SELECT * FROM b;

-- every possible pairing of rows
SELECT * FROM a JOIN b ON TRUE;

SELECT * FROM a JOIN b ON a.col = b.col; 

SELECT * FROM a JOIN b ON NULL;

SELECT * FROM a JOIN b ON a.col = b.col OR a.col = b.col +1;

-- an outer join adds in any rows not included by the condition
SELECT * FROM a LEFT JOIN b ON a.col = b.col OR a.col = b.col+1;


-- part 2

bash query_timer.sh subquery 100 'SELECT Code
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests)' \
    database.db timings.csv

bash query_timer.sh subquery 500 'SELECT Code
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests)' \
    database.db timings.csv

bash query_timer.sh subquery 1000 'SELECT Code
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests)' \
    database.db timings.csv


--- Method using an outer join:

bash query_timer.sh outer_join 100 'SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Nest_ID IS NULL' \
    database.db timings.csv

bash query_timer.sh outer_join 500 'SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Nest_ID IS NULL' \
    database.db timings.csv

bash query_timer.sh outer_join 1000 'SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Nest_ID IS NULL' \
    database.db timings.csv

-- Method using a set operation:

bash query_timer.sh with_except 100 'SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests' \
    database.db timings.csv

bash query_timer.sh with_except 500 'SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests' \
    database.db timings.csv

bash query_timer.sh with_except 1000 'SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests' \
    database.db timings.csv

