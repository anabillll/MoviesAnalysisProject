-- Data Cleaning Phase

-- Step 1: Remove Duplicates
DELETE FROM movie_dataset
WHERE id NOT IN (
    SELECT MIN(id)
    FROM movie_dataset
    GROUP BY title, release_date
);

-- Step 2: Handle Missing Values
-- Numeric Columns
UPDATE movie_dataset
SET popularity = 0
WHERE popularity IS NULL;

UPDATE movie_dataset
SET vote_count = 0
WHERE vote_count IS NULL;

UPDATE movie_dataset
SET vote_average = 0
WHERE vote_average IS NULL;

-- Text Columns
UPDATE movie_dataset
SET title = 'Unknown'
WHERE title IS NULL;

UPDATE movie_dataset
SET genres = 'Unknown'
WHERE genres IS NULL;

UPDATE movie_dataset
SET original_language = 'Unknown'
WHERE original_language IS NULL;

UPDATE movie_dataset
SET overview = 'No overview available'
WHERE overview IS NULL;

-- Step 3: Standardize Data Formats
-- Convert release_date to a standard format
UPDATE movie_dataset
SET release_date = CONVERT(DATE, release_date);

-- Trim whitespace
UPDATE movie_dataset
SET title = TRIM(title),
    genres = TRIM(genres),
    original_language = TRIM(original_language),
    overview = TRIM(overview);

-- Step 4: Filter Out Irrelevant Data
-- Remove rows without a title
DELETE FROM movie_dataset
WHERE title = 'Unknown';

-- Data Analysis Phase

-- Basic Descriptive Statistics

-- 1. Count the number of movies
SELECT COUNT(*) AS TotalMovies
FROM movie_dataset;

-- 2. Average rating of movies
SELECT AVG(vote_average) AS AverageRating
FROM movie_dataset;

-- 3. Average popularity of movies
SELECT AVG(popularity) AS AveragePopularity
FROM movie_dataset;

-- 4. Movies count by genre
SELECT genres, COUNT(*) AS MoviesCount
FROM movie_dataset
GROUP BY genres;

-- Advanced Queries

-- 1. Top 10 highest rated movies
SELECT TOP 10 title, vote_average
FROM movie_dataset
ORDER BY vote_average DESC;

-- 2. Average rating by genre
SELECT genres, AVG(vote_average) AS AverageRating
FROM movie_dataset
GROUP BY genres;

-- 3. Total popularity by year
SELECT YEAR(release_date) AS Year, SUM(popularity) AS TotalPopularity
FROM movie_dataset
GROUP BY YEAR(release_date)
ORDER BY Year;

-- 4. Movies released each year
SELECT YEAR(release_date) AS Year, COUNT(*) AS MoviesCount
FROM movie_dataset
GROUP BY YEAR(release_date)
ORDER BY Year;

-- 5. Movies with the highest vote counts (top 10)
SELECT TOP 10 title, vote_count
FROM movie_dataset
ORDER BY vote_count DESC;

-- 6. Average vote count by year
SELECT YEAR(release_date) AS Year, AVG(vote_count) AS AverageVoteCount
FROM movie_dataset
GROUP BY YEAR(release_date)
ORDER BY Year;
