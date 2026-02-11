FROM rocker/r-ver:4.3.2

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

# Instalar pacotes R
COPY install.r /install.r
RUN R -e "install.packages(c('plumber','jsonlite','glmnet','caret'), repos='https://cloud.r-project.org')"

# Copiar a API
COPY plumber.r /plumber.r
COPY modelo_lasso_dengue.rds /modelo_lasso_dengue.rds
COPY variaveis_modelo.rds /variaveis_modelo.rds

# Expor porta
EXPOSE 8000

# Rodar a API
CMD ["R", "-e", "plumber::plumb('plumber.r')$run(host='0.0.0.0', port=8000)"]