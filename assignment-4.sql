-- who worked at "nome" site between 1998-2008 (observing 36 nests)
SELECT A.Name, B.Num_floated_nests FROM
    (SELECT Observer, COUNT(Nest_ID) AS Num_floated_nests FROM Bird_nests
    WHERE year BETWEEN 1998 and 2008
    AND site = 'nome'
    AND ageMethod = 'float'
    GROUP BY Observer
    HAVING Num_floated_nests = 36) B
JOIN Personnel A ON A.Abbreviation = B.Observer;  


-- problem 2:

SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2 FROM Camp_assignment A JOIN Camp_assignment B
ON A.Site = B.Site WHERE (A.Start <= B.End)  and  (A.End >= B.Start) 
AND A.Site = 'lkri'
AND A.Observer < B.Observer;

SELECT A.Site, C.Name AS Name_1, D.Name AS Name_2 FROM (
SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2 FROM Camp_assignment A JOIN Camp_assignment B
ON A.Site = B.Site WHERE (A.Start <= B.End)  and  (A.End >= B.Start) 
AND A.Site = 'lkri'
AND A.Observer < B.Observer) A
JOIN Personnel C ON A.Observer_1 = C.Abbreviation
JOIN Personnel D ON A.Observer_2 = D.Abbreviation;

-- problem 3:

SELECT DISTINCT Code FROM Site
WHERE Code NOT IN (
    SELECT Site FROM Bird_eggs
)
ORDER BY Code;

SELECT Code FROM Site A
LEFT JOIN Bird_eggs B on B.Site = A.Code
WHERE Egg_num IS NULL
ORDER BY Code;

SELECT Code FROM Site
EXCEPT
SELECT DISTINCT Site from Bird_eggs
ORDER BY Code;
