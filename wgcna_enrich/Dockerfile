FROM rocker/r-ver:4.3.1

RUN apt-get update && apt-get install -y \
  libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
  libpng-dev libtiff5-dev libjpeg-dev libxml2-dev libcurl4-openssl-dev \
  libssl-dev libcairo2-dev libglpk-dev libgmp-dev libx11-dev

RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org/')"
RUN R -e "BiocManager::install(version='3.17', ask=FALSE)"
RUN R -e "BiocManager::install(c('clusterProfiler','org.Hs.eg.db','enrichplot','gprofiler2'), ask=FALSE)"
RUN R -e "install.packages(c('ggplot2','dplyr','data.table','ggraph','ggforce','systemfonts','scatterpie'), repos='https://cloud.r-project.org/')"

WORKDIR /analysis
COPY run_enrichment.R /analysis/
CMD ["R"]

