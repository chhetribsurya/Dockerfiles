# Use the official Rocker R base image with R version 4.3
FROM bioconductor/r-ver:3.18-R-4.3.2

# Install system dependencies
RUN apt-get update
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y libssl-dev 
RUN apt-get install -y libxml2-dev 
RUN apt-get install -y libbz2-dev 
RUN apt-get install -y liblzma-dev 
RUN apt-get install -y libfreetype6-dev 
RUN apt-get install -y libpng-dev 
RUN apt-get install -y libtiff5-dev 
RUN apt-get install -y libjpeg-dev
RUN apt-get install -y libgit2-dev
RUN apt-get install -y libglpk-dev
RUN apt-get install -y zlib1g-dev

# Install required R packages
RUN R -e "install.packages(c('optparse', 'ggplot2', 'reshape2', 'gridExtra', 'grid', 'dplyr', 'scales', 'RColorBrewer'), repos='https://cran.rstudio.com/')"
RUN R -e 'BiocManager::install(version = "3.18",ask = F)' && R -e 'BiocManager::install(c("rtracklayer","GenomicRanges","AnnotationDbi","ChIPseeker","org.Hs.eg.db",ask = F))'