import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/penanggalan_logic.dart';
import '../database/database_helper.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Konversi Penanggalan Penerimaan Barang Gudang (Menu 8)
/// Mengonversi tanggal penerimaan ke Hijriah, Weton Jawa & Neptu, serta Saka Bali & Wuku
/// Logika kalender dipisah ke PenanggalanLogic, dan styling dipisah ke AppStyles & AppColors (Lavender).
class HalamanPenanggalanBarangMasuk extends StatefulWidget {
  const HalamanPenanggalanBarangMasuk({super.key});

  @override
  State<HalamanPenanggalanBarangMasuk> createState() =>
      _HalamanPenanggalanBarangMasukState();
}

class _HalamanPenanggalanBarangMasukState
    extends State<HalamanPenanggalanBarangMasuk> {
  DateTime _tanggalDipilih = DateTime.now();
  final TextEditingController _namaBarangCtrl =
      TextEditingController(text: "Beras Premium 5kg");
  final TextEditingController _nomorDoCtrl =
      TextEditingController(text: "DO-2026-0901");
  final TextEditingController _jumlahCtrl =
      TextEditingController(text: "50");

  List<Map<String, dynamic>> _riwayatSimpan = [];

  @override
  void initState() {
    super.initState();
    _muatRiwayat();
  }

  Future<void> _muatRiwayat() async {
    final list = await DatabaseHelper.instance.ambilRiwayatPenerimaan();
    setState(() {
      _riwayatSimpan = list;
    });
  }

  /// Membuka DatePicker untuk memilih tanggal kedatangan barang
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalDipilih,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _tanggalDipilih) {
      setState(() {
        _tanggalDipilih = picked;
      });
    }
  }

  /// Menyimpan hasil konversi ke database SQLite
  Future<void> _simpanKeSQLite(
    Map<String, dynamic> hijri,
    Map<String, dynamic> weton,
    Map<String, dynamic> saka,
  ) async {
    final nama = _namaBarangCtrl.text.trim();
    final noDo = _nomorDoCtrl.text.trim();
    final jumlah = int.tryParse(_jumlahCtrl.text.trim()) ?? 0;

    if (nama.isEmpty || jumlah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nama barang dan jumlah masuk wajib diisi valid!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final tglMasehi = DateFormat('yyyy-MM-dd').format(_tanggalDipilih);

    await DatabaseHelper.instance.simpanPenerimaanBarang(
      namaBarang: nama,
      nomorDo: noDo,
      tanggalMasehi: tglMasehi,
      tanggalHijriah: hijri['formatLengkap'],
      wetonJawa: weton['wetonLengkap'],
      neptu: weton['totalNeptu'],
      sakaBali: saka['tahunSaka'],
      wukuBali: saka['wuku'],
      jumlahMasuk: jumlah,
    );

    _muatRiwayat();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Penerimaan barang '$nama' berhasil disimpan ke SQLite!"),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jalankan konversi penanggalan menggunakan PenanggalanLogic
    final hijri = PenanggalanLogic.konversiKeHijriah(_tanggalDipilih);
    final weton = PenanggalanLogic.konversiKeWeton(_tanggalDipilih);
    final saka = PenanggalanLogic.konversiKeSakaBali(_tanggalDipilih);

    final formatTglMasehi =
        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_tanggalDipilih);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Penanggalan Terima Barang", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Input Penerimaan Barang
            Container(
              decoration: AppStyles.cardBoxDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        "Pencatatan Barang Tiba di Gudang",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _namaBarangCtrl,
                    decoration: AppStyles.inputDecoration(
                      labelText: "Nama Barang Diterima",
                      prefixIcon: Icons.inventory_2_outlined,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nomorDoCtrl,
                          decoration: AppStyles.inputDecoration(
                            labelText: "No. Surat Jalan (DO)",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _jumlahCtrl,
                          keyboardType: TextInputType.number,
                          decoration: AppStyles.inputDecoration(
                            labelText: "Jumlah Masuk",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Pemilih Tanggal Penerimaan
                  const Text(
                    "Tanggal Penerimaan Barang (Masehi):",
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => _pilihTanggal(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.lavenderAccent),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              formatTglMasehi,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Ubah Tanggal",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            const Text(
              "Hasil Konversi Penanggalan Logistik:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 10),

            // Card 1: Kalender Hijriah
            _buildHasilCard(
              judul: "1. Kalender Hijriah (Islam)",
              subJudul: hijri['formatLengkap'],
              ikon: Icons.nightlight_round,
              warnaIkon: AppColors.success,
              rincian: [
                "Hari Islam : ${hijri['hariArab']}",
                "Bulan & Th : ${hijri['bulan']} ${hijri['tahun']} Hijriah",
                "Momentum   : ${hijri['momentum']}",
              ],
            ),

            const SizedBox(height: 10),

            // Card 2: Kalender Weton Jawa
            _buildHasilCard(
              judul: "2. Kalender Weton Jawa & Neptu",
              subJudul: "${weton['wetonLengkap']}  •  Total Neptu: ${weton['totalNeptu']}",
              ikon: Icons.temple_buddhist,
              warnaIkon: AppColors.secondary,
              rincian: [
                "Hari Saptawara : ${weton['hari']} (Neptu: ${weton['neptuHari']})",
                "Hari Pasaran   : ${weton['pasaran']} (Neptu: ${weton['neptuPasaran']})",
                "Total Neptu    : ${weton['neptuHari']} + ${weton['neptuPasaran']} = ${weton['totalNeptu']}",
                "Logistik Pasar : ${weton['analisisDistribusi']}",
              ],
            ),

            const SizedBox(height: 10),

            // Card 3: Kalender Saka Bali
            _buildHasilCard(
              judul: "3. Kalender Saka Bali",
              subJudul: "${saka['tahunSaka']}  •  Wuku ${saka['wuku']}",
              ikon: Icons.festival,
              warnaIkon: AppColors.primaryDark,
              rincian: [
                "Tahun Saka : ${saka['tahunSaka']}",
                "Siklus Wuku: Wuku ${saka['wuku']} (dari 30 siklus wuku)",
                "Sasih Bali : ${saka['sasih']}",
                "Info Adat  : ${saka['infoLogistik']}",
              ],
            ),

            const SizedBox(height: 16),

            // Tombol Simpan ke Database SQLite
            ElevatedButton.icon(
              style: AppStyles.primaryButton,
              onPressed: () => _simpanKeSQLite(hijri, weton, saka),
              icon: const Icon(Icons.save),
              label: const Text(
                "Simpan Bukti Penerimaan ke SQLite",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),

            const SizedBox(height: 24),

            // Tabel Riwayat Penerimaan Tersimpan
            Text(
              "Riwayat Penerimaan Tersimpan di SQLite (${_riwayatSimpan.length} data):",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),

            if (_riwayatSimpan.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Belum ada riwayat penerimaan yang disimpan.",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ..._riwayatSimpan.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: AppStyles.cardBoxDecoration(),
                    child: ListTile(
                      title: Text(
                        "${r['nama_barang']} (+${r['jumlah_masuk']})",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                      ),
                      subtitle: Text(
                        "Tanggal: ${r['tanggal_masehi']}  •  DO: ${r['nomor_do'] ?? '-'}\n"
                        "Hijriah: ${r['tanggal_hijriah']}\n"
                        "Weton: ${r['weton_jawa']} (Neptu: ${r['neptu']})  •  Saka: ${r['saka_bali']} (${r['wuku_bali']})",
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildHasilCard({
    required String judul,
    required String subJudul,
    required IconData ikon,
    required Color warnaIkon,
    required List<String> rincian,
  }) {
    return Container(
      decoration: AppStyles.cardBoxDecoration(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: warnaIkon.withAlpha(30),
                child: Icon(ikon, color: warnaIkon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      subJudul,
                      style: TextStyle(
                        color: warnaIkon,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...rincian.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  t,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                    height: 1.3,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
