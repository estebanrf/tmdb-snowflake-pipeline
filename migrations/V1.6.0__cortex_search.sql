-- Cortex Search Service for semantic search over movie plot descriptions
-- Uncomment to deploy on a paid Snowflake account (EMBED_TEXT_768 not available on trial)
SELECT 'Cortex Search Service pending - requires paid Snowflake account' AS deployment_note;

-- CREATE OR REPLACE CORTEX SEARCH SERVICE TMDB_DB.ANALYTICS.TMDB_CORTEX_SEARCH
--     ON overview
--     ATTRIBUTES title, genres, director, release_year, rating_category
--     WAREHOUSE = TMDB_WH
--     TARGET_LAG = '1 hour'
--     EMBEDDING_MODEL = 'snowflake-arctic-embed-m-v1.5'
--     AS SELECT
--         title,
--         overview,
--         genres,
--         director,
--         release_year,
--         rating_category
--     FROM TMDB_DB.TRANSFORMED.DT_MOVIES_ENRICHED
--     WHERE overview IS NOT NULL;

-- GRANT USAGE ON CORTEX SEARCH SERVICE TMDB_DB.ANALYTICS.TMDB_CORTEX_SEARCH TO ROLE DATAIKU_ROLE;
