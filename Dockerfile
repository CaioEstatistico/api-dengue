FROM rocker/r-ver:4.3.2

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

# Instalar pacotes R
COPY install.R /install.R
RUN R -f /install.R

# Copiar a API
COPY plumber.R /plumber.R
COPY modelo_dengue.rds /modelo_dengue.rds

# Expor porta
EXPOSE 8000

# Rodar a API
CMD ["R", "-e", "plumber::plumb('plumber.R')$run(host='0.0.0.0', port=8000)"]