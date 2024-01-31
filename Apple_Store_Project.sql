-- First of all I had to split my dataset into 4 different .csv files because the size was too bug to work with.
-- By using UNION ALL I combined all the files back into one table

CREATE TABLE AppleStore_description_combined AS

SELECT *
FROM appleStore_description1

UNION ALL

SELECT *
FROM appleStore_description2

UNION ALL

SELECT *
FROM appleStore_description3

UNION ALL

SELECT *
FROM appleStore_description4

-- EXPLORATORY DATA ANALISYS
-- check the number of unique apps in the newly created table.

SELECT COUNT(DISTINCT id) AS 'Unique_apps_ID'
FROM Apple_Store;

SELECT COUNT(DISTINCT id) AS 'Unique_apps_ID'
FROM AppleStore_description_combined;

-- Check for any missing values in the key fields.

SELECT COUNT(*) AS 'Missing_Values'
FROM Apple_Store
WHERE track_name IS null OR user_rating IS null OR prime_genre IS null;

SELECT COUNT(*) AS 'Missing_Values'
FROM AppleStore_description_combined
WHERE app_desc IS null;

-- Find out the number of apps per genre

SELECT prime_genre, COUNT(*) AS 'Num_Apps'
FROM Apple_Store
GROUP BY prime_genre
ORDER BY Num_Apps DESC;

-- Get an overview of the apps' ratings

SELECT MIN(user_rating) AS 'Min_rating',
		MAX(user_rating) AS 'Max_rating',
        AVG(user_rating) AS 'Avg_rating'
FROM Apple_Store;

-- DATA ANALYSIS

-- Determine whether paid apps have better ratings than free apps:

SELECT 
	CASE
	WHEN price > 0 THEN 'Paid'
    ELSE 'Free'
    END AS 'App_type',
    AVG(user_rating) AS 'Avg_rating'
FROM Apple_Store
GROUP BY App_type;

-- Check if apps that support more languages have higher ratings 

SELECT 
	CASE
    WHEN lang_num < 10 THEN '<10 languages'
    WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
    ELSE '>30 languages'
    END AS 'language_bucket',
    AVG(user_rating) AS 'Avg_rating'
FROM Apple_Store
GROUP BY language_bucket
ORDER BY Avg_rating DESC;

-- check genres with low rating 

SELECT prime_genre,
	AVG(user_rating) AS 'Avg_rating'
 FROM Apple_Store
 GROUP BY prime_genre
 ORDER BY Avg_rating ASC
 LIMIT 5;
 
 -- check if there is correlation between the app's description length and user rating 
 
 SELECT 
 	CASE
    WHEN LENGTH(b.app_desc) < 500 THEN 'Short'
    WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
    ELSE 'Long'
    END AS 'description_length_buckets',
    AVG(a.user_rating) AS 'average_rating'
FROM Apple_Store AS a 
JOIN AppleStore_description_combined AS b 
ON a.id = b.id
GROUP BY description_length_buckets
ORDER BY average_rating DESC;