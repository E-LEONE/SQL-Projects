-- Here I explore the hacker_news table and pull out the top 5 stories with the highest score:

SELECT *, title, score
FROM hacker_news
ORDER BY score DESC
LIMIT 5;


-- In the query below I want to find the total score of all the stories:

SELECT SUM(score) AS 'total_score'
FROM hacker_news;


-- Here I am looking to find the most influential users in the table:

SELECT user, SUM(score)
FROM hacker_news
GROUP BY 1
HAVING SUM(score) > 200;


-- Is the Hacker News dominated by the top 5 users? In the query below I am calculating the percentage:

SELECT (309 + 304 + 282 + 517) / 6366.0;


-- Firstly, here I am categorising each story based on their source using a CASE statement and then counting the number of stories from each URL:

SELECT
  CASE
   WHEN url LIKE '%github.com%' THEN 'GitHub'
   WHEN url LIKE '%medium.com%' THEN 'Medium'
   WHEN url LIKE '%nytimes.com%' THEN 'New York Times'
   ELSE 'Other'
  END AS 'Source',
 COUNT(url) AS 'How many'
FROM hacker_news
GROUP BY 1;


-- Now I want to know what's the best time to post on Hacker News based on, but before I want to take a look at the 'timestamp' column:

SELECT timestamp
FROM hacker_news
LIMIT 10;


-- Here I am using the function to return the formatted date:

SELECT timestamp,
   strftime('%H', timestamp)
FROM hacker_news
GROUP BY 1
LIMIT 20;


-- And finally, I am be creating 3 columns and get the best hours to post a story on 'Hacker News':

SELECT
  strftime('%H', timestamp) AS hour, 
  ROUND(AVG(score)) AS avg_score, 
  COUNT(*) AS num_stories
FROM hacker_news
WHERE timestamp IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;