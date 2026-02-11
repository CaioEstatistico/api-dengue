library(plumber)
library(glmnet)
library(jsonlite)
library(dplyr)

modelo <- readRDS("modelo_lasso_dengue.rds")
vars_modelo <- readRDS("variaveis_modelo.rds")

#* API de previsão de dengue
#* @post /prever
#* @serializer json
function(req){

  dados <- as.data.frame(fromJSON(req$postBody))

  X <- model.matrix(~ . - 1, data = dados)

  X_final <- matrix(0, nrow = 1, ncol = length(vars_modelo))
  colnames(X_final) <- vars_modelo

  X_final[, intersect(colnames(X), vars_modelo)] <- 
    X[, intersect(colnames(X), vars_modelo)]

  prob <- as.numeric(predict(modelo, newx = X_final, type = "response"))

  list(
    probabilidade = round(prob, 3),
    classe = ifelse(prob >= 0.369331, "Positivo", "Negativo"),
    risco = ifelse(prob < 0.30, "Baixo",
                   ifelse(prob < 0.60, "Moderado", "Alto"))
  )
}


library(plumber)

#* @apiTitle API Dengue

#* Teste
#* @get /ping
function() {
  list(status = "ok")
}