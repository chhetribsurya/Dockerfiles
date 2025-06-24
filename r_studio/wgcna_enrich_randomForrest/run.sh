docker run -d --rm \
  -e PASSWORD=rstudio \
  -p 8788:8787 \
  -v "$HOME/Dropbox":/home/rstudio/project \
  enrich_wgcna_env_rstudio:latest

#Dockerhub versions
#chhetribsurya/enrich_wgcna_env_rstudio

#username:rstudio
#password:rstudio
