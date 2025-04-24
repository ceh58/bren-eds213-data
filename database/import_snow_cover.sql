-- create table
CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130),
    Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130),
    Total_cover REAL CHECK (Total_cover BETWEEN 0 AND 130),
    Observer VARCHAR,
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);

-- copy data (specify NA as NULL)
COPY Snow_cover FROM "ASDN_csv/snow_survey_fixed.csv" (header TRUE, nullstr "NA");

-- view table
SELECT * FROM Snow_cover LIMIT 10;

-- analysis
--- question 1: what is the average snow_cover at each site
SELECT Site, Snow_cover AS Avg_snow 
    FROM Snow_cover
    WHERE Snow_cover = (SELECT AVG(Snow_cover) FROM Snow_cover);

SELECT Site, AVG(Snow_cover) AS Avg_snow
    FROM Snow_cover
    GROUP BY Site;

--- question 2: top 5 most snowy sites
SELECT Site, AVG(Snow_cover) AS Avg_snow
    FROM Snow_cover
    GROUP BY Site
    ORDER BY Avg_snow DESC
    LIMIT 5;

--- question 3: save this as a VIEW
CREATE VIEW Site_avg_snowcover AS (
    SELECT Site, AVG(Snow_cover) AS Avg_snow
    FROM Snow_cover
    GROUP BY Site
    ORDER BY Avg_snow DESC
    LIMIT 5
);

CREATE TEMP TABLE Site_avg_snowcover_table AS (
    SELECT Site, AVG(Snow_cover) AS Avg_snow
    FROM Snow_cover
    GROUP BY Site
    ORDER BY Avg_snow DESC
    LIMIT 5
);

SELECT * FROM Site_avg_snowcover_table;

-- DANGER ZONE views update, tables do not
--- where Plot = "brw0", snow_cover == 0 is actually NULL
CREATE TEMP TABLE Snow_cover_temp AS (SELECT * FROM Snow_cover);

UPDATE Snow_cover_temp SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;

SELECT * FROM Snow_cover_temp WHERE Plot = 'brw0';

UPDATE Snow_cover SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;

-- View changes (reruns query)
SELECT * FROM Site_avg_snowcover;

-- Table doesn't change
SELECT * FROM Site_avg_snowcover_table;