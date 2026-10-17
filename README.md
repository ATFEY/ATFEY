# Regional Food Security & Vulnerability Clustering (FSVA)
*Klasterisasi Kerentanan dan Ketahanan Pangan Daerah (FSVA)*

---

## 🌐 Language / Bahasa
- [English](#english)
- [Bahasa Indonesia](#bahasa-indonesia)

---

<a name="english"></a>
## 🇬🇧 English

An applied data mining project implementing **K-Means Clustering** in **R** to analyze and categorize regional food security and vulnerability indicators across administrative districts in Indonesia.

### 📌 Project Overview
This repository contains a complete statistical pipeline for unsupervised classification of regional socio-economic and nutritional indicators. The project bridges applied mathematics, data mining, and public policy analysis by identifying distinct vulnerability profiles to support data-driven decision-making.

### ⚙️ Methodology & Pipeline
1. **Data Preprocessing & Validation:** Handling missing values, checking structural integrity, and variable transformation ($\log(1+x)$ for skewed variables).
2. **Standardization:** $Z$-score scaling to ensure uniform weighting across multi-scale indicators.
3. **Exploratory Data Analysis (EDA):** Statistical summary and correlation analysis (checking for multicollinearity).
4. **Optimal $K$ Evaluation:** Evaluating cluster validity using multiple metrics:
   - *Elbow Method* (Total Within-Cluster SS)
   - *Average Silhouette Coefficient*
   - *Davies-Bouldin Index* (DBI)
   - *Calinski-Harabasz Index*
5. **K-Means Modeling:** Execution with multi-start initializations (`nstart = 100`) and systematic cluster ordering based on the Food Expectation Score (PPH).
6. **Model Stability Testing:** Validating consistency using the **Adjusted Rand Index (ARI)** across multiple random initializations.
7. **Visualization & Export:** Principal Component Analysis (PCA) cluster mapping, comparative boxplots, and structured CSV exports.

### 📊 Variables Analyzed
- **NCPR**: Food consumption / availability indicator
- **ENERGI**: Energy consumption adequacy
- **MISKIN**: Poverty rate percentage
- **TNPAIR**: Infrastructure / accessibility indicator
- **RLSP**: Average years of schooling for women (age > 15 years)
- **STUNTING**: Malnutrition / stunting prevalence rate in children under five
- **PPH**: Food Expectation Score (*Pola Pangan Harapan*)

### 🛠️ Tech Stack & Libraries
- **Language:** R
- **Core Packages:** `tidyverse`, `cluster`, `factoextra`, `corrplot`, `ggplot2`

### 📄 Data Source
The dataset used in this project is sourced from the official public publication **Food Security and Vulnerability Atlas (FSVA) 2025**, published by the **National Food Agency (*Badan Pangan Nasional* / Bapanas) / Ministry of Agriculture of the Republic of Indonesia**.

### 🚀 Usage
1. Place your dataset (`FSVA_Data_Nasional_2025.xlsx`) in the working directory.
2. Run the R script sequentially to generate evaluation metrics, plots, and exported CSV summaries.

---

<a name="bahasa-indonesia"></a>
## 🇮🇩 Bahasa Indonesia

Proyek sains data terapan yang mengimplementasikan **K-Means Clustering** menggunakan bahasa pemrograman **R** untuk menganalisis dan mengelompokkan indikator ketahanan serta kerentanan pangan tingkat kabupaten/kota di Indonesia.

### 📌 Ringkasan Proyek
Repositori ini berisi alur kerja statistik lengkap (*statistical pipeline*) untuk klasifikasi tak terbimbing (*unsupervised classification*) pada indikator sosio-ekonomi dan gizi daerah. Proyek ini menghubungkan bidang matematika terapan, penambangan data (*data mining*), dan analisis kebijakan publik guna mengidentifikasi profil kerentanan wilayah sebagai dasar pengambilan keputusan berbasis data.

### ⚙️ Metodologi & Alur Kerja
1. **Pra-pemrosesan & Validasi Data:** Penanganan data kosong (*missing values*), pengecekan integritas struktur data, dan transformasi variabel ($\log(1+x)$ untuk variabel berdistribusi miring).
2. **Standardisasi:** Transformatif *Z-score scaling* untuk memastikan pembobotan yang seragam pada variabel dengan skala yang berbeda.
3. **Analisis Data Eksploratif (EDA):** Ringkasan statistik deskriptif dan analisis korelasi (uji multikolinearitas).
4. **Evaluasi $K$ Optimal:** Pengujian validitas klaster menggunakan beberapa metrik statistik:
   - *Elbow Method* (*Total Within-Cluster SS*)
   - *Average Silhouette Coefficient*
   - *Davies-Bouldin Index* (DBI)
   - *Calinski-Harabasz Index*
5. **Pemodelan K-Means:** Eksekusi algoritma dengan inisialisasi ulang acak (`nstart = 100`) dan pengurutan klaster secara sistematis berdasarkan nilai Pola Pangan Harapan (PPH).
6. **Uji Stabilitas Model:** Evaluasi konsistensi hasil pengelompokan menggunakan *Adjusted Rand Index* (ARI) melalui 20 kali inisialisasi acak.
7. **Visualisasi & Ekspor Data:** Pemetaan klaster berbasis *Principal Component Analysis* (PCA), *boxplot* komparatif, serta ekspor hasil analisis ke format CSV.

### 📊 Variabel yang Dianalisis
- **NCPR**: Indikator rasio konsumsi terhadap ketersediaan pangan netral.
- **ENERGI**: Tingkat kecukupan konsumsi energi penduduk.
- **MISKIN**: Persentase penduduk miskin.
- **TNPAIR**: Indikator aksesibilitas/infrastruktur air bersih dan sanitasi.
- **RLSP**: Rata-rata Lama Sekolah Perempuan usia > 15 tahun.
- **STUNTING**: Prevalensi *stunting* (tengkes) pada balita.
- **PPH**: Skor Pola Pangan Harapan (mutu dan keragaman konsumsi).

### 🛠️ Bahasa & Pustaka R
- **Bahasa Pemrograman:** R
- **Pustaka Utama:** `tidyverse`, `cluster`, `factoextra`, `corrplot`, `ggplot2`

### 📄 Sumber Data
Data yang digunakan dalam proyek ini bersumber dari publikasi data publik **Peta Ketahanan dan Kerentanan Pangan (Food Security and Vulnerability Atlas - FSVA) 2025** yang diterbitkan oleh **Badan Pangan Nasional (Bapanas) / Kementerian Pertanian Republik Indonesia**.

### 🚀 Petunjuk Penggunaan
1. Letakkan berkas data (`FSVA_Data_Nasional_2025.xlsx`) pada direktori kerja (*working directory*).
2. Jalankan skrip R secara berurutan untuk menghasilkan metrik evaluasi, grafik visualisasi, dan berkas ringkasan CSV.

---

## 📝 License / Lisensi
This project is open-source and available under the [MIT License](LICENSE).
