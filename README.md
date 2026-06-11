# Resumos sobre o que aprendi fazendo revisão sistemática e meta-análise

Caderno de aprendizados práticos (em R, com exemplos reais do projeto tE2-vs-ADT): como extrair dados de forma sistemática, escolher métodos estatísticos, plotar e resolver diagramação de gráficos. Cada resumo é autocontido.

## 📚 Resumos (`docs/`)

| # | Resumo | Sobre |
|---|---|---|
| 01 | [Bibliotecas úteis](docs/01_bibliotecas-uteis.md) | pacotes R por etapa: `meta`, `metafor`, `googlesheets4`, `robvis`, `PRISMA2020`, `zen4R`… o que cada um contribui + snippets |
| 02 | [Extração sistemática de dados](docs/02_extracao-sistematica-de-dados.md) | rastreabilidade, **vários relatórios do mesmo ensaio** (trial entity), planilha tidy, fluxo Zotero→Rayyan→Obsidian→R |
| 03 | [IC e heterogeneidade](docs/03_metodos-de-IC-e-heterogeneidade.md) | fixo vs aleatório, REML, **quando usar Wald vs HKSJ**, prediction interval, I²/τ²/Q, funnel só com ≥10 |
| 04 | [Plotando e diagramação](docs/04_plotando-e-diagramacao.md) | como plotar forest no `meta` + **resolver o overlap I²/τ²/p×eixo** |
| 05 | [Guia de estilos de gráficos](docs/05_guia-de-estilos-de-graficos.md) | forest (RevMan5/JAMA/meta), funnel, RoB, PRISMA, SoF, diagnósticos |
| 06 | [Análise de subgrupo](docs/06_analise-de-subgrupo.md) | com alegorias: o que é, teste de interação, **falácia ecológica** e confusão entre estudos |
| 07 | [Frequentista vs bayesiana](docs/07_frequentista-vs-bayesiana.md) | a base comum (**somar precisão / "soma de vetores"**), diferenças filosóficas e os cálculos bayesianos traduzidos |

## 🔧 Código e exemplos

- `R/render_styles.R` — renderiza o **mesmo dado em vários estilos** de forest plot + demonstra o fix de espaçamento. Gera `figures/`.
- `data/cv_mortality_example.csv` — dataset de exemplo (mortalidade CV, 3 ensaios; contagens públicas).
- `examples/prisma-latex/` — template do **fluxograma PRISMA 2020 em LaTeX/TikZ** + guia de compilação.

### Galeria rápida (forest plots)

| Problema (hetstat colado no eixo) | Corrigido |
|---|---|
| ![problema](figures/00_revman5_PROBLEMA.png) | ![corrigido](figures/01_revman5_CORRIGIDO.png) |

| Estilo JAMA | Estilo meta clássico |
|---|---|
| ![jama](figures/02_estilo_JAMA.png) | ![meta](figures/03_estilo_meta_classico.png) |

## ▶️ Rodar

```bash
R -e 'install.packages("meta", repos="https://cloud.r-project.org")'
Rscript R/render_styles.R
```
Se a instalação falhar compilando do fonte, use binários P3M — ver [docs/01](docs/01_bibliotecas-uteis.md).

---
*Aprendizados do projeto tE2-vs-ADT (revisão sistemática + meta-análise: estradiol não-oral vs ADT em câncer de próstata). Dados aqui são contagens já publicadas nos ensaios originais — sem dados de pesquisa não publicados.*
