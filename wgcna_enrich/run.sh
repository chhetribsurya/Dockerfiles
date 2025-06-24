#docker run --rm \
#  -v "$PWD/data":/analysis/data \
#  -v "$PWD/run_enrichment.R":/analysis/run_enrichment.R \
#  -w /analysis \
#  chhetribsurya/enrich_env:1.2 Rscript /analysis/run_enrichment.R

# Alternativey using the relative path: -w /analysis
docker run --rm \
  -v "$PWD/data":/analysis/data \
  -v "$PWD/run_enrichment.R":/analysis/run_enrichment.R \
  chhetribsurya/enrich_env:1.2 Rscript /analysis/run_enrichment.R
