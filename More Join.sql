-- # 1. List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie
WHERE yr = 1962;

-- # 2. Give year of 'Citizen Kane'.
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- # 3. List all of the Star Trek movies, include the id, title and yr
-- # (all of these movies include the words Star Trek in the
-- # title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- # 4. What are the titles of the films with id 11768, 11955, 21191.
SELECT title
FROM movie
WHERE id IN (11768, 11955, 21191);

-- # 5. What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- # 6. What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca';

-- # 7. Obtain the cast list for 'Casablanca'. Use the id value that
-- # you obtained in the previous question.
SELECT actor.name
FROM actor
JOIN casting
ON casting.actorid = actor.id
WHERE casting.movieid = 11768;

-- # 8. Obtain the cast list for the film 'Alien'.
SELECT actor.name
FROM actor
JOIN casting
ON casting.actorid = actor.id
JOIN movie
ON movie.id = casting.movieid
WHERE movie.title = 'Alien';

-- # 9. List the films in which 'Harrison Ford' has appeared
SELECT movie.title
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford';

-- # 10. List the films where 'Harrison Ford' has appeared - but not in
-- # the star role. [Note: the ord field of casting gives the position
-- # of the actor. If ord=1 then this actor is in the starring role]
SELECT movie.title
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford'
AND casting.ord != 1;

-- # 11. List the films together with the leading star for all 1962 films.
SELECT title, name
FROM movie JOIN casting 
ON movie.id =  casting.movieid
JOIN actor
ON casting.actorid= actor.id
WHERE yr = 1962 
AND  ord = 1

-- # 12. Which were the busiest years for 'John Travolta', show the
-- # year and the number of movies he made each year for any year in
-- # which he made at least 2 movies.
SELECT yr, COUNT(title) 
FROM movie JOIN casting 
ON movie.id=casting.movieid
JOIN actor 
ON casting.actorid =  actor.id
WHERE name = 'John Travolta'
GROUP BY yr
HAVING 2 < COUNT(title)

-- # 13. List the film title and the leading actor for all of 'Julie
-- # Andrews' films.
SELECT m.title, a.name
FROM movie m JOIN casting c
ON m.id = c.movieid
      AND c.ord = 1
JOIN actor a 
ON c.actorid = a.id
WHERE m.id IN (SELECT m1.id 
                             FROM movie m1 
                            JOIN casting c1
                             ON m1.id=c1.movieid
                            JOIN actor a1
                              ON a1.id = c1.actorid
                            WHERE a1.name = 'Julie Andrews')
                            
-- # 14. Obtain a list of actors in who have had at least 30 starring
-- # roles.
SELECT name
FROM actor JOIN casting
ON actor.id = casting.actorid
WHERE casting.ord = 1
GROUP BY name
HAVING COUNT(movieid) >=30

-- # 15. List the 1978 films by order of cast list size.
SELECT title, COUNT(actorid)
FROM movie JOIN casting
ON movie.id = casting.movieid
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title

-- # 16. List all the people who have worked with 'Art Garfunkel'.
SELECT a.name
  FROM (SELECT movie.*
          FROM movie
          JOIN casting
            ON casting.movieid = movie.id
          JOIN actor
            ON actor.id = casting.actorid
         WHERE actor.name = 'Art Garfunkel') AS m
  JOIN (SELECT actor.*, casting.movieid
          FROM actor
          JOIN casting
            ON casting.actorid = actor.id
         WHERE actor.name != 'Art Garfunkel') as a
    ON m.id = a.movieid;