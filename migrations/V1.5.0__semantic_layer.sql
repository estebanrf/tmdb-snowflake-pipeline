-- Stage for AI Studio Semantic Model YAML (directory table required by AI Studio)
CREATE STAGE IF NOT EXISTS TMDB_DB.ANALYTICS.SEMANTIC_MODELS_STAGE
    DIRECTORY = (ENABLE = TRUE);

GRANT READ ON STAGE TMDB_DB.ANALYTICS.SEMANTIC_MODELS_STAGE TO ROLE DATAIKU_ROLE;

-- Semantic View for programmatic/SQL access to the enriched movie data
CREATE OR REPLACE SEMANTIC VIEW TMDB_DB.ANALYTICS.TMDB_SEMANTIC_MODEL
    AS SELECT
        movie_id,
        title,
        release_date,
        release_year,
        overview,
        popularity,
        vote_average,
        vote_count,
        budget,
        revenue,
        runtime,
        genres,
        director,
        original_language,
        rating_category,
        roi_pct
    FROM TMDB_DB.TRANSFORMED.DT_MOVIES_ENRICHED
    COMMENT = 'Semantic model for TMDB movies pipeline';

GRANT SELECT ON SEMANTIC VIEW TMDB_DB.ANALYTICS.TMDB_SEMANTIC_MODEL TO ROLE DATAIKU_ROLE;
