-- move db to current directory
cp /courses/EDS213/big-fat.sqlite3 .
--- don't forget to add to .gitignore

-- query from assignment
SELECT Nest_ID
    FROM Bird_nests
    WHERE Site = 'nome' AND
          Species = 'ruff' AND
          Year = 1983 AND
          Observer = 'cbishop' AND
          ageMethod = 'float';

-- returns: gen511190

-- Part 1
--- 1. Is there already an index on the Bird_nests table? No?
--- There is an automatic index for rows, but no index for values in any of the columns.

--- If so, what is that index and will SQLite use it in the above query? Why or why not?
--- The row index will not be used in the above query because it is searching for values.

--- 2. Will adding an index on a column not mentioned in the WHERE clause be used by the database? Why or why not?
--- No, because it will only search the index for the columns called in WHERE.

-- Part 2
-- 15 Experiments:

query="SELECT Nest_ID FROM Bird_nests WHERE Site = 'nome' AND Species = 'ruff' AND Year = 1983 AND Observer = 'cbishop' AND ageMethod = 'float'"

-- no index
bash query_timer_9.sh "none" 1 "$query" big-fat.sqlite3 assignment-9.csv    

-- index for Site
sqlite3 big-fat.sqlite3 "CREATE INDEX index_site ON Bird_nests(Site);"
bash query_timer_9.sh "Site" 1 "$query" big-fat.sqlite3 assignment-9.csv     
sqlite3 big-fat.sqlite3 "DROP INDEX index_site;"

-- index for Species
sqlite3 big-fat.sqlite3 "CREATE INDEX index_species ON Bird_nests(Species);"
bash query_timer_9.sh "Species" 1 "$query" big-fat.sqlite3 assignment-9.csv    
sqlite3 big-fat.sqlite3 "DROP INDEX index_species;"

-- index for Year
sqlite3 big-fat.sqlite3 "CREATE INDEX index_year ON Bird_nests(Year);"
bash query_timer_9.sh "Year" 1 "$query" big-fat.sqlite3 assignment-9.csv   
sqlite3 big-fat.sqlite3 "DROP INDEX index_year;"

-- index for Observer
sqlite3 big-fat.sqlite3 "CREATE INDEX index_obs ON Bird_nests(Observer);"
bash query_timer_9.sh "Observer" 1 "$query" big-fat.sqlite3 assignment-9.csv 
sqlite3 big-fat.sqlite3 "DROP INDEX index_obs;"

-- index for ageMethod
sqlite3 big-fat.sqlite3 "CREATE INDEX index_ageMethod ON Bird_nests(ageMethod);"
bash query_timer_9.sh "ageMethod" 1 "$query" big-fat.sqlite3 assignment-9.csv     
sqlite3 big-fat.sqlite3 "DROP INDEX index_ageMethod;"

-- index for Site,Species
sqlite3 big-fat.sqlite3 "CREATE INDEX index_site_species ON Bird_nests(Site, Species);"
bash query_timer_9.sh "Site,Species" 1 "$query" big-fat.sqlite3 assignment-9.csv   
sqlite3 big-fat.sqlite3 "DROP INDEX index_site_species;"

-- index for Site,Observer
sqlite3 big-fat.sqlite3 "CREATE INDEX index_site_obs ON Bird_nests(Site, Observer);"
bash query_timer_9.sh "Site,Observer" 1 "$query" big-fat.sqlite3 assignment-9.csv     
sqlite3 big-fat.sqlite3 "DROP INDEX index_site_obs;"

-- index for Species,Observer
sqlite3 big-fat.sqlite3 "CREATE INDEX index_species_obs ON Bird_nests(Species, Observer);"
bash query_timer_9.sh "Species,Observer" 1 "$query" big-fat.sqlite3 assignment-9.csv   
sqlite3 big-fat.sqlite3 "DROP INDEX index_species_obs;"

-- index for Year,Observer
sqlite3 big-fat.sqlite3 "CREATE INDEX index_year_obs ON Bird_nests(Year, Observer);"
bash query_timer_9.sh "Year,Observer" 1 "$query" big-fat.sqlite3 assignment-9.csv    
sqlite3 big-fat.sqlite3 "DROP INDEX index_year_obs;"

-- index for Observer,ageMethod
sqlite3 big-fat.sqlite3 "CREATE INDEX index_obs_ageMethod ON Bird_nests(Observer, ageMethod);"
bash query_timer_9.sh "Observer, ageMethod" 1 "$query" big-fat.sqlite3 assignment-9.csv    
sqlite3 big-fat.sqlite3 "DROP INDEX index_obs_ageMethod;"

-- index for Site,Species,Year
sqlite3 big-fat.sqlite3 "CREATE INDEX index_site_species_year ON Bird_nests(Site, Species, Year);"
bash query_timer_9.sh "Site,Species,Year" 1 "$query" big-fat.sqlite3 assignment-9.csv    
sqlite3 big-fat.sqlite3 "DROP INDEX index_site_species_year;"

-- index for Site,Species,Observer
sqlite3 big-fat.sqlite3 "CREATE INDEX index_site_species_obs ON Bird_nests(Site, Species, Observer);"
bash query_timer_9.sh "Site,Species,Observer" 1 "$query" big-fat.sqlite3 assignment-9.csv    
sqlite3 big-fat.sqlite3 "DROP INDEX index_site_species_obs;"

-- index for Site,Species,Year,Observer
sqlite3 big-fat.sqlite3 "CREATE INDEX index_site_species_year_obs ON Bird_nests(Site, Species, Year, Observer);"
bash query_timer_9.sh "Site,Species,Year,Observer" 1 "$query" big-fat.sqlite3 assignment-9.csv    
sqlite3 big-fat.sqlite3 "DROP INDEX index_site_species_year_obs;"

-- index for Site,Species,Year,Observer,ageMethod
sqlite3 big-fat.sqlite3 "CREATE INDEX index_site_species_year_obs_ageMethod ON Bird_nests(Site, Species, Year, Observer, ageMethod);"
bash query_timer_9.sh "Site,Species,Year,Observer,ageMethod" 1 "$query" big-fat.sqlite3 assignment-9.csv    
sqlite3 big-fat.sqlite3 "DROP INDEX index_site_species_year_obs_ageMethod;"
