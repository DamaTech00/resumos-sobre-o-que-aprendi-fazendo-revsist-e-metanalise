# ============================================================
# render_styles.R — o MESMO dado de meta-análise em vários estilos
#   + demonstração do fix de espaçamento (I²/τ²/p colados no eixo)
# Requisitos: R + pacote 'meta' (>= 7.0). Roda standalone.
#   install.packages("meta")
#   Rscript R/render_styles.R
# ============================================================
suppressMessages(library(meta))

OUT <- "figures"; dir.create(OUT, showWarnings = FALSE)
d <- read.csv("data/cv_mortality_example.csv", stringsAsFactors = FALSE)

# modelo: random-effects (REML) com ajuste Hartung-Knapp; RR via inverse-variance
m <- metabin(event.e, n.e, event.c, n.c, studlab = study, data = d, sm = "RR",
             method = "Inverse", random = TRUE, common = FALSE,
             method.tau = "REML", method.random.ci = "HK", prediction = TRUE)

rc <- c("studlab", "event.e", "n.e", "event.c", "n.c")
rl <- c("Study", "Events", "Total", "Events", "Total")

png_open <- function(f, h = 1900) png(file.path(OUT, f), width = 3400, height = h, res = 300)

# ── 00 — O PROBLEMA: RevMan5 padrão → I²/τ²/p sobrepõem os números do eixo X ──
png_open("00_revman5_PROBLEMA.png")
forest(m, layout = "RevMan5", common = FALSE, random = TRUE, prediction = TRUE,
       leftcols = rc, leftlabs = rl, rightcols = c("effect", "ci"),
       rightlabs = c("RR", "95% CI"), label.e = "Estradiol", label.c = "ADT",
       smlab = "", xlab = "Risk Ratio (CV mortality)", fontsize = 10,
       col.square = "black", col.diamond = "black", col.study = "black",
       print.I2 = TRUE, print.tau2 = TRUE, print.pval.Q = TRUE)   # SEM espaçamento extra
dev.off()

# ── 01 — O FIX: addrows.below.overall separa o eixo; xlab="" libera a linha do hetstat ──
png_open("01_revman5_CORRIGIDO.png")
forest(m, layout = "RevMan5", common = FALSE, random = TRUE, prediction = TRUE,
       leftcols = rc, leftlabs = rl, rightcols = c("effect", "ci"),
       rightlabs = c("RR", "95% CI"), label.e = "Estradiol", label.c = "ADT",
       smlab = "", xlab = "", fontsize = 10, spacing = 1.3,
       col.square = "black", col.diamond = "black", col.study = "black",
       print.I2 = TRUE, print.tau2 = TRUE, print.pval.Q = TRUE,
       addrows.below.overall = 2)                                  # <<< o fix
dev.off()

# ── 02 — Estilo JAMA (layout nativo; convenção JAMA não exibe prediction interval) ──
png_open("02_estilo_JAMA.png")
forest(m, layout = "JAMA", common = FALSE, random = TRUE, prediction = FALSE,
       label.e = "Estradiol", label.c = "ADT", fontsize = 10,
       col.square = "black", col.diamond = "black", col.study = "black")
dev.off()

# ── 03 — Estilo "meta" clássico (default do pacote) ──
png_open("03_estilo_meta_classico.png")
forest(m, layout = "meta", common = FALSE, random = TRUE, prediction = TRUE,
       leftcols = rc, leftlabs = rl, label.e = "Estradiol", label.c = "ADT",
       fontsize = 10, col.square = "black", col.diamond = "black", col.study = "black",
       addrows.below.overall = 2, xlab = "")
dev.off()

cat("OK — figuras em", OUT, "\n")
cat("Pooled RR =", round(exp(m$TE.random), 3),
    "(", round(exp(m$lower.random), 2), "-", round(exp(m$upper.random), 2), ")",
    "| I2 =", round(m$I2 * 100, 1), "%\n")
