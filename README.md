# 🎓 Projeto de Machine Learning – AP1

Este projeto tem como objetivo aplicar técnicas estatísticas e modelos de Machine Learning a um conjunto de dados real, passando pelas etapas de análise exploratória, modelagem (regressão linear e logística) e publicação dos modelos via API REST.

---

## 📁 Dataset

**Fonte:** Kaggle - [Students Performance in Exams](https://www.kaggle.com/datasets/spscientist/students-performance-in-exams)  
**Registros:** 1000  
**Variáveis:** 8 (categóricas e contínuas)

O dataset contém dados sobre estudantes, como gênero, etnia, escolaridade dos pais, tipo de almoço, curso preparatório e notas em matemática, leitura e escrita.

---

## 🧪 Etapas do Projeto

### 1. 📊 Análise Exploratória
- Verificação de valores ausentes
- Estatísticas descritivas
- Histogramas e boxplots
- Conversão de variáveis categóricas em fatores

### 2. 📈 Testes Estatísticos
- Teste de normalidade: Shapiro-Wilk
- Correlação de Pearson entre as notas

### 3. 🔢 Regressão Logística
- Objetivo: prever se o aluno fez curso preparatório (`completed` ou `none`)
- Variáveis preditoras: notas de matemática, leitura e escrita
- Métrica: acurácia, matriz de confusão

### 4. 📉 Regressão Linear Multivariada
- Objetivo: prever notas (matemática, leitura e escrita)
- Variáveis preditoras: gênero, grupo étnico, escolaridade dos pais e tipo de almoço (`lunch`)

---

## ⚙️ Modelos Utilizados

| Modelo               | Tipo       | Variável-Alvo                     | Preditores                                     |
|----------------------|------------|-----------------------------------|------------------------------------------------|
| Regressão Linear     | Numérica   | math.score, reading.score, writing.score | gender, race.ethnicity, parental.level.of.education, lunch |
| Regressão Logística  | Binária    | test.preparation.course (`completed`) | math.score, reading.score, writing.score       |

---

## 🌐 API REST

A API foi criada com o pacote [`plumber`](https://www.rplumber.io/) em R e possui dois endpoints:

### 1. `/predicao`
- **Método:** GET  
- **Parâmetros:** `gender`, `race`, `education`, `lunch`  
- **Retorno:** Notas previstas (matemática, leitura e escrita)

### 2. `/classificacao`
- **Método:** GET  
- **Parâmetros:** `math`, `reading`, `writing`  
- **Retorno:** Probabilidade e classe (`completed` ou `none`)

### 🛠 Como rodar a API localmente

```r
library(plumber)
setwd("C:/CAMINHO/DO/SEU/PROJETO")  # ajuste para o seu diretório
r <- plumb("api.R")
r$run(port = 8000)
