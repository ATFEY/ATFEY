# Folder Hasil Analisis

Folder ini berisi seluruh luaran (*output*) dari eksekusi skrip R `kmeans_ketahanan_pangan.R`, yang mencakup berkas rekapitulasi CSV dan visualisasi grafik beresolusi tinggi.

## 📊 Berkas Tabel (CSV)
- **`hasil_klaster_kabkota.csv`**: Daftar seluruh kabupaten/kota beserta penetapan label klasternya.
- **`profil_klaster.csv`**: Nilai rata-rata setiap indikator pada masing-masing klaster.
- **`evaluasi_jumlah_klaster.csv`**: Metrik evaluasi validitas klaster (Elbow, Silhouette, DBI, Calinski-Harabasz) untuk $K = 2$ hingga $K = 8$.
- **`klaster_per_provinsi.csv`**: Rekapitulasi sebaran jumlah klaster per provinsi di Indonesia.

## 📈 Berkas Visualisasi (PNG)
- **`grafik_elbow.png`**: Grafik metode Elbow (*Total Within-Cluster SS*).
- **`grafik_silhouette.png`**: Grafik rata-rata koefisien Silhouette.
- **`grafik_dbi.png`**: Grafik indeks Davies-Bouldin (DBI).
- **`grafik_klaster_pca.png`**: Pemetaan klaster berbasis *Principal Component Analysis* (PCA).
- **`grafik_boxplot_klaster.png`**: Visualisasi sebaran tiap indikator per klaster (*boxplot*).
