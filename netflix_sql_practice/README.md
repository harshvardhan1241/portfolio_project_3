# Netflix SQL Data Analysis

## Project Overview

This project analyzes the Netflix titles dataset using PostgreSQL. The analysis focuses on solving 15 different business problems related to Movies and TV Shows, including content types, ratings, countries, genres, duration, directors, actors, release trends, and content categorization.

The project also demonstrates practical SQL concepts such as aggregation, filtering, string manipulation, date functions, subqueries, CTEs, `CASE` statements, and handling multi-value columns.

---

# Dataset

The main table used in this project is:

```sql
neflix_titles
```

### Main Columns

| Column         | Description                         |
| -------------- | ----------------------------------- |
| `show_id`      | Unique ID of the content            |
| `type`         | Movie or TV Show                    |
| `title`        | Title of the content                |
| `director`     | Director name                       |
| `casts`        | Cast/actors                         |
| `country`      | Country or countries                |
| `date_added`   | Date content was added              |
| `release_year` | Original release year               |
| `rating`       | Content rating                      |
| `duration`     | Movie duration or number of seasons |
| `listed_in`    | Genre/category                      |
| `description`  | Content description                 |

---

# Business Problems & SQL Solutions

## 1. Count the Number of Movies vs TV Shows

### Business Question

How many Movies and TV Shows are available on Netflix?

### SQL Solution

```sql
SELECT
    type,
    COUNT(*) AS total_content
FROM neflix_titles
GROUP BY type;
```

### Concepts Used

* `COUNT()`
* `GROUP BY`
* Aggregate functions

### Expected Output

| type    |      total_content |
| ------- | -----------------: |
| Movie   |   Number of movies |
| TV Show | Number of TV shows |

The exact numbers depend on the dataset being analyzed.

---

# 2. Find the Most Common Rating for Movies and TV Shows

### Business Question

Which ratings occur most frequently among Movies and TV Shows?

### SQL Solution

```sql
SELECT
    type,
    rating,
    COUNT(*)
FROM neflix_titles
GROUP BY type, rating
ORDER BY COUNT(*) DESC;
```

### Concepts Used

* `COUNT()`
* `GROUP BY`
* Multiple-column grouping
* `ORDER BY`
* `DESC`

### Expected Output

| type    | rating | count |
| ------- | ------ | ----: |
| Movie   | Rating | Count |
| TV Show | Rating | Count |
| ...     | ...    |   ... |

The rows are ordered from the most frequent rating to the least frequent rating.

---

# 3. List All Movies Released in a Specific Year

### Business Question

List Movies associated with the year 2020.

### SQL Solution

```sql
SELECT
    title,
    type,
    date_added
FROM neflix_titles
WHERE type = 'Movie'
AND TO_CHAR(date_added, 'yyyy') = '2020'
ORDER BY date_added;
```

### Concepts Used

* `WHERE`
* `AND`
* `TO_CHAR()`
* Date formatting
* `ORDER BY`

### Expected Output

| title       | type  | date_added |
| ----------- | ----- | ---------- |
| Movie title | Movie | 2020-...   |
| Movie title | Movie | 2020-...   |

### Note

The SQL file's question refers to movies **released** in 2020, but the query actually filters the `date_added` column. Therefore, this query identifies movies **added to Netflix in 2020**, not necessarily movies originally released in 2020.

---

# 4. Find the Top 5 Countries with the Most Content on Netflix

The project explores two approaches because the `country` column can contain multiple countries.

## Approach 1: Country Combinations

```sql
SELECT
    country,
    COUNT(*) AS count_of_movies
FROM neflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY COUNT(*) DESC
LIMIT 5;
```

### Concepts Used

* `COUNT()`
* `GROUP BY`
* `IS NOT NULL`
* `ORDER BY`
* `LIMIT`

### Output

| country             | count_of_movies |
| ------------------- | --------------: |
| Country combination |           Count |
| Country combination |           Count |
| ...                 |             ... |

---

## Approach 2: Individual Countries

```sql
SELECT
    UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
    COUNT(show_id) AS total_content
FROM neflix_titles
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

### Concepts Used

* `STRING_TO_ARRAY()`
* `UNNEST()`
* `COUNT()`
* `GROUP BY`
* Positional grouping
* `ORDER BY`
* `LIMIT`

### Output

| new_country | total_content |
| ----------- | ------------: |
| Country 1   |         Count |
| Country 2   |         Count |
| Country 3   |         Count |
| Country 4   |         Count |
| Country 5   |         Count |

### Key Learning

The first query treats a combination such as:

```text
India, United States
```

as one value.

The second query splits the countries so that each country can be counted individually. This was specifically explored in the SQL file.

---

# 5. Identify the Longest Movie

### Business Question

Which Movie has the longest duration?

### SQL Solution

```sql
SELECT
    title,
    type,
    duration
FROM neflix_titles
WHERE type = 'Movie'
AND duration IS NOT NULL
ORDER BY
    CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
LIMIT 1;
```

### Concepts Used

* `SPLIT_PART()`
* `CAST()`
* `INTEGER`
* `IS NOT NULL`
* `ORDER BY DESC`
* `LIMIT`

### How It Works

If the duration is:

```text
90 min
```

then:

```sql
SPLIT_PART(duration, ' ', 1)
```

returns:

```text
90
```

Then:

```sql
CAST(... AS INTEGER)
```

converts it into a number so it can be sorted correctly.

### Expected Output

| title         | type  | duration |
| ------------- | ----- | -------- |
| Longest movie | Movie | XXX min  |

The exact title and duration depend on the dataset.

---

# 6. Find Content Added in the Last 7 Years

### Business Question

Which Netflix content was added during the last seven years?

### SQL Solution

```sql
SELECT *
FROM neflix_titles
WHERE date_added >= CURRENT_DATE - INTERVAL '7 years';
```

### Concepts Used

* `CURRENT_DATE`
* `INTERVAL`
* Date arithmetic
* `WHERE`
* Comparison operators

### Expected Output

The query returns all columns for content whose `date_added` falls within the calculated seven-year period.

| show_id | type | title | date_added | ... |
| ------- | ---- | ----- | ---------- | --- |
| ...     | ...  | ...   | ...        | ... |

The actual rows change depending on the date when the query is executed.

---

# 7. Find Movies/TV Shows by Director

### Business Question

Find all Movies and TV Shows directed by **Rajiv Chilaka**.

### SQL Solution

```sql
SELECT *
FROM neflix_titles
WHERE director LIKE '%Rajiv Chilaka%';
```

### Concepts Used

* `LIKE`
* Wildcard `%`
* `WHERE`
* Pattern matching

### Expected Output

| show_id | type | title | director      | ... |
| ------- | ---- | ----- | ------------- | --- |
| ...     | ...  | ...   | Rajiv Chilaka | ... |

`%` allows `Rajiv Chilaka` to appear anywhere within the `director` column.

---

# 8. List All TV Shows with More Than 5 Seasons

### Business Question

Which TV Shows have more than five seasons?

### SQL Solution

```sql
SELECT
    title,
    type,
    duration
FROM neflix_titles
WHERE type = 'TV Show'
AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5
ORDER BY
    CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC;
```

### Concepts Used

* `WHERE`
* `AND`
* `SPLIT_PART()`
* `CAST()`
* Integer conversion
* Comparison operator `>`
* `ORDER BY DESC`

### Expected Output

| title   | type    | duration   |
| ------- | ------- | ---------- |
| TV Show | TV Show | 10 Seasons |
| TV Show | TV Show | 8 Seasons  |
| TV Show | TV Show | 6 Seasons  |

The results are sorted from the highest number of seasons to the lowest.

---

# 9. Count the Number of Content Items in Each Genre

### Business Question

How many content items belong to each genre?

### SQL Solution

```sql
SELECT
    COUNT(show_id),
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS gener
FROM neflix_titles
GROUP BY 2;
```

### Concepts Used

* `COUNT()`
* `STRING_TO_ARRAY()`
* `UNNEST()`
* `GROUP BY`
* Positional grouping

### Expected Output

| count | gener         |
| ----: | ------------- |
| Count | Drama         |
| Count | Comedies      |
| Count | Documentaries |
|   ... | ...           |

### Key Learning

A title can contain multiple genres in one column.

For example:

```text
Dramas, International Movies, Thrillers
```

`STRING_TO_ARRAY()` splits the value and `UNNEST()` turns the individual genres into rows that can be counted.

---

# 10. Analyze Indian Content by Year

### Business Question

Find the number of Netflix content items from India for each year and calculate their percentage of total Indian content.

### SQL Solution

```sql
SELECT
    EXTRACT(YEAR FROM date_added) AS year,
    COUNT(*) AS _count,
    ROUND(
        COUNT(*)::NUMERIC /
        (
            SELECT COUNT(*)
            FROM neflix_titles
            WHERE country LIKE '%India%'
        )::NUMERIC * 100,
        2
    ) AS avg_count_per_year
FROM neflix_titles
WHERE country LIKE '%India%'
GROUP BY EXTRACT(YEAR FROM date_added)
ORDER BY EXTRACT(YEAR FROM date_added);
```

### Concepts Used

* `EXTRACT()`
* `COUNT()`
* `ROUND()`
* Type casting with `::NUMERIC`
* Subquery
* `LIKE`
* `GROUP BY`
* Percentage calculation

### Expected Output

| year | _count | avg_count_per_year |
| ---: | -----: | -----------------: |
| 2018 |  Count |         Percentage |
| 2019 |  Count |         Percentage |
| 2020 |  Count |         Percentage |
|  ... |    ... |                ... |

### Key Learning

The subquery calculates the total number of Indian content items:

```sql
SELECT COUNT(*)
FROM neflix_titles
WHERE country LIKE '%India%'
```

The outer query then uses that value to calculate each year's percentage contribution.

### Note

The original comment says **"return top 5 year with highest avg content release"**, but the SQL in the uploaded file does not use `LIMIT 5` or `ORDER BY ... DESC`. The query currently returns the yearly results in ascending year order.

---

# 11. List All Movies That Are Documentaries

### Business Question

Find all Movies that belong to the Documentary genre.

### SQL Solution

```sql
SELECT *
FROM neflix_titles
WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';
```

### Concepts Used

* `WHERE`
* `AND`
* `LIKE`
* Wildcards `%`

### Expected Output

| show_id | type  | title | listed_in     | ... |
| ------- | ----- | ----- | ------------- | --- |
| ...     | Movie | ...   | Documentaries | ... |

The query searches for `Documentaries` anywhere inside the `listed_in` column.

---

# 12. Find All Content Without a Director

### Business Question

How many and which Netflix titles have no director information?

### SQL Solution

```sql
SELECT *
FROM neflix_titles
WHERE director IS NULL;
```

### Concepts Used

* `IS NULL`
* `WHERE`
* Handling missing values

### Expected Output

| show_id | title | director | ... |
| ------- | ----- | -------- | --- |
| ...     | ...   | NULL     | ... |

### Key Learning

SQL uses:

```sql
IS NULL
```

to check for missing values.

It should not be written as:

```sql
director = NULL
```

because `NULL` represents an unknown/missing value rather than a normal value.

---

# 13. Find How Many Movies Salman Khan Appeared In During the Last 10 Years

### Business Question

How many Netflix titles feature Salman Khan and were released within the last ten years?

### SQL Solution

```sql
SELECT
    COUNT(*)
FROM neflix_titles
WHERE casts LIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### Concepts Used

* `COUNT()`
* `LIKE`
* Wildcards
* `EXTRACT()`
* `CURRENT_DATE`
* Date/year calculation
* `AND`

### Expected Output

|                     count |
| ------------------------: |
| Number of matching movies |

The result is a single count value.

### Key Learning

The query dynamically calculates the year ten years before the current year instead of using a fixed year.

---

# 14. Find the Top 10 Actors with the Highest Number of Indian Movies

### Business Question

Which actors have appeared in the highest number of Movies produced in India?

### SQL Solution

```sql
SELECT
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*) AS apperiance
FROM neflix_titles
WHERE type = 'Movie'
AND country LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

### Concepts Used

* `STRING_TO_ARRAY()`
* `UNNEST()`
* `COUNT()`
* `GROUP BY`
* Positional `GROUP BY`
* Positional `ORDER BY`
* `DESC`
* `LIMIT`

### Expected Output

| actor    | apperiance |
| -------- | ---------: |
| Actor 1  |      Count |
| Actor 2  |      Count |
| Actor 3  |      Count |
| ...      |        ... |
| Actor 10 |      Count |

### Key Learning

The `casts` column can contain multiple actors in a single row.

For example:

```text
Actor A, Actor B, Actor C
```

The query separates these actors using:

```sql
STRING_TO_ARRAY(casts, ',')
```

and:

```sql
UNNEST(...)
```

Then `COUNT(*)` calculates how many Indian Movies each actor appears in.

---

# 15. Categorize Content as Good or Bad Based on Keywords

### Business Question

Categorize Netflix content based on whether the description contains the keywords `kill` or `violence`.

If either keyword is present:

```text
bad_content
```

Otherwise:

```text
good content
```

### SQL Solution

```sql
WITH new_tabel AS (
    SELECT
        *,
        CASE
            WHEN description LIKE '%kill%'
            OR description LIKE '%violence%'
            THEN 'bad_content'
            ELSE 'good content'
        END AS category
    FROM neflix_titles
)

SELECT
    category,
    COUNT(*) AS total_count
FROM new_tabel
GROUP BY 1;
```

### Concepts Used

* CTE
* `WITH`
* `CASE`
* `WHEN`
* `THEN`
* `ELSE`
* `LIKE`
* `OR`
* `COUNT()`
* `GROUP BY`

### Expected Output

| category     | total_count |
| ------------ | ----------: |
| bad_content  |       Count |
| good content |       Count |

### How It Works

The CTE creates a new calculated column called `category`.

```sql
CASE
    WHEN description LIKE '%kill%'
    OR description LIKE '%violence%'
    THEN 'bad_content'
    ELSE 'good content'
END
```

The outer query then groups the records by category and counts them.

---

# SQL Concepts Practiced

This Netflix project covers the following PostgreSQL concepts:

### Basic SQL

* `SELECT`
* `WHERE`
* `AND`
* `OR`
* `GROUP BY`
* `ORDER BY`
* `LIMIT`

### Aggregate Functions

* `COUNT()`

### String Functions

* `LIKE`
* `STRING_TO_ARRAY()`
* `UNNEST()`
* `SPLIT_PART()`
* `TO_CHAR()`

### Data Conversion

* `CAST()`
* `::NUMERIC`

### Date Functions

* `CURRENT_DATE`
* `INTERVAL`
* `EXTRACT()`

### Conditional Logic

* `CASE`
* `WHEN`
* `THEN`
* `ELSE`

### Advanced SQL

* CTEs
* Subqueries
* Aggregate calculations
* Percentage calculations
* Positional `GROUP BY`
* Positional `ORDER BY`
* Handling `NULL` values
* Handling comma-separated values

---

# Key Learning Outcomes

Through these 15 business problems, I practiced using SQL to:

* Analyze Movies and TV Shows
* Compare content types
* Analyze ratings
* Identify countries with the most content
* Work with comma-separated data
* Extract numeric values from text
* Analyze movie and TV Show duration
* Perform date-based analysis
* Filter data using patterns
* Handle missing values
* Analyze actors and directors
* Calculate yearly content trends
* Use subqueries for calculations
* Create categories using `CASE`
* Use CTEs for intermediate results

---

This Netflix analysis forms the first part of a larger **Streaming Platform SQL Analysis Project**, where different business problems will be solved for Netflix, Amazon Prime, Hulu, and Disney+ using SQL.
