# Extração de dados sistemática e organizada

Resumo do que aprendi extraindo dados pra meta-análise: como deixar a extração **rastreável**, como organizar quando um ensaio tem **vários relatórios/fases**, e como estruturar a planilha pra alimentar o R sem dor.

---

## 1. Princípios (o que faz a extração ser "sistemática")

- **Formulário piloto:** decida ANTES quais variáveis vai extrair (mesma estrutura pra todo estudo). Evita "ah, esqueci de pegar a idade do braço X".
- **Dupla extração:** dois revisores extraem em paralelo e batem os números (consenso nas divergências). É exigência de revista boa.
- **Rastreabilidade (provenance):** pra cada número extraído, guarde **de onde veio** — tabela/figura/página + a **citação literal**. No tE2 isso virou uma coluna `source_quote` (ex.: `"HR 0.90 (0.75–1.07), NEJM 2026 Table 2"`). Quando a banca perguntar, você acha em segundos.
- **Defina os desfechos com precisão:** "fratura" = incidência cumulativa KM a 10 anos? evento bruto? grau? Escreva a definição e seja consistente.

---

## 2. O ponto difícil: um ensaio com VÁRIOS relatórios/fases

Esse foi o aprendizado central. Um mesmo ensaio costuma ter **várias publicações**: follow-up de 2 anos, depois 5, depois 10; análises secundárias; sub-desfechos. Se você tratar cada paper como um "estudo", **conta em dobro** e infla a amostra — erro grave.

### Conceito: *trial entity* (entidade analítica)
> Várias publicações do **mesmo** ensaio = **uma** entidade analítica.

No tE2: **12 relatórios → 3 entidades**:

| Entidade | Relatórios vinculados | Papel |
|---|---|---|
| PATCH/STAMPEDE | Langley 2008, 2016, 2021, 2026 (+) | 1 ensaio, 5 papers |
| SPCG-5 | Hedlund 2000, 2002, 2011 | 1 ensaio, 3 papers |
| FinnProstate | Mikkola 1998, 2005, 2007; Aro 1989, 1990 | 1 ensaio, 4 papers |

### Regra de ouro pra não contar em dobro
**Use o relatório mais completo POR DESFECHO.** Exemplos:
- Sobrevida global → pega do follow-up mais longo (o 10-anos, não o de 2).
- Fratura → do paper que reporta fratura (BMD/safety), mesmo que seja outro do mesmo ensaio.
- Mortalidade CV → do paper cardiovascular primário.

Ou seja: a **entidade** é uma só, mas cada **desfecho** pode vir de um relatório diferente dela. Documente isso (coluna "qual report alimentou qual desfecho").

### Como rastrear na planilha
Colunas que ajudam: `trial_entity` · `report_id` (qual paper) · `outcome` · `most_complete_for_outcome (sim/não)`. Assim dá pra auditar que nada foi duplicado.

---

## 3. Estrutura da planilha mestre (formato "tidy")

**Uma linha por (estudo × desfecho).** Não tente espremer tudo numa linha por estudo — o R odeia isso.

Para desfechos **binários** (contagem):
```
study, outcome, event.e, n.e, event.c, n.c, stage, route, source_quote
PATCH, cv_mortality, 11, 904, 15, 790, "M0+M1", transdermal, "Langley 2021..."
SPCG-5, cv_mortality, 16, 458, 14, 457, "M1", IM, "Hedlund 2000 Table III"
```

Para desfechos **tempo-até-evento** (HR) ou já calculados, use o formato genérico:
```
study, outcome, TE (log do efeito), seTE, ...   # alimenta metagen()
```
*(dá pra derivar `seTE` do IC: `seTE = (log(hi) - log(lo)) / (2*1.96)`).*

**Data dictionary:** um arquivo à parte explicando cada coluna e cada código de desfecho. Salva você daqui a 3 meses.

---

## 4. Fluxo de ferramentas (o que usei, em ordem)

```
Zotero  →  Rayyan  →  Obsidian  →  R / RStudio
(dedup)   (triagem)  (extração)    (análise)
```
- **Zotero** — importa todas as bases e **deduplica**.
- **Rayyan** — triagem por título/resumo, **dois revisores**, com tags de motivo de exclusão (PRISMA).
- **Obsidian** — uma **nota estruturada por artigo** (desfechos extraídos + citação-fonte) + uma nota-planilha que agrega. Bom pra TDAH: cada artigo é uma página, tudo linkado.
- **R/RStudio** — lê a planilha mestre (CSV) e roda a meta-análise.

> Triagem foi **100% manual** (sem IA). Se usar IA em qualquer etapa, **declare** no manuscrito.

### Triagem assistida por IA — ASReview (alternativa que NÃO usei aqui)

No tE2 a triagem foi manual no Rayyan. Mas vale conhecer o **[ASReview LAB](https://asreview.ai)** — ferramenta open-source (Python, da Universidade de Utrecht) pra **acelerar a triagem** de título/resumo por *active learning*. Como funciona:

1. Você exporta os registros (RIS/CSV — ex.: do Zotero) e abre no ASReview.
2. Rotula alguns como **relevante / irrelevante**.
3. Um modelo de ML (ex.: Naive Bayes/SVM + TF-IDF) aprende com seus rótulos e **reordena** a fila, jogando os mais prováveis-relevantes pra frente.
4. Você continua rotulando os do topo; conforme só aparece irrelevante, você **para** — sem precisar ler os milhares restantes um a um.

**O que ele é e o que não é:**
- ✅ **prioriza** a ordem da triagem (você lê os prováveis-relevantes primeiro) → economiza muito tempo em buscas grandes (milhares de hits).
- ❌ **não decide sozinho** — o humano rotula; é *human-in-the-loop*. Não dispensa o julgamento nem (necessariamente) a dupla triagem.
- ⚠️ **declare** se usar: é triagem **assistida por IA**, e isso entra nos Methods / Use of AI. O ASReview gera um log do processo pra transparência.

```bash
pip install asreview        # requer Python
asreview lab                # abre a interface web; importe seu RIS/CSV
```

> Para uma revisão com **poucos registros** (como o tE2, ~430 → 342 triados), o Rayyan manual dá conta tranquilo. O ASReview brilha quando a busca traz **milhares** de registros e ler tudo manualmente seria inviável.

---

## 5. Detalhes que salvam (efeito-modificador, post-hoc)

- **Efeito-modificador a priori:** se algo distorce o desfecho, defina ANTES como lidar. Ex.: irradiação mamária profilática suprime ginecomastia → a análise **primária** usou o subgrupo **não-irradiado**, e o ITT virou **sensibilidade**. Decidir isso depois de ver os dados é *cherry-picking*; decidir antes (com justificativa) é método.
- **Marque o que é post-hoc:** desfecho não pré-registrado (ex.: ginecomastia) deve ser rotulado como **post-hoc / exploratório**. Honestidade > parecer perfeito.
- **Declare desvios do protocolo:** seção "Differences between protocol and review" (PRISMA item 24). Voltar ao plano registrado não é desvio — é aderência.

---

### TL;DR
Uma entidade por ensaio (não por paper) · relatório mais completo por desfecho · uma linha por estudo×desfecho · guarde a citação-fonte de cada número · defina efeito-modificadores e post-hoc ANTES.
