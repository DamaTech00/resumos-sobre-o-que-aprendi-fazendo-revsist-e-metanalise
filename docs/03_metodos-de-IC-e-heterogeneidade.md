# Intervalos de confiança e heterogeneidade: Wald, HKSJ e companhia

Resumo de **quando usar cada método** de IC e como pensar a heterogeneidade. Aterrado na regra que usei no tE2: **HKSJ para k≥3, Wald para k=2**.

---

## 1. Efeito fixo vs aleatório (a decisão de base)

| Modelo | Assume | Quando |
|---|---|---|
| **Fixo (common effect)** | todos os estudos estimam **o mesmo** efeito verdadeiro | estudos muito parecidos, heterogeneidade ~0 |
| **Aleatório (random effects)** | cada estudo estima um efeito de uma **distribuição** de efeitos | o caso real quase sempre — populações/doses/épocas diferentes |

No tE2 usei **aleatório** (ensaios de eras e formulações diferentes → heterogeneidade esperada). Reporta o aleatório como principal; o fixo entra como sensibilidade.

---

## 2. Estimar a variância entre estudos (τ²)

O modelo aleatório precisa estimar τ² (quanto os efeitos verdadeiros variam). Estimadores:

| Estimador | Nota |
|---|---|
| **REML** | recomendado como default; foi o que usei |
| **DerSimonian–Laird (DL)** | clássico, fácil, mas **subestima** τ² (IC estreito demais); bom como sensibilidade |
| **Paule–Mandel** | boa alternativa pra binários |

---

## 3. O IC do efeito combinado: Wald vs HKSJ ⭐

Estimar o efeito é uma coisa; pôr um **IC honesto** nele é outra. Aqui mora o aprendizado.

### Wald (normal, "classic")
Usa a normal (z = 1,96): `efeito ± 1,96 × SE`.
- ✅ simples.
- ❌ **anti-conservador com poucos estudos**: ignora a incerteza de ter *estimado* τ² → IC **estreito demais** → falsos positivos. Quanto menos estudos, pior.

### HKSJ (Hartung–Knapp–Sidik–Jonkman)
Usa a distribuição **t com k−1 graus de liberdade** + uma variância ajustada → IC **mais largo e mais honesto** quando k é pequeno. É o **default recomendado** pra efeitos aleatórios (IntHout 2014).

### A pegadinha do k=2 (por que a regra existe)
Com **k = 2**, o HKSJ tem **1 grau de liberdade** → o valor t dispara (≈12,7) → o IC **explode** e fica inutilizável (tipo "RR 2,3 (0,2–30)"). Por isso a regra pré-registrada:

> **HKSJ para k ≥ 3** (τ² > 0) · **Wald para k = 2** · HKSJ reportado como **sensibilidade**.

Não é escolher o que dá significância — é escolher o método estável pra cada k, **decidido antes**. No tE2: fogacho e ginecomastia (k=2) → Wald primário; OS e CV mortality (k=3) → HKSJ.

```r
# meta: controla o método do IC aleatório
metabin(..., method.random.ci = "HK")       # HKSJ  (k >= 3)
metabin(..., method.random.ci = "classic")  # Wald  (k = 2)
```

---

## 4. Prediction interval (intervalo de predição)

O IC fala da **média**; o PI fala de **onde cairia um estudo futuro**. Com heterogeneidade real, o PI é bem mais largo que o IC — e mais honesto sobre a incerteza clínica. Regra: reportar PI para **k ≥ 3** (precisa de τ² estimável).
```r
metabin(..., prediction = TRUE)
```

---

## 5. Medir heterogeneidade: I², τ², Q

| Métrica | O que é | Cuidado |
|---|---|---|
| **Q (Cochran)** | teste de heterogeneidade | subpotente com poucos estudos (p alto não = homogêneo) |
| **I²** | % da variância que é heterogeneidade (não acaso) | **depende de k e da precisão** — não tem corte sagrado; "I²=63%" com 3 estudos é instável |
| **τ²** | variância entre estudos, na **escala do efeito** | a mais interpretável pra construir o PI |

No tE2, a heterogeneidade da mortalidade CV (I²=63,5%) era **informativa**, não ruído: o *leave-one-out* mostrou que vinha do FinnProstate (PEP intramuscular em doença M0). Heterogeneidade alta é convite pra investigar subgrupo, não pra esconder.

---

## 6. Viés de publicação / small-study effects

- Funnel plot + teste de Egger: **só com ≥ 10 estudos** (recomendação Cochrane). Com menos, o teste é subpotente e enganoso.
- No tE2 (≤3 por desfecho) → **não fiz**, e **declarei isso** explicitamente. Declarar a ausência é parte do método.

---

## 7. Análises de sensibilidade (mostrar robustez)

Rode e reporte: trocar o estimador (REML ↔ DL), **leave-one-out**, excluir estudos de alto risco de viés, fixo vs aleatório, denominador alternativo. Se o resultado não muda → robusto. Se muda → você descobriu o que dirige o efeito (ouro pra Discussion).

---

### TL;DR
Aleatório + REML como base · **HKSJ k≥3, Wald k=2** (HKSJ explode com 1 gl) · PI pra k≥3 · I² interpretado com cautela (depende de k) · funnel só com ≥10 · decida tudo **antes** e declare desvios.
