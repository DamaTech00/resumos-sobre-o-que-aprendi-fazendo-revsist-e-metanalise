# Meta-análise frequentista vs bayesiana (e a "soma" que está por baixo das duas)

Resumo acessível: a diferença entre as duas escolas, e a intuição que une as duas — **combinar estimativas é somar precisão (informação)**, que é a versão honesta da ideia de "soma de vetores".

---

## 1. A base comum: precisão se soma 🧲

Antes de escolher lado, a mecânica que as duas compartilham.

Cada estudo te dá uma estimativa (um "puxão" numa direção) e uma **precisão** = quão confiante ele é = `1/variância` (= `1/SE²`). Estudo grande e preciso → puxão **firme**; estudo pequeno → puxão **frouxo**.

> **Alegoria das molas / cabo de guerra:** cada estudo é uma mola presa num ponto (sua estimativa) com uma rigidez (sua precisão). O resultado combinado é onde o sistema **fica em equilíbrio** — mais perto das molas firmes. E aqui está o pulo do gato: **as rigidezes (precisões) se somam**, como molas em paralelo.

Em fórmula (efeito fixo):
```
peso do estudo i:   w_i = 1 / var_i           (= precisão)

efeito combinado:   θ = Σ(w_i · θ_i) / Σ(w_i)   ← média PONDERADA pela precisão
precisão combinada: 1/var(θ) = Σ w_i           ← as precisões SOMAM
```

É essa a "soma de vetores" que você intuiu: o que **soma** de verdade é a **precisão/informação** (o denominador); a estimativa em si é uma **média ponderada** (não uma soma). Combinar dois estudos te deixa mais preciso que qualquer um sozinho — porque a informação acumula.

*(No modelo **aleatório**, cada peso vira `w_i = 1/(var_i + τ²)`: a heterogeneidade τ² "amolece" todas as molas, aproximando os pesos e alargando o IC.)*

---

## 2. Frequentista vs bayesiana — a diferença de filosofia

| | **Frequentista** | **Bayesiana** |
|---|---|---|
| O que é "probabilidade" | frequência no longo prazo | **grau de crença** |
| Ponto de partida | só os dados | **prior** (crença prévia) + dados |
| Resultado | estimativa + IC + p-valor | **distribuição posterior** |
| Como lê o intervalo | "95% dos ICs assim conteriam o valor" (indireto) | "**95% de probabilidade** de o valor estar aqui" (o que a gente *quer* dizer) |
| τ² (heterogeneidade) | um número fixo a estimar | tem **distribuição** (com prior) |
| Frase típica | "HR 0,97 (IC 0,71–1,35), p=0,77" | "**87% de probabilidade** de o efeito ser benéfico" |

A meta-análise **frequentista** é o padrão das revistas e foi a do tE2. A **bayesiana** é um complemento poderoso — especialmente quando há **poucos estudos**.

---

## 3. Como a bayesiana calcula (traduzindo)

O caso clássico (normal–normal) é literalmente a "soma de precisão" do tópico 1, agora **prior + dados** em vez de **estudo + estudo**:

```
PRIOR    (sua crença antes):     θ ~ Normal(μ0, com precisão τ0)
DADOS    (o que o estudo diz):   y  com precisão τ_y = 1/SE²

POSTERIOR (crença depois):
   precisão_post = τ0 + τ_y                       ← soma as precisões
   média_post    = (τ0·μ0 + τ_y·y) / (τ0 + τ_y)   ← média ponderada pela precisão
```

Traduzindo cada peça:
- **A precisão posterior é a soma** da precisão do prior com a dos dados → depois de ver o estudo, você está **mais certo** (mesma lógica das molas em paralelo).
- **A média posterior é um cabo de guerra** entre sua crença prévia e o dado novo, cada um puxando com força = sua precisão. Prior fraco (vago) → o dado domina. Prior forte → ele segura o resultado.
- Repetindo isso estudo a estudo (ou de uma vez), você tem a **meta-análise bayesiana**.

> É **a mesma máquina** do efeito fixo (tópico 1) — só que um dos "estudos" pode ser a sua crença prévia, e o resultado é uma **distribuição** inteira, não um ponto.

---

## 4. Quando a bayesiana ajuda de verdade

- **Poucos estudos (k pequeno):** um **prior fraco em τ²** estabiliza a estimativa de heterogeneidade — resolve com elegância o problema do `k=2` que no frequentista obriga gambiarra (Wald vs HKSJ — ver [03](03_metodos-de-IC-e-heterogeneidade.md)).
- **Incorporar evidência externa:** dá pra começar de um prior informado por estudos anteriores.
- **Falar probabilidade direta:** "92% de chance de NNT < 25" é mais útil pro clínico que "p=0,03".

**Custo honesto:** você escolhe o **prior**, e isso é subjetivo → sempre reporte **análise de sensibilidade a priors** (priors vago, cético, otimista). Sem isso, vira "escolhi o prior que dava o resultado que eu queria".

### Ferramentas em R
```r
install.packages("bayesmeta")   # meta-análise bayesiana pronta (normal-normal)
library(bayesmeta)
bm <- bayesmeta(y = TE, sigma = seTE, labels = study)
bm$summary        # média/mediana posterior, intervalo de credibilidade
# alternativas: brms (Stan, flexível), metaBMA (model averaging)
```

---

### TL;DR
A base das duas é **somar precisão** (informação acumula; estimativa = média ponderada pela precisão — a "soma de vetores"). Frequentista = só dados, IC/p, padrão das revistas. Bayesiana = prior + dados → posterior, fala **probabilidade direta** e brilha com **poucos estudos** — ao custo de escolher (e testar) o prior.
