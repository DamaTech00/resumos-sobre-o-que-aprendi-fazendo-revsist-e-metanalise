# Guia dos gráficos mais comuns em revisão sistemática / meta-análise

Catálogo rápido: **que gráfico serve pra quê**, em que estilo, e com qual pacote. Os forest plots têm exemplos renderizados em `../figures/`.

---

## 1. Forest plot — o efeito de cada estudo + o pool

O carro-chefe. Mostra cada estudo (quadrado ∝ peso + IC) e o efeito combinado (losango). Três estilos comuns:

| Estilo | Cara | Quando usar | `layout =` |
|---|---|---|---|
| **RevMan5** | Eventos/Total por braço, heterogeneidade por extenso | revisões **Cochrane**, padrão clássico | `"RevMan5"` |
| **JAMA** | enxuto: `Source` + `RR (95% CI)`, notação χ² | periódicos do grupo **JAMA** | `"JAMA"` |
| **meta (default)** | equilíbrio info/limpeza, pesos visíveis | uso geral / rascunho | `"meta"` |

Veja `../figures/01_revman5_CORRIGIDO.png`, `02_estilo_JAMA.png`, `03_estilo_meta_classico.png`.
Variante: **forest com subgrupos** (`subgroup =` + `layout="subgroup"`) pra mostrar M0 vs M1, transdérmico vs IM, etc.

---

## 2. Funnel plot — viés de publicação / small-study effects

Dispersão do efeito vs precisão (erro padrão). Assimetria sugere viés de publicação. **Só interpreta com ≥10 estudos.**
```r
funnel(m); metabias(m, method.bias = "Egger")
```

---

## 3. RoB-2 traffic light + summary — risco de viés

Não é gerado por análise: você **preenche o julgamento** (estudo × domínio → Low/Some concerns/High) numa planilha e o `robvis` desenha.
```r
library(robvis)
rob_traffic_light(data = meu_rob, tool = "ROB2")  # semáforo por estudo
rob_summary(data = meu_rob, tool = "ROB2")        # barra empilhada (% por domínio)
```

---

## 4. PRISMA 2020 flow — fluxo de seleção

O fluxograma identificação → triagem → elegibilidade → incluídos. Duas formas:
- **LaTeX/TikZ** — controle fino, ótimo pra impressão (template em `../examples/prisma-latex/`).
- **R** — `PRISMA2020::PRISMA_flowdiagram()` (rápido, interativo).

---

## 5. Summary of Findings (SoF) — certeza GRADE

Tabela (não gráfico) com efeito + nº de participantes + **certeza GRADE** por desfecho. Faz no **GRADEpro** (gdt.gradepro.org, grátis) ou monta com `gt`/`gtsummary` a partir da tabela de síntese.

---

## 6. Diagnósticos de sensibilidade (avançado)

| Gráfico | Pra quê | Pacote |
|---|---|---|
| **Leave-one-out** | qual estudo dirige o resultado | `meta::metainf` / `metafor` |
| **Baujat** | estudos que mais contribuem pra heterogeneidade | `metafor::baujat` |
| **GOSH** | padrões/subgrupos escondidos na heterogeneidade | `dmetar` / `metafor` |
| **Drapery** | curvas de p por nível de confiança | `meta::drapery` |

---

## Tabela-resumo

| Quero mostrar… | Gráfico | Pacote |
|---|---|---|
| efeito por estudo + pool | forest | `meta` |
| viés de publicação (≥10) | funnel + Egger | `meta` |
| risco de viés | RoB traffic light/summary | `robvis` |
| fluxo de seleção | PRISMA flow | TikZ / `PRISMA2020` |
| certeza da evidência | SoF table | GRADEpro / `gt` |
| o que dirige o resultado | leave-one-out / Baujat / GOSH | `meta` / `metafor` / `dmetar` |

---

### TL;DR
Forest (RevMan5/JAMA/meta) é o principal · funnel só com ≥10 · RoB e PRISMA não saem de "análise" (você preenche/desenha) · sensibilidade (LOO/Baujat/GOSH) conta a história de **por que** o pool é o que é.
