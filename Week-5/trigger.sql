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

CREATE TRIGGER egg_filler
AFTER INSERT ON Bird_eggs
FOR EACH ROW
BEGIN
    UPDATE Bird_eggs
        SET Egg_num = (SELECT MAX(Egg_num) + 1
            FROM Bird_eggs
            WHERE Nest_ID = new.Nest_ID
            AND Egg_num IS NULL)
        WHERE Nest_ID = new.Nest_ID
        AND Egg_num IS NULL;
END;

DROP TRIGGER egg_filler;

SELECT MAX(Egg_num) +1 FROM Bird_eggs
    WHERE Nest_ID = '14eabaage01';
    

SELECT Nest_ID, MAX(Egg_num) +1 FROM Bird_eggs 
GROUP BY Nest_ID;

INSERT INTO Bird_eggs
    (Book_page, Year, Site, Nest_ID, Length, Width)
    VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 12.34, 56.78);

.nullvalue -NULL-

SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';



-- bash
