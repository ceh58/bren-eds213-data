sqlite3
database/database.sqlite

-- SQLite looks a lot like DuckDB
.schema

SELECT * FROM Species;

.nullvalue -NULL-

INSERT INTO Species VALUES ('abcd', 'thing1', 'Study species');

SELECT * FROM Species;

-- time to create our trigger
CREATE TRIGGER Fix_up_species
AFTER INSERT ON Species
FOR EACH ROW
BEGIN
    UPDATE Species
        SET Scientific_name = NULL
        WHERE Code = new.Code AND Scientific_name = '';
END;

INSERT INTO Species
    VALUES ('efgh', 'thing2', '', 'Study species');

-- homework: need to be more specific about the row to update (primary key)

-- bash
--- i for insert
--- a fr append (after)
--- dd deletes a line
--- x deletes a character
--- :w write out
--- :q quit

-- wc - l *.sql | sort -n
--- sort myfile.txt > myfile.txt (goes line by line, creates empty file then sorts that file)
--- vi myscript.sh (create shell script)
    -- echo $#

    -- bash myscript.sh a b c
    -- bash myscript.sh echo *.sql

    -- alias rm="rm -i"

-- problem 2
--- part 1

CREATE TEMP TABLE Bird_eggs2 AS
SELECT * FROM Bird_eggs;

CREATE TRIGGER egg_filler
AFTER INSERT ON Bird_eggs
FOR EACH ROW
BEGIN
    UPDATE Bird_eggs
        SET Egg_num = (SELECT MAX(Egg_num) + 1
            FROM Bird_eggs
            WHERE Nest_ID = new.Nest_ID)
        WHERE Nest_ID = new.Nest_ID
        AND Egg_num IS NULL;
END;

DROP TRIGGER egg_filler;

INSERT INTO Bird_eggs
    (Book_page, Year, Site, Nest_ID, Length, Width)
    VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 12.34, 56.78);

.nullvalue -NULL-

SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';

-- part 2

DROP TRIGGER egg_filler;

CREATE TRIGGER egg_filler
AFTER INSERT ON Bird_eggs2
FOR EACH ROW
BEGIN
    UPDATE Bird_eggs2
        SET Egg_num = (SELECT MAX(Egg_num) + 1
            FROM Bird_eggs2
            WHERE Nest_ID = new.Nest_ID),
            Book_page = (SELECT DISTINCT Book_page
            FROM Bird_eggs2
            WHERE Nest_ID = new.Nest_ID),
            Year = (SELECT DISTINCT Year
            FROM Bird_eggs2
            WHERE Nest_ID = new.Nest_ID),
            Site = (SELECT DISTINCT Site
            FROM Bird_eggs2
            WHERE Nest_ID = new.Nest_ID)
        WHERE Nest_ID = new.Nest_ID
        AND Egg_num IS NULL;
END;

INSERT INTO Bird_eggs2
    (Nest_ID, Length, Width)
    VALUES ('14eabaage01', 12.34, 56.78);

SELECT * FROM Bird_eggs2
WHERE Nest_ID = '14eabaage01';

SELECT MAX(Egg_num) + 1
    FROM Bird_eggs2
    WHERE Nest_ID = new.Nest_ID;

SELECT DISTINCT Book_page
    FROM Bird_eggs2
    WHERE Nest_ID = '14eabaage01';

 SELECT DISTINCT Year
    FROM Bird_eggs2
    WHERE Nest_ID = '14eabaage01';

-- bash

bash myscript.sh *.csv

% bash query_timer.sh with_index_a 1000 'SELECT COUNT(*) FROM Bird_nests' \
     database/database.db timings.csv

bash query_timer.sh label num_reps query db_file csv_file


-- get current time and store it

-- loop num_reps times
    --- duckdb db_file query
-- end loop
-- get current time
-- compute elapsed time
-- divide elapsed time by num_reps
-- write output


echo "yo ho a line of text" > junk_file.txt
echo "another line" >> junk_file.txt

sort junk_file.txt
-- sort junk_file.txt > junk_file.txt

sort junk_file.txt > another_junk_file.txt 
mv another_junk_file.txt junk_file.txt