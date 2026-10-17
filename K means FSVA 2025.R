library("readxl")
library("dplyr")
library("tidyr")
library("ggplot2")
library("cluster")
library("corrplot")
library("factoextra")

# 1. PENGATURAN --------------------------------------------------------------
FILE_DATA <- "FSVA_Data_Nasional_2025.xlsx"
VARIABEL  <- c("NCPR", "ENERGI", "MISKIN", "TNPAIR", "RLSP", "STUNTING", "PPH")
LOG_NCPR  <- FALSE  
K_MIN     <- 2
K_MAX     <- 8
K_FINAL   <- NA       
SEED      <- 123

# 2. MEMBACA DATA ------------------------------------------------------------
raw <- read_excel(FILE_DATA)

kolom_perlu <- c("KDPKAB", "WADMPR", "WADMKK", VARIABEL)
stopifnot(all(kolom_perlu %in% names(raw)))

data <- raw %>%
  select(all_of(kolom_perlu)) %>%
  mutate(across(all_of(VARIABEL), as.numeric))

cat("Jumlah kabupaten/kota :", nrow(data), "\n")
cat("Jumlah data kosong    :", sum(is.na(data[VARIABEL])), "\n")
cat("Kode wilayah ganda    :", anyDuplicated(data$KDPKAB), "\n")
stopifnot(sum(is.na(data[VARIABEL])) == 0)

# 3. EKSPLORASI --------------------------------------------------------------
summary(data)
tabel1 <- data.frame(
  Variabel  = VARIABEL,
  Min       = sapply(data[VARIABEL], min),
  Rata_rata = sapply(data[VARIABEL], mean),
  Median    = sapply(data[VARIABEL], median),
  SD        = sapply(data[VARIABEL], sd),
  Maks      = sapply(data[VARIABEL], max)
)
print(tabel1, digits = 3)
korelasi <- cor(data[VARIABEL])
print(round(korelasi, 2))
diag_nol <- korelasi; diag(diag_nol) <- 0
cat("Korelasi absolut terbesar:", round(max(abs(diag_nol)), 2),
    "(waspadai multikolinearitas jika > 0.9)\n")
corrplot(korelasi, method = "color", type = "upper",
         addCoef.col = "black", number.cex = 0.7, tl.cex = 0.8)

# 4. PRAPEMROSESAN: STANDARISASI Z-SCORE ------------------------------------
X <- as.data.frame(data[VARIABEL])
if (LOG_NCPR) X$NCPR <- log1p(X$NCPR)
Z <- scale(X)                                   
rownames(Z) <- paste(data$WADMPR, data$WADMKK, sep = " - ")
jarak <- dist(Z)                               

# 5. MENENTUKAN JUMLAH KLASTER OPTIMAL ---------------------------------------
indeks_db <- function(Z, cl, pusat) {         
  k <- nrow(pusat)
  s <- sapply(seq_len(k), function(i) {
    mean(sqrt(rowSums(sweep(Z[cl == i, , drop = FALSE], 2, pusat[i, ])^2)))
  })
  m <- as.matrix(dist(pusat))
  mean(sapply(seq_len(k), function(i) max((s[i] + s[-i]) / m[i, -i])))
}

evaluasi <- bind_rows(lapply(K_MIN:K_MAX, function(k) {
  set.seed(SEED)
  m   <- kmeans(Z, centers = k, nstart = 50, iter.max = 100)
  sil <- mean(silhouette(m$cluster, jarak)[, "sil_width"])
  data.frame(
    k                 = k,
    inertia           = m$tot.withinss,
    silhouette        = sil,
    davies_bouldin    = indeks_db(Z, m$cluster, m$centers),
    calinski_harabasz = (m$betweenss / (k - 1)) / (m$tot.withinss / (nrow(Z) - k)),
    klaster_terkecil  = min(m$size)
  )
}))
print(round(evaluasi, 3))

p_elbow <- ggplot(evaluasi, aes(k, inertia)) +
  geom_line() + geom_point(size = 2) + scale_x_continuous(breaks = K_MIN:K_MAX) +
  labs(title = "Metode Elbow", x = "Jumlah klaster (k)", y = "Total wilayah di dalam klaster") +
  theme_minimal()
p_sil <- ggplot(evaluasi, aes(k, silhouette)) +
  geom_line() + geom_point(size = 2) + scale_x_continuous(breaks = K_MIN:K_MAX) +
  labs(title = "Silhouette Coefficient", x = "Jumlah klaster (k)", y = "Rata-rata silhouette") +
  theme_minimal()
p_db <- ggplot(evaluasi, aes(k, davies_bouldin)) +
  geom_line() + geom_point(size = 2) + scale_x_continuous(breaks = K_MIN:K_MAX) +
  labs(title = "Davies-Bouldin Index", x = "Jumlah klaster (k)", y = "DBI") +
  theme_minimal()
print(p_elbow); print(p_sil); print(p_db)
ggsave("grafik_elbow.png", p_elbow, width = 6, height = 4, dpi = 300)
ggsave("grafik_silhouette.png", p_sil, width = 6, height = 4, dpi = 300)
ggsave("grafik_dbi.png", p_db, width = 6, height = 4, dpi = 300)

K_FINAL <- 3


# 6. MODEL K-MEANS FINAL -----------------------------------------------------
set.seed(SEED)
km <- kmeans(Z, centers = K_FINAL, nstart = 100, iter.max = 100)

urut <- order(tapply(data$PPH, km$cluster, mean), decreasing = TRUE)
peta <- setNames(seq_along(urut), urut)
data$Klaster <- factor(unname(peta[as.character(km$cluster)]),
                       levels = seq_len(K_FINAL),
                       labels = paste("Klaster", seq_len(K_FINAL)))

cat("\nUkuran klaster:\n"); print(table(data$Klaster))
cat("Silhouette rata-rata:",
    round(mean(silhouette(as.integer(data$Klaster), jarak)[, "sil_width"]), 3), "\n")

# 7. PROFIL KLASTER (satuan asli) --------------------------------------------
profil <- data %>%
  group_by(Klaster) %>%
  summarise(n = n(), across(all_of(VARIABEL), mean), .groups = "drop") %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))
print(profil, width = Inf)

# 8. UJI KESTABILAN (Adjusted Rand Index terhadap model final) ---------------
ari <- function(a, b) {
  tab <- table(a, b); n <- sum(tab)
  sc  <- function(x) sum(choose(x, 2))
  indeks <- sc(tab); ra <- sc(rowSums(tab)); rb <- sc(colSums(tab))
  harapan <- ra * rb / choose(n, 2)
  (indeks - harapan) / (0.5 * (ra + rb) - harapan)
}
stabilitas <- sapply(1:20, function(s) {
  set.seed(1000 + s)
  m <- kmeans(Z, centers = K_FINAL, nstart = 10, iter.max = 100)
  ari(as.integer(data$Klaster), m$cluster)
})
cat("\nARI 20 inisialisasi acak: rata-rata =", round(mean(stabilitas), 3),
    ", minimum =", round(min(stabilitas), 3), "\n")

# 9. RINGKASAN PER PROVINSI --------------------------------------------------
per_provinsi <- data %>%
  count(WADMPR, Klaster) %>%
  pivot_wider(names_from = Klaster, values_from = n, values_fill = 0) %>%
  arrange(WADMPR)
print(per_provinsi, n = Inf)

# 10. VISUALISASI ------------------------------------------------------------
p_pca <- fviz_cluster(list(data = Z, cluster = as.integer(data$Klaster)),
                      geom = "point", ellipse.type = "convex",
                      main = "Klaster pada ruang dua komponen utama (PCA)") +
  theme_minimal()
print(p_pca)
ggsave("grafik_klaster_pca.png", p_pca, width = 7, height = 5, dpi = 300)

panjang <- data %>%
  select(Klaster, all_of(VARIABEL)) %>%
  pivot_longer(-Klaster, names_to = "variabel", values_to = "nilai")
p_box <- ggplot(panjang, aes(Klaster, nilai, fill = Klaster)) +
  geom_boxplot(outlier.size = 0.8) +
  facet_wrap(~ variabel, scales = "free_y") +
  labs(title = "Sebaran variabel per klaster", x = NULL, y = NULL) +
  theme_minimal() + theme(legend.position = "none")
print(p_box)
ggsave("grafik_boxplot_klaster.png", p_box, width = 9, height = 6, dpi = 300)

# 11. EKSPOR -----------------------------------------------------------------
hasil <- data %>% select(KDPKAB, WADMPR, WADMKK, Klaster, all_of(VARIABEL))
write.csv(hasil,        "hasil_klaster_kabkota.csv",  row.names = FALSE)
write.csv(profil,       "profil_klaster.csv",         row.names = FALSE)
write.csv(evaluasi,     "evaluasi_jumlah_klaster.csv", row.names = FALSE)
write.csv(per_provinsi, "klaster_per_provinsi.csv",   row.names = FALSE)
cat("\nSelesai. File hasil tersimpan di:", getwd(), "\n")
