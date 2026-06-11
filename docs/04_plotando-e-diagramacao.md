# Como plotar (e resolver a diagramação) do forest plot

Resumo prático de como sair do modelo `meta` pra uma figura limpa — incluindo **o problema de diagramação** em que as estatísticas (I², τ², p) ficam coladas no eixo, e como resolver.

---

## 1. Anatomia de um forest plot

```
Estudo   Eventos/Total (E)   Eventos/Total (C)        ◼──┼──◼   RR [IC]
─────────────────────────────────────────────────────────────────────
estudo 1                                          ──◼──        ...
estudo 2                                            ──◼──      ...
Total (pool)                                        ◆          ◆ RR [IC]
Prediction interval                              ▬▬▬▬▬▬▬
                              0.1   0.5   1   2   10   ← eixo (log)
Heterogeneity: τ²=…; I²=…; p=…   ← estatísticas
```
- Quadrados = estudos (tamanho ∝ peso). Linhas = IC. Losango = efeito combinado.
- Eixo geralmente em **escala log** (RR/HR são multiplicativos).

---

## 2. Código mínimo (`meta`)

```r
library(meta)
m <- metabin(event.e, n.e, event.c, n.c, studlab = study, data = d,
             sm = "RR", random = TRUE, common = FALSE,
             method.tau = "REML", method.random.ci = "HK", prediction = TRUE)
forest(m, layout = "RevMan5")
```
Exportar com resolução boa:
```r
png("forest.png", width = 3400, height = 1900, res = 300)
forest(m, layout = "RevMan5", ...)
dev.off()
# ou PDF vetorial: pdf("forest.pdf", width = 11, height = 6); forest(m, ...); dev.off()
```

---

## 3. O problema de diagramação ⭐

No layout **RevMan5**, a linha de heterogeneidade é impressa **na mesma faixa dos números do eixo X** — e, sendo larga, **invade o eixo**: `(P = 0.0644); I² = 63.5%` fica em cima de `0.1 … 1`. Fica ilegível.

### A correção (2 parâmetros)

| Parâmetro | O que faz |
|---|---|
| `addrows.below.overall = 2` | insere linhas em branco abaixo do pool → dá **linha própria** ao eixo |
| `xlab = ""` | remove o **título do eixo**, que disputava a linha da heterogeneidade |

```r
forest(m, layout = "RevMan5",
       print.I2 = TRUE, print.tau2 = TRUE, print.pval.Q = TRUE,
       addrows.below.overall = 2,   # <<< separa o eixo
       xlab = "",                   # <<< libera a linha do hetstat
       spacing = 1.3)
```
Veja antes/depois em `../figures/00_revman5_PROBLEMA.png` e `../figures/01_revman5_CORRIGIDO.png`, gerados por `../R/render_styles.R`.

### Pegadinhas (coisas que NÃO funcionam)
- `addrow.below.overall` (sem o **"s"**) → **ignorado em silêncio**. O certo é `addrows.below.overall`.
- `xlab.pos = NA` → não ajuda aqui.
- `print.Q = FALSE` → **ignorado** no layout RevMan5 (o pacote força o Q e dá warning).
- Quando estiver perdida nos parâmetros: `names(formals(meta:::forest.meta))` lista **todos** os argumentos válidos da sua versão.

---

## 4. Ligar/desligar e ajustar elementos

```r
forest(m,
  print.I2 = TRUE, print.tau2 = TRUE, print.pval.Q = TRUE,  # heterogeneidade
  prediction = TRUE,                                         # intervalo de predição
  leftcols  = c("studlab","event.e","n.e","event.c","n.c"), # colunas à esquerda
  rightcols = c("effect","ci"),                             # colunas à direita
  label.e = "Estradiol", label.c = "ADT",                  # nomes dos braços
  col.square = "black", col.diamond = "black",             # cores
  fontsize = 10, spacing = 1.3)
```

---

## 5. Iterar olhando a imagem

O ajuste fino de espaçamento é **imprevisível** — não confie só no parâmetro. O método que funcionou: **renderiza → abre o PNG → ajusta → repete**. Foi assim que cheguei no `addrows.below.overall=2 + xlab=""`.

---

### TL;DR
`png(res=300)` pra exportar · escala log no eixo · o overlap I²/τ²/p×eixo se resolve com **`addrows.below.overall=2` + `xlab=""`** · cuidado com `addrow` sem "s" · renderize e **olhe a imagem** pra afinar.
