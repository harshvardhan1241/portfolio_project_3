/* Amazon Prime — 15 SQL Business Questions
1. How many Movies and TV Shows are available on Amazon Prime?
2. What are the most common ratings on Amazon Prime?
3. Which 10 years had the highest number of Movies and TV Shows released?
4. How many titles were added to Amazon Prime in each year?
5. Which 5 countries have produced the highest number of Amazon Prime titles?
6. What are the top 10 genres with the highest number of titles?
7. Which movies have a duration greater than 120 minutes?
8. Which TV Shows have more than 3 seasons?
9. Which 10 directors have directed the highest number of titles?
10. Which 10 actors have appeared in the highest number of movies?
11. How many movies were released on Amazon Prime in the last 10 years?
12. What is the average release year of movies for each country?
13. Which directors have directed at least 5 titles?
14. For each rating, how many Movies and TV Shows are available?
15. How many titles fall into each category based on keywords such as **"love"**, **"crime"**, and **"family"** in their descriptions?
*/


DROP TABLE if EXISTS amazon_prime;
--creation of the tabel for the amazon prime data base
CREATE TABLE amazon_prime (
    show_id VARCHAR(20),
    type VARCHAR(20),
    title TEXT,
    director TEXT,
    casts TEXT,
    country TEXT,
    date_added DATE,
    release_year INT,
    rating VARCHAR(20),
    duration VARCHAR(30),
    listed_in TEXT,
    description TEXT
);

--data loading directly csv file
COPY amazon_prime 
FROM 'C:\Users\dondh\Documents\GitHub\portfolio_project_3\amazon_prime_practice\amazon_prime.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '"'
);
SELECT* FROM amazon_prime as ap

--1. How many Movies and TV Shows are available on Amazon Prime?
SELECT
type,
count(*) 
FROM amazon_prime as ap
GROUP BY type

-- there is movie 7814 and tv shows 1854

--2. What are the most common ratings on Amazon Prime?
SELECT
rating,
count(*) as total_count
 FROM 
 amazon_prime as ap
 where 
 ap.rating is not NULL
 GROUP BY
 rating
 ORDER by count(*) DESC 
 LIMIT 1;
--most common rating on amazon prime is 13+
 
 --3. Which 10 years had the highest number of Movies and TV Shows released?
SELECT
release_year,
count(*) as total_count
 FROM 
amazon_prime as ap
 GROUP BY
 release_year
 ORDER by count(*) DESC 
 LIMIT 10;

--4. How many titles were added to Amazon Prime in each year?
SELECT
count(title) as total_count,
extract(year from date_added) as year_added
FROM amazon_prime as ap
where date_added is not NULL
GROUP BY year_added;

--5. Which 5 countries have produced the highest number of Amazon Prime titles?
SELECT
trim(unnest(string_to_array(country,','))) as country,
count(show_id) as total_count
FROM amazon_prime as ap
where country is not NULL
GROUP BY 1
ORDER by count(show_id) DESC
LIMIT 5;

--6. What are the top 10 genres with the highest number of titles?
SELECT
trim(unnest(string_to_array(listed_in,','))) as genre,
count(show_id) as total_count
FROM amazon_prime as ap
where listed_in is not NULL
GROUP BY 1
ORDER by count(show_id) DESC
LIMIT 10;

--7. Which movies have a duration greater than 120 minutes?
select from amazon_prime as ap
where type = 'Movie' and cast(split_part(duration,' ',1) as int) > 120;