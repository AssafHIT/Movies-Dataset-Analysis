SELECT * from PortfolioProject.dbo.movies_df

-- 1. Highest grossing Movie
SELECT name, gross, company
FROM PortfolioProject.dbo.movies_df
WHERE gross = (SELECT MAX(gross) FROM PortfolioProject.dbo.movies_df)

-- 2. Total earnings by company – Understand which companies have the highest earnings overall

Select top 10 company, SUM(gross) as total_gross
from PortfolioProject.dbo.movies_df
GROUP BY company 
order by total_gross desc

-- 3. Return on Investment - Movies with the highest budget vs highest gross earnings – Compare the budget and earnings to analyze return on investment

SELECT name, budget, gross, (gross / budget) AS ROI
FROM PortfolioProject.dbo.movies_df order by ROI desc

-- 4. Top-performing genres – Identify the most successful genres by total gross

SELECT genre, sum(gross) as total_gross
FROM PortfolioProject.dbo.movies_df
group by genre order by total_gross desc

-- 5. Show the Correlation between number of user votes and gross earnings 

SELECT 
    (AVG(votes * gross) - (AVG(votes) * AVG(gross))) /
    (STDEV(votes) * STDEV(gross)) AS correlation_coefficient
FROM PortfolioProject.dbo.movies_df
-- -- -- + Correlation between score rating of users and gross
SELECT 
    (AVG(score * gross) - (AVG(score) * AVG(gross))) /
    (STDEV(score) * STDEV(gross)) AS correlation_coefficient
FROM PortfolioProject.dbo.movies_df

-- 6. Movies that underperformed – Identify movies with the biggest profit loss

SELECT name, year, budget, gross, (gross - budget) AS profit
FROM PortfolioProject.dbo.movies_df
ORDER BY profit asc

-- 7. Movies by ESRB viewer rating - Show the count of movies for each rating category (e.g., R, PG, etc.)

SELECT count(name) as count, rating
FROM PortfolioProject.dbo.movies_df
group by rating ORDER BY count DESC

-- 8. Top Grossing Movies per Genre - Identify the top-grossing movie per genre
SELECT m.genre, m.name, m.year, m.gross
FROM PortfolioProject.dbo.movies_df m
JOIN (
SELECT genre, MAX(gross) AS max_gross
    FROM PortfolioProject.dbo.movies_df
    GROUP BY genre
	) as max_movies
	ON m.genre = max_movies.genre AND m.gross = max_movies.max_gross

-- 9. Average Rating by Company - Calculate the average rating for each company

select company, avg(score) as avg_score from PortfolioProject.dbo.movies_df
group by company order by avg_score desc

-- 10. Movies Released by Year - Count how many movies were released each year
SELECT year, count(year) as count from PortfolioProject.dbo.movies_df
group by year order by count desc

-- 11. Top 10 Most Successful Directors - Identify the directors whose movies earned the most
select top 10 director, sum(gross) as gross from PortfolioProject.dbo.movies_df
group by director order by gross desc

-- 12. Top 10 Most Successful Stars - Identify the stars whose movies earned the most
select top 10 star, sum(gross) as gross from PortfolioProject.dbo.movies_df
group by star order by gross desc

-- 13. Highest Grossing Movies by Country - Show the top-grossing movies grouped by country
SELECT m.country, m.name, m.gross
FROM PortfolioProject.dbo.movies_df m
JOIN (
    SELECT country, MAX(gross) AS max_gross
    FROM PortfolioProject.dbo.movies_df
    GROUP BY country
) AS max_movies
ON m.country = max_movies.country AND m.gross = max_movies.max_gross
order by gross desc

-- 14. Average Runtime by Genre - Calculate the average movie runtime for each genre
Select genre, avg(runtime) as runtime_avg
from PortfolioProject.dbo.movies_df
group by genre order by runtime_avg desc

-- 15. Average Budget by Genre - Show the average budget for movies in each genre
select genre, avg(cast(budget AS FLOAT)) as budget_avg
from PortfolioProject.dbo.movies_df
group by genre order by budget_avg desc

-- 16. Highest Budget - Show the average budget for movies
select name, budget 
from PortfolioProject.dbo.movies_df
order by budget desc

-- 17. Movies with the Highest Scores - Movies with the highest user ratings
select top 20 name, score 
from PortfolioProject.dbo.movies_df
order by budget desc

-- 18. Highest-Grossing Movie per Production Company
SELECT movies.company, movies.name, movies.gross
FROM PortfolioProject.dbo.movies_df as movies
JOIN (
    SELECT company, MAX(gross) AS max_gross
    FROM PortfolioProject.dbo.movies_df
    GROUP BY company
) as max_movies
ON movies.company = max_movies.company AND movies.gross = max_movies.max_gross
ORDER BY max_movies.max_gross DESC

-- 19. Top 3 Highest-Grossing Movies Per Genre
With RankedMovies as (
 SELECT 
        genre, name, gross,
        RANK() OVER (PARTITION BY genre ORDER BY gross DESC) AS rank
    FROM PortfolioProject.dbo.movies_df
)
select genre, name, gross FROM RankedMovies
WHERE rank <= 3
ORDER BY genre, gross DESC;

-- 20. Top 10 Director and Their Most Successful Movie
select top 10 m.director, m.name, m.gross from PortfolioProject.dbo.movies_df m
JOIN
(
select director, MAX(gross) AS max_gross from PortfolioProject.dbo.movies_df 
group by director
) as max_movies
on m.director = max_movies.director and m.gross = max_movies.max_gross
order by m.gross desc

-- 21. Top 10 Highest Earning Main Actors
select top 10 star, sum(gross) as total_earnings from PortfolioProject.dbo.movies_df
group by star
order by total_earnings desc

-- 22. Best Year for Each Company
SELECT m.company, m.year, m.total_gross
FROM (
    SELECT company, year, SUM(gross) AS total_gross,
           RANK() OVER (PARTITION BY company ORDER BY SUM(gross) DESC) AS rank
    FROM PortfolioProject.dbo.movies_df
    GROUP BY company, year
) as m
WHERE rank = 1
ORDER BY total_gross DESC;

-- 23. Top 10 Earning Years for the FIlm Industry
SELECT top 10 year, SUM(gross) AS total_gross FROM PortfolioProject.dbo.movies_df
GROUP BY year ORDER BY SUM(gross) DESC
