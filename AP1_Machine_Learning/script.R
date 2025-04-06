# ========================================================
# AP1 - Projeto de Machine Learning
# Dataset: StudentsPerformance.csv
# ========================================================

# 📦 Pacotes
# install.packages(c("dplyr", "ggplot2", "nortest", "psych", "caret"))
library(dplyr)
library(ggplot2)
library(nortest)
library(psych)
library(caret)

# ========================================================
# 1. LEITURA E PRÉ-PROCESSAMENTO
# ========================================================


# Converter colunas categóricas
StudentsPerformance$gender <- as.factor(StudentsPerformance$gender)
StudentsPerformance$race.ethnicity <- as.factor(StudentsPerformance$race.ethnicity)
StudentsPerformance$parental.level.of.education <- as.factor(StudentsPerformance$parental.level.of.education)

# Criar variável binária
StudentsPerformance$prep_bin <- ifelse(StudentsPerformance$test.preparation.course == "completed", 1, 0)

# ========================================================
# 2. ANÁLISE EXPLORATÓRIA
# ========================================================

# Estrutura e resumo
str(StudentsPerformance)
summary(StudentsPerformance)
colSums(is.na(StudentsPerformance))

# Histogramas
hist(StudentsPerformance$math.score, main="Nota de Matemática", col="skyblue", border="white")
hist(StudentsPerformance$reading.score, main="Nota de Leitura", col="lightgreen", border="white")
hist(StudentsPerformance$writing.score, main="Nota de Escrita", col="salmon", border="white")

# Boxplot por preparação
boxplot(math.score ~ test.preparation.course, data = StudentsPerformance, main = "Matemática por Curso", col=c("orange", "lightblue"))

# ========================================================
# 3. TESTES DE NORMALIDADE
# ========================================================

# Shapiro-Wilk (amostra < 5000)
shapiro.test(StudentsPerformance$math.score)
shapiro.test(StudentsPerformance$reading.score)
shapiro.test(StudentsPerformance$writing.score)


# ========================================================
# 4. CORRELAÇÃO
# ========================================================

# Correlação entre notas
cor.test(StudentsPerformance$math.score, StudentsPerformance$reading.score, method = "pearson")
cor.test(StudentsPerformance$math.score, StudentsPerformance$writing.score, method = "pearson")
cor.test(StudentsPerformance$reading.score, StudentsPerformance$writing.score, method = "pearson")

# ========================================================
# 5. REGRESSÃO LINEAR MULTIVARIADA
# (gênero, raça, escolaridade → notas)
# ========================================================

modelo_math <- lm(math.score ~ gender + race.ethnicity + parental.level.of.education, data = StudentsPerformance)
modelo_read <- lm(reading.score ~ gender + race.ethnicity + parental.level.of.education, data = StudentsPerformance)
modelo_write <- lm(writing.score ~ gender + race.ethnicity + parental.level.of.education, data = StudentsPerformance)

summary(modelo_math)
summary(modelo_read)
summary(modelo_write)

# Exemplo de previsão
novo_aluno <- data.frame(
  gender = factor("female", levels = levels(StudentsPerformance$gender)),
  race.ethnicity = factor("group C", levels = levels(StudentsPerformance$race.ethnicity)),
  parental.level.of.education = factor("some college", levels = levels(StudentsPerformance$parental.level.of.education))
)

predict(modelo_math, newdata = novo_aluno)
predict(modelo_read, newdata = novo_aluno)
predict(modelo_write, newdata = novo_aluno)

# ========================================================
# 6. REGRESSÃO LOGÍSTICA
# (notas → curso preparatório)
# ========================================================

modelo_log <- glm(prep_bin ~ math.score + reading.score + writing.score, data = StudentsPerformance, family = "binomial")
summary(modelo_log)

# Previsão
entrada <- data.frame(math.score = 75, reading.score = 80, writing.score = 78)
prob <- predict(modelo_log, newdata = entrada, type = "response")
classe <- ifelse(prob > 0.5, "completed", "none")
cat("Probabilidade:", round(prob, 3), "| Classe prevista:", classe, "\n")

# Avaliação
prob_all <- predict(modelo_log, type = "response")
pred_class <- ifelse(prob_all > 0.5, 1, 0)
confusionMatrix(factor(pred_class), factor(StudentsPerformance$prep_bin))

# ========================================================
# FIM DO PROJETO
# ========================================================
