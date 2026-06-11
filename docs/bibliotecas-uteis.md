# Bibliotecas R úteis para revisão sistemática + meta-análise

Coletânea de pacotes que valem a pena, agrupados por etapa. Cada um traz: **o que contribui**, `install.packages(...)` e um trecho mínimo. Muitos são diretamente úteis pro projeto tE2-vs-ADT (meta-análise, RoB-2, PRISMA, Zenodo).

> Dica de instalação no Ubuntu: se algum pacote falhar **compilando do código-fonte** (`lme4`, `tzdb`, `stringi`…), instale **binário** do Posit P3M:
> ```r
> options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(),
>         paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))
> options(repos = "https://packagemanager.posit.co/cran/__linux__/noble/latest")  # troque 'noble' pelo seu codinome
> ```

---

## 📊 Meta-análise

### `meta`
Meta-análise "pronta": pooling (RR/HR/MD), heterogeneidade, **forest plots** em vários layouts (RevMan5, JAMA), funnel, subgrupos. É o que este repo usa.
```r
install.packages("meta")
library(meta)
m <- metabin(event.e, n.e, event.c, n.c, studlab = study, data = d,
             sm = "RR", random = TRUE, method.tau = "REML", method.random.ci = "HK")
forest(m, layout = "RevMan5")
```

### `metafor`
O canivete suíço da meta-análise: mais flexível que o `meta` — **meta-regressão**, modelos multinível/multivariados, métodos para viés de publicação, diagnósticos (influência, leave-one-out).
```r
install.packages("metafor")
library(metafor)
res <- rma(yi, vi, data = dat, method = "REML")   # efeitos aleatórios
regtest(res)        # teste de Egger
influence(res)      # diagnóstico de influência
```

### `dmetar`
Companion do livro *Doing Meta-Analysis in R*. Funções de apoio: cálculo de **poder**, detecção de outliers, análise de influência (GOSH), pooling de proporções.
```r
# install.packages("remotes"); remotes::install_github("MathiasHarrer/dmetar")
library(dmetar)
find.outliers(m)
InfluenceAnalysis(m)
```

---

## 🔍 Busca e triagem (revisão sistemática)

### `rentrez`
Acesso programático ao **Entrez/NCBI (PubMed)**: busca, conta hits, baixa resumos. Bom pra registrar nº de registros por base (PRISMA).
```r
install.packages("rentrez")
library(rentrez)
entrez_search(db = "pubmed", term = "transdermal estradiol AND prostate cancer")$count
```

### `easyPubMed`
Baixa e parseia registros do PubMed (autores, abstract, MeSH) pra `data.frame`.
```r
install.packages("easyPubMed")
```

### `revtools` / `litsearchr`
`revtools`: importa `.ris/.bib`, **deduplica** e ajuda na triagem (inclusive visual). `litsearchr`: ajuda a **construir a string de busca** (identifica termos/keywords).
```r
install.packages(c("revtools", "litsearchr"))
```

---

## ⚖️ Risco de viés, PRISMA e certeza

### `robvis`  ⭐ (útil pro tE2 — RoB-2)
Gera os gráficos de **risco de viés**: *traffic light plot* e *summary barplot* a partir de uma planilha RoB-2 / ROBINS-I.
```r
install.packages("robvis")
library(robvis)
rob_traffic_light(data = meu_rob, tool = "ROB2")
rob_summary(data = meu_rob, tool = "ROB2")
```

### `PRISMA2020`  ⭐ (útil pro tE2 — Fig 1)
Desenha o **fluxograma PRISMA 2020** (identificação → triagem → incluídos) interativo/exportável.
```r
install.packages("PRISMA2020")
library(PRISMA2020)
# preenche um template e renderiza:
data <- read.csv(PRISMA_data_template())
PRISMA_flowdiagram(PRISMA_data(data))
```
*(Alternativa clássica: `DiagrammeR` para fluxogramas genéricos.)*

---

## 📥 Importar dados

### `googlesheets4`  ⭐ (a "do Google" — planilhas públicas sem login)
Lê/escreve **Google Sheets**. Para planilhas **públicas**, chame `gs4_deauth()` antes — aí lê sem autenticação.
```r
install.packages("googlesheets4")
library(googlesheets4)
gs4_deauth()                                  # planilha pública: dispensa login
df <- read_sheet("https://docs.google.com/spreadsheets/d/<ID>/edit")
# privada: gs4_auth() abre o fluxo OAuth no navegador
```

### `readxl` / `readr` / `data.table`
`readxl`: lê `.xlsx/.xls` (sem Java). `readr`: CSV/TSV rápido e previsível. `data.table::fread`: leitura de CSV gigante, muito rápida.
```r
install.packages(c("readxl", "readr", "data.table"))
readxl::read_excel("dados.xlsx", sheet = 1)
```

---

## 🧹 Arrumar e transformar

### `dplyr` + `tidyr` (tidyverse)
Gramática de manipulação de dados: `filter/mutate/summarise/group_by`, pivot longo↔largo. Base de quase tudo.
```r
install.packages("tidyverse")   # puxa dplyr, tidyr, ggplot2, readr, stringr, purrr...
```

### `janitor`
Limpa nomes de coluna (`clean_names()`), tabelas de frequência (`tabyl()`), remove linhas/colunas vazias. Ótimo pós-importação de Excel/Sheets.
```r
install.packages("janitor")
df <- janitor::clean_names(df)
```

---

## 📋 Tabelas de publicação

### `gtsummary`  ⭐ (Tabela 1 clínica)
Tabelas descritivas e de regressão prontas pra artigo — incluindo a clássica **Table 1** (baseline) com testes e formatação.
```r
install.packages("gtsummary")
library(gtsummary)
tbl_summary(dados, by = grupo) |> add_p()
```

### `gt` / `flextable`
`gt`: tabelas elegantes (HTML/PNG). `flextable`: tabelas para **Word/PowerPoint** (combina com `officer`).
```r
install.packages(c("gt", "flextable"))
```

---

## 📈 Gráficos

### `ggplot2` (+ `patchwork`, `scales`)
Gramática de gráficos. `patchwork` junta painéis (`p1 + p2`); `scales` formata eixos (%, vírgula decimal).
```r
install.packages(c("ggplot2", "patchwork", "scales"))
```

---

## 🔁 Reprodutibilidade e arquivamento

### `here`
Caminhos relativos à raiz do projeto (`here("data","x.csv")`) — acaba com `setwd()` e caminhos absolutos quebrados.
```r
install.packages("here")
```

### `renv`
Trava as **versões dos pacotes** por projeto (lockfile) → reprodutível em qualquer máquina.
```r
install.packages("renv"); renv::init()
```

### `osfr` / `zen4R`  ⭐ (útil pro tE2 — Zenodo/OSF)
`osfr`: sobe/baixa do **OSF**. `zen4R`: cria depósito no **Zenodo** e **reserva DOI** via API — exatamente o passo pendente de arquivamento.
```r
install.packages(c("osfr", "zen4R"))
library(zen4R)
zenodo <- ZenodoManager$new(token = Sys.getenv("ZENODO_TOKEN"))
dep <- zenodo$createEmptyRecord()   # reserva DOI
```

---

### Resumo — o que instalar primeiro (foco tE2)
```r
install.packages(c(
  "meta", "metafor",        # meta-análise + forest
  "robvis",                 # RoB-2 (traffic light)
  "PRISMA2020",             # fluxograma PRISMA
  "gtsummary",              # Table 1
  "googlesheets4", "readxl",# importar dados
  "dplyr", "janitor",       # arrumar
  "zen4R", "here"           # Zenodo + caminhos
))
```
