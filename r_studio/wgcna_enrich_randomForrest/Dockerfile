FROM rocker/rstudio:4.3.1

# System libraries required by R and its packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libcairo2-dev \
    libglpk-dev \
    libgmp-dev \
    libx11-dev \
    libxt-dev \
    libgfortran5 \
    libfftw3-dev \
    libopenblas-dev \
    liblapack-dev \
    libreadline-dev \
    libbz2-dev \
    zlib1g-dev \
    libpcre2-dev \
    && apt-get clean

# Install BiocManager and set Bioconductor version
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org/')"
RUN R -e "BiocManager::install(version='3.17', ask=FALSE)"

# Install Bioconductor packages
RUN R -e "BiocManager::install(c('clusterProfiler','org.Hs.eg.db','enrichplot','gprofiler2','sva'), ask=FALSE)"

# Install CRAN packages
RUN R -e "install.packages(c( \
    'ggplot2', 'dplyr', 'data.table', 'ggraph', 'ggforce', 'systemfonts', 'scatterpie', \
    'WGCNA', 'flashClust', 'curl', 'missForest', 'randomForest', 'readr' \
    ), repos='https://cloud.r-project.org')"

