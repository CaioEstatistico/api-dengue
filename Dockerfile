FROM rocker/r-ver:4.3.2

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean

# Instalar pacotes R
COPY install.r /install.r
RUN R -e "source('/install.r')"

# Copiar arquivos da API
COPY plumber.r /plumber.r
COPY modelo_lasso_dengue.rds /modelo_lasso_dengue.rds

# Porta padrão do HF
EXPOSE 7860

# Rodar API
CMD ["R", "-e", "plumber::plumb('/plumber.r')$run(host='0.0.0.0', port=7860)"]