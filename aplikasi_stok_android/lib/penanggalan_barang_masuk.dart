import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'penanggalan_helper.dart';
import 'database_helper.dart';

/// Halaman Konversi Penanggalan Penerimaan Barang Gudang (Menu 8)
/// Konseptualisasi: Inbound Goods Receipt Cultural & Religious Calendar
/// Mengonversi tanggal masuk barang ke Kalender Hijriah, Weton Jawa & Neptu, serta Saka Bali & Wuku
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
        const SnackBar(content: Text("Nama barang dan jumlah masuk wajib diisi valid!")),
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
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jalankan konversi untuk tanggal yang sedang dipilih
    final hijri = PenanggalanHelper.konversiKeHijriah(_tanggalDipilih);
    final weton = PenanggalanHelper.konversiKeWeton(_tanggalDipilih);
    final saka = PenanggalanHelper.konversiKeSakaBali(_tanggalDipilih);

    final formatTglMasehi =
        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_tanggalDipilih);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Penanggalan Terima Barang"),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Input Penerimaan Barang
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_shipping, color: Colors.teal.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          "Pencatatan Barang Tiba di Gudang",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _namaBarangCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nama Barang Diterima",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nomorDoCtrl,
                            decoration: const InputDecoration(
                              labelText: "No. Surat Jalan (DO)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _jumlahCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Jumlah Masuk",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Pemilih Tanggal Penerimaan
                    const Text(
                      "Tanggal Penerimaan Barang (Masehi):",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _pilihTanggal(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.teal.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month, color: Colors.teal),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                formatTglMasehi,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "Ubah Tanggal",
                                style: TextStyle(
                                  color: Colors.teal,
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
            ),

            const SizedBox(height: 16),
            const Text(
              "Hasil Konversi Penanggalan Logistik:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Card 1: Kalender Hijriah
            _buildHasilCard(
              judul: "1. Kalender Hijriah (Islam)",
              subJudul: hijri['formatLengkap'],
              ikon: Icons.nightlight_round,
              warnaIkon: Colors.green,
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
              warnaIkon: Colors.orange,
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
              warnaIkon: Colors.deepPurple,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            if (_riwayatSimpan.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Belum ada riwayat penerimaan yang disimpan.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ..._riwayatSimpan.map((r) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        "${r['nama_barang']} (+${r['jumlah_masuk']})",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Tanggal: ${r['tanggal_masehi']}  •  DO: ${r['nomor_do'] ?? '-'}\n"
                        "Hijriah: ${r['tanggal_hijriah']}\n"
                        "Weton: ${r['weton_jawa']} (Neptu: ${r['neptu']})  •  Saka: ${r['saka_bali']} (${r['wuku_bali']})",
                        style: const TextStyle(fontSize: 12),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: warnaIkon.withAlpha(40),
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
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
