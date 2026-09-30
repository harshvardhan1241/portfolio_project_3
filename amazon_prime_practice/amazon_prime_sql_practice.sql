
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
SELECT* FROM amazon_prime

