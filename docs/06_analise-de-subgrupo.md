# Análise de subgrupo (explicada com alegorias)

Resumo acessível de **o que é**, **quando faz sentido** e **as armadilhas** da análise de subgrupo numa meta-análise.

---

## A ideia, com uma alegoria 🎂

Imagine que você testou a **mesma receita de bolo** em 10 cozinhas e mediu se o bolo cresceu. No geral, "meio que cresce". Mas você desconfia: e se o **tipo de forno** (gás vs elétrico) mudar o resultado?

Então você **separa** os bolos em dois grupos — feitos em forno a gás × elétrico — e olha cada grupo. Se os de gás sempre crescem e os elétricos sempre murcham, o **forno é um modificador de efeito**: a receita não é o problema, é a condição em volta.

> **Análise de subgrupo = separar os estudos por uma característica e perguntar: "o efeito muda entre os grupos?"**

No tE2 foi exatamente isso: separar por **estágio** (M0 vs M1) e por **via** (transdérmico vs intramuscular). O "bolo que murcha" foi a mortalidade CV — que só aparecia no PEP **intramuscular** em doença **M0** (FinnProstate). A via/estágio era o "forno".

---

## A pergunta que importa: a diferença é real ou acaso?

Não basta ver "no grupo A deu 0,8 e no B deu 1,2". Dois grupos quase **sempre** dão números diferentes só por acaso. O que vale é o **teste de interação** (ou teste de diferença entre subgrupos, `Q_between`):

> Ele pergunta: a diferença **entre** os subgrupos é maior do que a variação que já existe **dentro** de cada um?

Sai um **p de interação**. p alto = a diferença pode ser sorte. p baixo = há sinal de que o subgrupo realmente muda o efeito.

```r
# meta: subgrupo + teste de interação automático
metabin(..., subgroup = via)        # "via" = transdermal/IM
# o output traz "Test for subgroup differences" com o p
```

---

## As armadilhas (onde a gente se enrola) ⚠️

### 1. Decidir DEPOIS de ver os dados = trapaça
Se você testa 8 jeitos de fatiar e só conta o que deu significativo, é **torturar os dados até confessarem**. Subgrupo tem que ser **pré-especificado** (decidido no protocolo, com hipótese). Se foi depois, rotule como **post-hoc / exploratório** — honesto.

### 2. Poucos estudos por gaveta
Separar 3 estudos em 2 grupos pode deixar **1 estudo por subgrupo**. Aí não é meta-análise de subgrupo, é "olhar um estudo só". Quanto mais gavetas, menos robustez.

### 3. A pegadinha da confusão (a mais traiçoeira) 🕳️
Os estudos **não foram sorteados** entre os subgrupos. O grupo "intramuscular" pode também ser, por acaso, o dos **pacientes mais velhos e mais doentes do coração**. Aí você credita à *via* o que era da *idade*.

> **Alegoria:** comparar a saúde de dois bairros pela **média da cidade inteira** — você pode atribuir ao bairro o que na verdade é diferença de idade da população. Isso se chama **falácia ecológica / viés de agregação**: o que vale entre estudos não vale necessariamente dentro deles.

No tE2 isso foi explícito: a turma do PEP tinha **mais doença cardiovascular de base** (Hedlund 2002: 78 vs 66). Então o "sinal da via" pode ser, em parte, **confusão por risco basal** — e isso vira **limitação declarada**, não conclusão causal.

---

## Como usar bem (checklist)

- [ ] Subgrupo **pré-especificado** com hipótese (ou rotulado post-hoc).
- [ ] **Poucos** subgrupos, com estudos suficientes em cada.
- [ ] Reportar o **teste de interação** (p), não só os números separados.
- [ ] Lembrar que subgrupo é **observacional entre estudos** → gera hipótese, raramente prova causa.
- [ ] Heterogeneidade alta? O subgrupo pode **explicá-la** (foi o caso do FinnProstate) — aí ele é investigação, não enfeite.

---

### TL;DR
Separar estudos por uma característica e ver se o efeito muda · vale o **teste de interação**, não os números soltos · **pré-especifique** · cuidado com **confusão entre estudos** (falácia ecológica) · subgrupo **levanta hipótese**, raramente prova.
