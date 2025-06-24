# Use the official Rocker R base image with R version 4.3
FROM bioconductor/r-ver:3.18-R-4.3.2

# Install system dependencies
RUN apt-get update
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libbz2-dev
RUN apt-get install -y liblzma-dev

# Install required R packages
RUN R -e "install.packages(c('readr', 'dplyr'), repos='https://cran.rstudio.com/')"
RUN R -e 'BiocManager::install(version = "3.18",ask = F)' && R -e 'BiocManager::install(c("rtracklayer","GenomicRanges","AnnotationDbi",ask = F))'
