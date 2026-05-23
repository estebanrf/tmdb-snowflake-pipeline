-- Placeholder table so dynamic tables can be created before Dataiku runs
CREATE TABLE IF NOT EXISTS TMDB_DB.RAW.RAW_MOVIES (
    "movie_id" NUMBER,
    "title" VARCHAR,
    "release_date" VARCHAR,
    "overview" VARCHAR,
    "popularity" FLOAT,
    "vote_average" FLOAT,
    "vote_count" NUMBER,
    "budget" NUMBER,
    "revenue" NUMBER,
    "runtime" NUMBER,
    "genres" VARCHAR,
    "keywords" VARCHAR,
    "top_cast" VARCHAR,
    "director" VARCHAR,
    "original_language" VARCHAR,
    "adult" BOOLEAN
);

CREATE OR REPLACE DYNAMIC TABLE TMDB_DB.TRANSFORMED.DT_MOVIES_ENRICHED
    TARGET_LAG = '1 hour'
    WAREHOUSE = TMDB_WH
AS
SELECT
    "movie_id"          AS movie_id,
    "title"             AS title,
    TO_DATE("release_date") AS release_date,
    YEAR(TO_DATE("release_date")) AS release_year,
    "overview"          AS overview,
    "popularity"        AS popularity,
    "vote_average"      AS vote_average,
    "vote_count"        AS vote_count,
    "budget"            AS budget,
    "revenue"           AS revenue,
    "runtime"           AS runtime,
    "genres"            AS genres,
    "keywords"          AS keywords,
    "top_cast"          AS top_cast,
    "director"          AS director,
    "original_language" AS original_language,
    "adult"             AS adult,
    CASE
        WHEN "vote_average" >= 8 THEN 'Excellent'
        WHEN "vote_average" >= 6 THEN 'Good'
        WHEN "vote_average" >= 4 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category,
    CASE
        WHEN "revenue" > 0 AND "budget" > 0 THEN ROUND(("revenue" - "budget") / "budget" * 100, 2)
        ELSE NULL
    END AS roi_pct
FROM TMDB_DB.RAW.RAW_MOVIES;

CREATE OR REPLACE DYNAMIC TABLE TMDB_DB.ANALYTICS.DT_GENRE_ANALYTICS
    TARGET_LAG = '1 hour'
    WAREHOUSE = TMDB_WH
AS
SELECT
    genres,
    release_year,
    COUNT(*) AS total_movies,
    ROUND(AVG(vote_average), 2) AS avg_rating,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    SUM(revenue) AS total_revenue,
    SUM(budget) AS total_budget,
    ROUND(AVG(roi_pct), 2) AS avg_roi_pct,
    MAX(title) AS top_movie
FROM TMDB_DB.TRANSFORMED.DT_MOVIES_ENRICHED
WHERE release_year IS NOT NULL
GROUP BY genres, release_year;