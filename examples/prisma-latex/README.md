# PRISMA 2020 — fluxograma em LaTeX/TikZ

Template do diagrama de fluxo **PRISMA 2020** (identificação → triagem → elegibilidade → incluídos) feito em TikZ, com a paleta oficial (amarelo/azul). Os dados foram substituídos por `XX` — é um molde reutilizável.

> Não precisa do R nem de pacote nenhum: é LaTeX puro. O `PRISMA2020` (pacote R) é só *uma* alternativa; fazer em TikZ dá controle fino e fica ótimo pra impressão.

## Arquivo
- `prisma_flow_template.tex` — o template.

## Como compilar

**Opção A — Overleaf (mais fácil)**
1. overleaf.com → *New Project → Blank Project*.
2. Cole o conteúdo de `prisma_flow_template.tex`.
3. *Recompile* → *Download PDF*.

**Opção B — local**
```bash
pdflatex prisma_flow_template.tex      # gera o PDF
```
Precisa do TikZ (vem no TeX Live). Se faltar, no Ubuntu:
```bash
sudo apt install texlive-latex-extra texlive-pictures
```

## Como preencher
Substitua cada `XX` pelo número correspondente — há um comentário `% <-- ...` ao lado de cada um dizendo o que vai ali:

| Caixa | O que preencher |
|---|---|
| Databases | nº por base (PubMed, Cochrane, BVS/LILACS, Europe PMC) + subtotal |
| Registers/sources | ClinicalTrials.gov, citation searching |
| Total Records / Duplicates | total identificado e nº de duplicatas |
| Screened / Excluded | triados e excluídos na triagem (+ motivos) |
| Full-text assessed / excluded | textos completos avaliados e excluídos |
| Included | nº de ensaios (`k`), relatórios vinculados, randomizados, analisados |

Troque também `<Motivo 1/2>` e `<descreva o motivo>` pelos seus motivos de exclusão de texto completo.

## Ajustes úteis
- **Cores:** edite os `\definecolor` no preâmbulo (HTML).
- **Recorte só da figura:** depois de compilar, `pdfcrop prisma_flow_template.pdf` tira as margens; ou troque `\documentclass[12pt]{article}` por `\documentclass{standalone}` (e remova o ambiente `figure`) pra um bounding box justo.
- **Largura:** o `\resizebox{0.95\linewidth}{!}{...}` escala o diagrama; ajuste o `0.95` se quiser maior/menor.

## Bibliotecas TikZ usadas
`arrows.meta` (pontas de seta), `positioning` (posicionamento relativo `below/right of`), `calc` (coordenadas calculadas `($...$)`) — todas padrão no TeX Live.
