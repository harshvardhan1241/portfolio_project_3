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

DROP TABLE if EXISTS amzon_prime;
CREATE TABLE amzon_prime 
(
show_id VARCHAR(60),
type VARCHAR(100),
title VARCHAR(200),
director VARCHAR(210),
casts VARCHAR(1000),
country VARCHAR(150),
date_added date,
release_year int,
rating VARCHAR(100),
duration VARCHAR(15),
listed_in VARCHAR(1000),
description VARCHAR(10000)
)