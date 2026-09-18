# Aplikasi Manajemen Stok Gudang (Flutter Android UI)

Aplikasi mobile berbasis **Flutter UI** yang sangat sederhana, bersih, dan mudah dipahami. Dibuat untuk memenuhi kriteria penugasan **Tugas 2 - Pemrograman Mobile**.

---

## 📂 Struktur Folder Proyek

Semua file dibuat sesederhana mungkin tanpa kode rumit:

```text
lib/
├── main.dart                   # Titik masuk aplikasi & Halaman Login (Kriteria 1)
├── beranda.dart                # Halaman Menu Utama / Dashboard Tombol Fitur
├── data_gudang.dart            # Data stok barang & data anggota kelompok
├── data_kelompok.dart          # Halaman Data Kelompok Mahasiswa (Kriteria 2)
├── penjumlahan_pengurangan.dart# Penjumlahan (+) & Pengurangan (-) Stok Gudang (Kriteria 3)
├── perkalian_pembagian.dart    # Perkalian Box & Pembagian Rak Gudang (Kriteria 4)
├── ganjil_genap.dart           # Cek Sifat Stok Ganjil / Genap (Kriteria 5)
└── total_angka.dart            # Hitung Total Angka dalam 1 Field Input (Kriteria 6)
```

---

## 🚀 Cara Menjalankan di Android Studio

1. Buka **Android Studio**.
2. Pilih menu **File** > **Open**, lalu arahkan ke folder:
   `D:\Kuliah\Mobile\Tugas2\aplikasi_stok_android`
3. Tunggu proses *syncing dependencies* selesai.
4. Pilih target emulator atau perangkat fisik (Android / Chrome / Windows).
5. Klik tombol tombol **Run** (segitiga hijau) atau tekan `Shift + F10`.

Bisa juga dijalankan lewat terminal:
```bash
cd D:\Kuliah\Mobile\Tugas2\aplikasi_stok_android
flutter run
```

---

## 🔑 Akun Login Demo
- **Username**: `admin`
- **Password**: `admin123`

---

## ✨ Fitur-Fitur Aplikasi

1. **Halaman Login**: Form login username & password dengan validasi sederhana.
2. **Halaman Data Kelompok**: Menampilkan daftar nama dan NIM anggota kelompok.
3. **Halaman Penjumlahan & Pengurangan**: Memilih barang gudang lalu menambah atau mengurangi kuantitas stoknya secara realtime.
4. **Halaman Perkalian & Pembagian**:
   - Perkalian kardus/box $\times$ isi per box.
   - Pembagian stok ke rak gudang beserta sisa barang menggunakan modulo (`%`).
5. **Halaman Ganjil / Genap**: Memilih barang dan mendeteksi apakah stok berjumlah ganjil atau genap beserta rekomendasi logistiknya.
6. **Halaman Total Angka**: Field input untuk deretan angka (dipisahkan koma atau spasi), menghitung Total, Rata-rata, Nilai Maks, dan Nilai Min.
