#* @apiTitle API de Machine Learning: Previsão de Notas e Classificação de Curso

# Carregar dataset
StudentsPerformance <- read.csv("StudentsPerformance.csv")

# Transformar variáveis categóricas em fatores
StudentsPerformance$gender <- as.factor(StudentsPerformance$gender)
StudentsPerformance$race.ethnicity <- as.factor(StudentsPerformance$race.ethnicity)
StudentsPerformance$parental.level.of.education <- as.factor(StudentsPerformance$parental.level.of.education)

# Criar variável binária para classificação
StudentsPerformance$prep_bin <- ifelse(StudentsPerformance$test.preparation.course == "completed", 1, 0)

# MODELOS DE REGRESSÃO LINEAR MULTIVARIADA
modelo_math <- lm(math.score ~ gender + race.ethnicity + parental.level.of.education, data = StudentsPerformance)
modelo_read <- lm(reading.score ~ gender + race.ethnicity + parental.level.of.education, data = StudentsPerformance)
modelo_write <- lm(writing.score ~ gender + race.ethnicity + parental.level.of.education, data = StudentsPerformance)

# MODELO DE REGRESSÃO LOGÍSTICA
modelo_log <- glm(prep_bin ~ math.score + reading.score + writing.score, data = StudentsPerformance, family = "binomial")

#* Predição de todas as notas baseado em gênero, raça e educação dos pais
#* @param gender gênero ("female" ou "male")
#* @param race grupo étnico (ex: "group A", "group B", etc)
#* @param education nível de escolaridade dos pais (ex: "bachelor's degree")
#* @get /predicao
function(gender, race, education) {
  entrada <- data.frame(
    gender = as.factor(gender),
    race.ethnicity = as.factor(race),
    parental.level.of.education = as.factor(education)
  )
  
  math_pred <- predict(modelo_math, newdata = entrada)
  read_pred <- predict(modelo_read, newdata = entrada)
  write_pred <- predict(modelo_write, newdata = entrada)
  
  list(
    nota_matematica = math_pred,
    nota_leitura = read_pred,
    nota_escrita = write_pred
  )
}

#* Classificação do curso preparatório com base nas 3 notas
#* @param math nota de matemática
#* @param reading nota de leitura
#* @param writing nota de escrita
#* @get /classificacao
function(math, reading, writing) {
  entrada <- data.frame(
    math.score = as.numeric(math),
    reading.score = as.numeric(reading),
    writing.score = as.numeric(writing)
  )
  
  prob <- predict(modelo_log, newdata = entrada, type = "response")
  classe <- ifelse(prob > 0.5, "completed", "none")
  
  list(probabilidade = prob, classe_prevista = classe)
}
