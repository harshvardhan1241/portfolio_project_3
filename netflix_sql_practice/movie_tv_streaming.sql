--create database

CREATE DATABASE movie_stream

--create othe table
DROP TABLE if EXISTS neflix_titles;
CREATE TABLE neflix_titles 
(show_id varchar(6),
type varchar(10),
title varchar(150),
director varchar(210),
casts varchar(1000),
country varchar(150),
date_added date,
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
)


SELECT*FROM neflix_titles 


-- 15 Business Problems & Solutions
/*
1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 7 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/

--1. Count the number of Movies vs TV Shows

SELECT
type,
count(*) as total_content
FROM neflix_titles 
GROUP BY
type

--2. Find the most common rating for movies and TV shows
select
type, 
max(rating)
FROM neflix_titles
GROUP by 1 --not currect


--
SELECT  
type,
rating,
count(*)
FROM neflix_titles
GROUP by type,rating
ORDER by count(*) DESC
--TV-MA movies and tv shows


--3. List all movies released in a specific year (e.g., 2020)
SELECT
title,
type,
date_added
from neflix_titles
WHERE
type='Movie'
AND
to_char(date_added,'yyyy')='2020'
ORDER BY
date_added

--4. Find the top 5 countries with the most content on Netflix
--Country combinations
SELECT
country,
count(*) as count_of_movies
FROM neflix_titles
WHERE
country is not null
GROUP by country
order by count(*) DESC
LIMIT 5;
-- this is not vcount the movie or conetent in multiple country
--Individual countries
SELECT
unnest(STRING_to_array(country,',')) as new_country,
count(show_id) as total_content
FROM neflix_titles
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5. Identify the longest movie
SELECT
title,
type,
duration
FROM neflix_titles
WHERE type = 'Movie'
and duration is not NULL
ORDER BY
 CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
limit 1;

--6. Find content added in the last 7 years

SELECT
*
FROM 
neflix_titles
WHERE
date_added >= CURRENT_DATE -INTERVAL'7 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT
*
FROM
neflix_titles 
WHERE director LIKE'%Rajiv Chilaka%'

--8. List all TV shows with more than 5 seasons

--for the most no. of sesons show
SELECT
title,
type,
duration
FROM neflix_titles
WHERE type = 'TV Show'
and duration is not NULL
ORDER BY
 CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
limit 1;

-- TV shows with more than 5 seasons with desc order
SELECT
title,
type,
duration
FROM neflix_titles
WHERE type = 'TV Show' AND
 CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5
 order BY  CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC

--9. Count the number of content items in each genre
SELECT
count(show_id),
unnest(string_to_array(listed_in,',')) as gener
FROM
neflix_titles 
GROUP BY 2

--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

SELECT
 extract (year from date_added) as year,
 count(*) as _count,
 round(
 count(*)::numeric/(SELECT count(*) FROM neflix_titles WHERE country like '%India%')::numeric * 100 ,2) as avg_count_per_year
FROM
neflix_titles 
WHERE country like '%India%'
group by extract (year from date_added)
order by extract (year from date_added) 

--11. List all movies that are documentaries

SELECT*
FROM
neflix_titles
WHERE
type='Movie'
AND
listed_in like '%Documentaries%'

--12. Find all content without a director
SELECT
*
FROM
neflix_titles 
WHERE director is NULL

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT
count(*) 
FROM
neflix_titles 
WHERE
casts like '%Salman Khan%'
AND
release_year > extract(year from CURRENT_DATE)-10

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
--show_id,
--title,
unnest(string_to_array(casts,',')) as actor,
count(*) as apperiance
FROM
neflix_titles 
WHERE
type='Movie'
AND
country like '%India%'
GROUP BY 1
order by 2 desc
LIMIT 10;

/*15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/
with new_tabel as (
SELECT
*,
case
when 
    description LIKE '%kill%'
    OR
    description LIKE '%violence%' then 'bad_content'
    else 'good content'
    END category
FROM
neflix_titles)


SELECT
category,
count(*) as total_count
from
new_tabel
GROUP BY 1