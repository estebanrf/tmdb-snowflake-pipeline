# TMDB Snowflake Pipeline

Snowflake DDL deployment pipeline for the TMDB movie data project. Manages all Snowflake objects via versioned SQL migrations deployed through GitHub Actions + Schemachange.

## Stack

- **Migrations** — Schemachange (versioned SQL, `V{major}.{minor}.{patch}__description.sql`)
- **CI/CD** — GitHub Actions with two environments: `dev` (branch push) and `prod` (tag push)
- **Auth** — RSA key-pair for `DATAIKU_USER`; admin ops use password from GitHub secrets

## Migration history

| Version | What it creates |
|---------|----------------|
| V1.0.0 | Warehouse `TMDB_WH`, database `TMDB_DB`, schemas RAW/TRANSFORMED/ANALYTICS, role `DATAIKU_ROLE`, user `DATAIKU_USER` |
| V1.1.0 | Dynamic Tables `DT_MOVIES_ENRICHED` (TRANSFORMED) and `DT_GENRE_ANALYTICS` (ANALYTICS), both at 1h lag |
| V1.2.0 | Row Access Policy `ADULT_CONTENT_POLICY`, tag `SENSITIVE_FINANCIAL`, masking policy `FINANCIAL_MASK` |
| V1.3.0 | 7 Data Metric Functions across RAW, TRANSFORMED, and ANALYTICS layers |
| V1.4.0 | Stage `SEMANTIC_MODELS_STAGE` with directory table enabled |
| V1.5.0 | Semantic View `TMDB_SEMANTIC_VIEW` (DDL extracted via `GET_DDL`) |
| V1.6.0 | Cortex Search Service DDL (commented,requires paid Snowflake account) |

## Deployment

### Dev — push to `main`

Any push to `main` that touches `migrations/**` or `.github/workflows/**` triggers `deploy-dev`, which runs against the `dev` GitHub Environment secrets.

### Prod — push a version tag

```bash
git tag v1.0.0
git push --tags
```

Triggers `deploy-prod` against the `prod` GitHub Environment secrets. Add required reviewers in **GitHub → Settings → Environments → prod** for a manual approval gate.

## GitHub secrets required (per environment)

| Secret | Description |
|--------|-------------|
| `SNOWFLAKE_ACCOUNT` | Account identifier (e.g. `abc12345.eu-west-2.aws`) |
| `SNOWFLAKE_USER` | Admin user for bootstrap + schemachange |
| `SNOWFLAKE_PASSWORD` | Admin user password |
| `DATAIKU_PUBLIC_KEY` | RSA public key (PEM format) set on `DATAIKU_USER` |

## Local setup

```bash
pip install -r requirements.txt

schemachange deploy \
  --snowflake-account <account> \
  --snowflake-user <user> \
  --snowflake-role ACCOUNTADMIN \
  --snowflake-warehouse TMDB_WH \
  --snowflake-database SCHEMACHANGE_DB \
  --root-folder migrations \
  --create-change-history-table \
  --change-history-table SCHEMACHANGE_DB.PUBLIC.TMDB_HISTORY
```
