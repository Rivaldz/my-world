# 🗺️ Research Roadmap — SaaS Kalkulator Keputusan Peternakan/Perikanan

> **Dibuat:** 20 Agustus 2026  
> **Status:** Pre-validation / Idea Stage  
> **Tujuan dokumen ini:** Bahan bacaan & checklist sebelum mulai bangun apapun.

---

## 📌 Inti Ide (Sudah Disepakati)

**Produk:** Website / PWA (Progressive Web App) berbasis cloud — bukan hardware bundle, bukan native app dulu.

**Cara kerjanya:**
```
User input parameter harian
(pH, suhu, jumlah pakan, biomassa, dll.)
        ↓
Algoritma DSS di backend
        ↓
Output berupa KEPUTUSAN, bukan angka mentah
("Tambahkan 50g molase sekarang", "Panen optimal di hari ke-87")
```

**Kenapa bukan STB/local server:**
- Internet di Jawa sudah bukan bloker (4G penetrasi >85%)
- Hardware bundle = margin tipis, support nightmare, SKU kompleks
- App berbasis cloud = update algoritma real-time, data aggregation, GTM lebih mudah

**Kenapa Website/PWA dulu, bukan native app:**
- Distribusi instan — share link di WA/Telegram grup, langsung bisa dicoba tanpa install
- Iterasi cepat — deploy → langsung live, tidak perlu user update manual
- Zero Play Store friction — tidak perlu review process, tidak ada "install dulu" barrier
- Bisa di-install ke home screen (PWA) jika user mau — best of both worlds
- Native app hanya dibangun jika ada demand organik dari user yang sudah exist

**Competitive moat jangka panjang:**
Bukan algoritmanya — tapi **dataset terkumulasi** dari ribuan siklus panen real user.

---

## 🎯 Target Pasar (Hipotesis, Belum Divalidasi)

**Primary:** Peternak ikan nila sistem bioflok skala rumahan/semi-komersial di Jawa  
**Secondary (perlu dikaji ulang):** Peternak ayam petelur skala 100–1000 ekor  
**Potensial tapi belum dieksplor:** B2B medium-scale (nila/lele 1–5 ha) — WTP lebih tinggi, segmen ini *tidak* dikuasai eFishery/JALA

---

## 🔬 BAGIAN 1: Yang Perlu Dianalisa Lebih Dalam

### 1.1 Validasi TAM (Total Addressable Market)

- [ ] Berapa jumlah aktif peternak nila bioflok skala rumahan di Indonesia? (hint: cari data KKP, BPS sektor perikanan budidaya air tawar)
- [ ] Berapa yang ada di Jawa vs. luar Jawa?
- [ ] Berapa persentase yang "data-driven" / melek teknologi vs. yang masih empiris?
- [ ] Apakah komunitas FB/Telegram bioflok bisa jadi proxy TAM? Cek grup-grup ini:
  - "Bioflok Indonesia" (Facebook)
  - Grup-grup budidaya nila di Telegram
  - Hitung anggota aktif, frekuensi post, topik yang dibahas

### 1.2 Validasi Willingness to Pay (WTP)

> ⚠️ Ini adalah hal paling kritis yang harus divalidasi sebelum nulis 1 baris kode.

- [ ] Benchmark harga produk kompetitor:
  - Aplikasi pertanian/perikanan yang sudah exist di Play Store Indonesia (Pak Tani, iGrow, dll.)
  - Berapa yang berbayar? Berapa yang freemium?
- [ ] User interview target: **minimal 20 orang** peternak aktif
  - Pertanyaan kunci: *"Berapa yang kamu mau bayar per bulan untuk aplikasi yang bisa bilang 'tambahkan ini sekarang' secara otomatis?"*
  - Jangan sebutkan angka duluan — biarkan mereka yang menyebut
- [ ] Uji dengan Google Sheets Calculator dulu (MVP zero-cost):
  - Buat spreadsheet kalkulasi C/N ratio, amonia, FCR otomatis
  - Sebar gratis ke komunitas
  - Ukur: berapa yang pakai? Berapa yang share? Berapa yang tanya "ini bisa beli ga?"

### 1.3 Validasi Akurasi Algoritma di Lapangan

> ⚠️ Ini risiko teknis terbesar yang sering dilewatkan.

- [ ] Parameter teoritis bioflok (C/N ratio ideal, dsb.) valid di kondisi lab — seberapa akurat di kondisi nyata?
  - Variasi kualitas air sumur vs. PDAM
  - Variasi kualitas molase lokal
  - Variasi suhu antar wilayah
- [ ] Apakah ada studi/paper akademik lokal yang memvalidasi parameter ini di konteks Indonesia?
  - Cari di: Google Scholar, Jurnal Akuakultur Indonesia, repository LIPI/BRIN
- [ ] Interview dengan peternak berpengalaman / pakar bioflok untuk kalibrasi parameter

---

## 🏗️ BAGIAN 2: Yang Perlu Disiapkan

### 2.1 MVP Zero-Cost (Sebelum Nulis Kode)

- [ ] **Google Sheets Calculator** — ini harus dibuat **minggu ini**:
  - Input: jumlah ikan, berat rata-rata, kadar amonia target, C/N ratio saat ini
  - Output: jumlah molase yang perlu ditambahkan, estimasi jadwal panen
  - Desain sesederhana mungkin, tidak perlu cantik
- [ ] Distribusi ke komunitas: join 3–5 grup FB/Telegram peternak bioflok aktif
- [ ] Buat Google Form kecil untuk collect feedback & email/WA mereka yang tertarik

### 2.2 Definisi Produk (Perlu Dikerjakan Sebelum Development)

- [ ] **Pilih 1 komoditas dulu** — jangan nila DAN ayam sekaligus. Rekomendasi: mulai dari **nila bioflok** (komunitas lebih aktif secara online, parameter lebih terstandar)
- [ ] Buat daftar parameter input yang realistis bisa diukur peternak rumahan:
  - Yang punya alat ukur: pH meter, DO meter, termometer
  - Yang tidak punya: estimasi visual, tabel referensi
- [ ] Definisikan output/keputusan apa saja yang bisa dihasilkan sistem:
  - Dosis molase/probiotik harian
  - Estimasi jadwal panen
  - Alert peringatan (amonia terlalu tinggi, FCR tidak normal)
  - Estimasi kebutuhan pakan sisa siklus

### 2.3 Tech Stack Decision (Sudah Diputuskan: Website / PWA dulu)

**Frontend / PWA:**
- [ ] Pilih framework:
  - **Next.js (React)** → paling populer, ekosistem besar, SSR-friendly, mudah deploy ke Vercel
  - **Nuxt.js (Vue)** → jika tim lebih familiar dengan Vue
  - **SvelteKit** → lebih ringan, performa bagus di mobile browser
  - Rekomendasi default: **Next.js** — komunitas & dokumentasi paling lengkap
- [ ] PWA setup: tambahkan `manifest.json` + Service Worker agar bisa di-install ke home screen
- [ ] Desain mobile-first — mayoritas user akses dari HP, bukan desktop

**Backend / API:**
- [ ] Pilih antara:
  - **Python (FastAPI)** → cocok jika algoritma DSS nanti berkembang ke ML/statistical model
  - **Node.js (Express/Hono)** → lebih ringan untuk API sederhana, 1 bahasa dengan frontend jika pakai JS
  - Rekomendasi: **FastAPI** jika ada potensi ke arah algoritma kompleks, **Hono/Express** jika ingin simpel dulu
- [ ] **Database:** PostgreSQL sebagai default — cukup untuk early stage, bisa tambahkan TimescaleDB extension nanti jika butuh time-series yang lebih optimal
- [ ] **Hosting awal (gratis/murah):**
  - Frontend: **Vercel** (gratis, deploy otomatis dari GitHub)
  - Backend: **Railway** atau **Render** (ada free tier, cukup untuk MVP)
  - Database: **Supabase** (PostgreSQL managed, free tier ada)

**Urutan implementasi yang disarankan:**
```
1. Halaman kalkulator statis (no backend, pure JS) → validasi UI/UX
2. Tambahkan backend API untuk algoritma DSS
3. Tambahkan auth + simpan histori log user
4. PWA manifest + service worker
5. Native app → hanya jika ada demand
```

---

## 🔍 BAGIAN 3: Yang Perlu Dicari Tahu Lebih Jauh

### 3.1 Kompetitor — Mapping Lengkap

> Dokumen lama hanya menyebut eFishery & JALA. Ada lebih banyak.

- [ ] **Cari di Play Store:** keyword "budidaya ikan", "bioflok", "peternakan ayam", "FCR calculator"
- [ ] **Cari di Product Hunt / Indie Hackers:** ada nggak produk serupa di global yang bisa dijadikan referensi UI/UX?
- [ ] **Kompetitor tidak langsung:** Excel/Sheets template yang sudah beredar di komunitas
- [ ] Untuk setiap kompetitor, catat:
  - Rating & jumlah download
  - Harga (gratis/berbayar/freemium)
  - Review negatif terbanyak → itu celah kamu

### 3.2 Regulasi & Legalitas

- [ ] Apakah ada regulasi KKP atau Kementan terkait aplikasi panduan budidaya?
- [ ] **Legal liability DSS** — ini krusial:
  - Jika rekomendasi salah dan peternak rugi, apa implikasi hukumnya?
  - Pelajari bagaimana produk sejenis (kalkulator gizi, kalkulator obat) menangani ini di Terms of Service mereka
  - Konsultasi singkat dengan konsultan hukum IT/startup (bisa lewat komunitas seperti Hukumonline, atau startup law firm)
- [ ] Apakah perlu izin khusus untuk aplikasi yang berkaitan dengan rekomendasi budidaya pangan?

### 3.3 Model Bisnis — Yang Perlu Dikaji

- [ ] **Freemium vs. One-time purchase vs. Subscription:**
  - Freemium: fitur dasar gratis, fitur lanjutan berbayar (tapi konversi di Indonesia historis rendah)
  - One-time purchase: Rp 50.000–150.000 permanen (lebih sesuai psikologi user Indonesia?)
  - Subscription: Rp 15.000–30.000/bulan (perlu nilai yang sangat jelas per bulan)
- [ ] **Micro-affiliate peluangnya seberapa besar?**
  - Cari supplier pakan/probiotik/vitamin ikan yang punya program afiliasi
  - Target: Charoen Pokphand, Japfa, atau supplier lokal yang lebih kecil
  - Berapa komisi yang realistis per transaksi?
- [ ] **B2B angle:** Apakah toko pakan ikan/poultry shop bisa jadi reseller atau channel distribusi?

### 3.4 Komunitas & GTM Channel

- [ ] Mapping grup aktif:
  | Platform | Nama Grup | Anggota | Tingkat Aktivitas |
  |---|---|---|---|
  | Facebook | Bioflok Indonesia | ? | ? |
  | Telegram | ? | ? | ? |
  | YouTube | Channel budidaya populer | ? | ? |
  | TikTok | Konten bioflok rumahan | ? | ? |

- [ ] Siapa **influencer/KOL** di komunitas ini? (bukan seleb, tapi peternak yang sering sharing hasil nyata)
- [ ] Apakah ada event/pameran perikanan/peternakan yang bisa jadi touchpoint? (AquaFarm, Indoaqua, dll.)

---

## 📊 BAGIAN 4: Metrics Validasi — Kapan Kita Tahu Ini Layak Dibangun?

Sebelum mulai development serius, pastikan minimal **3 dari 4** kondisi ini terpenuhi:

| # | Kondisi | Target | Status |
|---|---|---|---|
| 1 | Google Sheets calculator dipakai aktif | > 50 user dalam 30 hari | ❌ Belum |
| 2 | User interview menunjukkan WTP > Rp 20.000/bulan | ≥ 15 dari 20 responden | ❌ Belum |
| 3 | Ada waiting list atau pre-order | ≥ 30 orang | ❌ Belum |
| 4 | Algoritma divalidasi oleh minimal 2 pakar budidaya | Expert review | ❌ Belum |

---

## 🗓️ Urutan Kerja yang Disarankan

```
MINGGU 1–2
  └─ Buat Google Sheets Calculator (nila bioflok)
  └─ Join komunitas FB/Telegram, mulai observasi
  └─ Mapping kompetitor di web & Play Store

BULAN 1
  └─ Sebar Sheets Calculator ke komunitas
  └─ Lakukan 20 user interview
  └─ Mapping KOL & channel GTM
  └─ Cari referensi paper/studi parameter bioflok Indonesia

BULAN 2
  └─ Evaluasi hasil validasi (gunakan metrics di atas)
  └─ Jika valid → mulai wireframe & definisi fitur MVP
  └─ Pilih tech stack (Next.js / FastAPI / Supabase)
  └─ Jika tidak valid → pivot atau stop

BULAN 3–4 (jika lanjut)
  └─ Development MVP: Website/PWA kalkulator sederhana
  └─ Prioritas: kalkulator bisa diakses dari HP, mobile-first design
  └─ Beta test dengan early adopter dari komunitas
  └─ Iterasi berdasarkan feedback nyata

BULAN 5+ (jika ada traction)
  └─ Tambahkan fitur histori & tracking log
  └─ PWA install prompt (manifest + service worker)
  └─ Eksplor monetisasi (freemium / one-time / affiliate)
  └─ Native app → hanya jika user secara aktif memintanya
```

---

## 📝 Open Questions (Belum Ada Jawaban)

1. Komoditas mana yang jadi **fokus pertama** — nila bioflok atau ayam petelur?
2. Apakah tim punya background domain knowledge perikanan/peternakan, atau perlu cari co-founder/advisor dari industri?
3. Apakah ada budget untuk user research (interview, prototype testing)?
4. Apa timeline target untuk bisa ada revenue pertama?

---

> **Next step paling konkret:** Buka Google Sheets, buat kalkulator C/N ratio sederhana, sebar ke 1 grup bioflok. Itu saja dulu.
