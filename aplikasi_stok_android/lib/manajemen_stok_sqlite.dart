import 'package:flutter/material.dart';
import 'database_helper.dart';

/// Halaman Manajemen Stok Gudang SQLite (Menu 7)
/// Mengimplementasikan CRUD lengkap (Create, Read, Update, Delete) & Log Mutasi
/// Berbasis basis data lokal SQLite (warehouse_smart.db)
class HalamanManajemenStokSQLite extends StatefulWidget {
  const HalamanManajemenStokSQLite({super.key});

  @override
  State<HalamanManajemenStokSQLite> createState() =>
      _HalamanManajemenStokSQLiteState();
}

class _HalamanManajemenStokSQLiteState
    extends State<HalamanManajemenStokSQLite>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _daftarBarang = [];
  List<Map<String, dynamic>> _daftarLog = [];
  bool _isLoading = true;

  // Pencarian
  final TextEditingController _searchController = TextEditingController();
  String _kataKunci = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _muatData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Memuat data dari database SQLite
  Future<void> _muatData() async {
    setState(() => _isLoading = true);
    final barang = await DatabaseHelper.instance.ambilSemuaBarang();
    final log = await DatabaseHelper.instance.ambilRiwayatLog();
    setState(() {
      _daftarBarang = barang;
      _daftarLog = log;
      _isLoading = false;
    });
  }

  /// Filter barang berdasarkan kata kunci pencarian
  List<Map<String, dynamic>> get _barangTerfilter {
    if (_kataKunci.isEmpty) return _daftarBarang;
    return _daftarBarang.where((item) {
      final nama = (item['nama_barang'] ?? '').toString().toLowerCase();
      final kode = (item['kode_barang'] ?? '').toString().toLowerCase();
      final kategori = (item['kategori'] ?? '').toString().toLowerCase();
      return nama.contains(_kataKunci.toLowerCase()) ||
          kode.contains(_kataKunci.toLowerCase()) ||
          kategori.contains(_kataKunci.toLowerCase());
    }).toList();
  }

  // ==========================================================
  // DIALOG TAMBAH BARANG BARU (CREATE)
  // ==========================================================
  void _tampilkanDialogTambah() {
    final kodeCtrl = TextEditingController(text: "BRG-00${_daftarBarang.length + 1}");
    final namaCtrl = TextEditingController();
    final kategoriCtrl = TextEditingController(text: "Sembako");
    final stokCtrl = TextEditingController(text: "10");
    final satuanCtrl = TextEditingController(text: "pcs");
    final hargaCtrl = TextEditingController(text: "15000");
    final rakCtrl = TextEditingController(text: "Rak A1");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Barang Baru ke SQLite"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: kodeCtrl,
                decoration: const InputDecoration(labelText: "Kode Barang (SKU)"),
              ),
              TextField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Barang"),
              ),
              TextField(
                controller: kategoriCtrl,
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
              TextField(
                controller: stokCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Stok Awal"),
              ),
              TextField(
                controller: satuanCtrl,
                decoration: const InputDecoration(labelText: "Satuan (pcs, kg, dll)"),
              ),
              TextField(
                controller: hargaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga Satuan (Rp)"),
              ),
              TextField(
                controller: rakCtrl,
                decoration: const InputDecoration(labelText: "Lokasi Rak"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final nama = namaCtrl.text.trim();
              if (nama.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nama barang wajib diisi!")),
                );
                return;
              }

              final stok = int.tryParse(stokCtrl.text.trim()) ?? 0;
              final harga = double.tryParse(hargaCtrl.text.trim()) ?? 0.0;

              await DatabaseHelper.instance.tambahBarang(
                kodeBarang: kodeCtrl.text.trim(),
                namaBarang: nama,
                kategori: kategoriCtrl.text.trim(),
                stok: stok,
                satuan: satuanCtrl.text.trim(),
                hargaSatuan: harga,
                lokasiRak: rakCtrl.text.trim(),
              );

              if (mounted) Navigator.pop(ctx);
              _muatData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Barang '$nama' berhasil disimpan ke SQLite!")),
              );
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DIALOG EDIT BARANG (UPDATE)
  // ==========================================================
  void _tampilkanDialogEdit(Map<String, dynamic> item) {
    final namaCtrl = TextEditingController(text: item['nama_barang']);
    final kategoriCtrl = TextEditingController(text: item['kategori']);
    final satuanCtrl = TextEditingController(text: item['satuan']);
    final hargaCtrl = TextEditingController(text: item['harga_satuan'].toString());
    final rakCtrl = TextEditingController(text: item['lokasi_rak']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Edit Barang: ${item['nama_barang']}"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Barang"),
              ),
              TextField(
                controller: kategoriCtrl,
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
              TextField(
                controller: satuanCtrl,
                decoration: const InputDecoration(labelText: "Satuan"),
              ),
              TextField(
                controller: hargaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga Satuan (Rp)"),
              ),
              TextField(
                controller: rakCtrl,
                decoration: const InputDecoration(labelText: "Lokasi Rak"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final nama = namaCtrl.text.trim();
              final harga = double.tryParse(hargaCtrl.text.trim()) ?? 0.0;

              await DatabaseHelper.instance.updateBarang(
                id: item['id'],
                namaBarang: nama,
                kategori: kategoriCtrl.text.trim(),
                satuan: satuanCtrl.text.trim(),
                hargaSatuan: harga,
                lokasiRak: rakCtrl.text.trim(),
              );

              if (mounted) Navigator.pop(ctx);
              _muatData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Data barang berhasil diupdate!")),
              );
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DIALOG HAPUS BARANG (DELETE)
  // ==========================================================
  void _konfirmasiHapus(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus '${item['nama_barang']}' dari SQLite?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await DatabaseHelper.instance.hapusBarang(item['id']);
              if (mounted) Navigator.pop(ctx);
              _muatData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Barang '${item['nama_barang']}' telah dihapus.")),
              );
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DIALOG CEPAT MUTASI STOK (+ / -)
  // ==========================================================
  void _tampilkanDialogMutasi(Map<String, dynamic> item, bool isMasuk) {
    final jumlahCtrl = TextEditingController(text: "5");
    final ketCtrl = TextEditingController(
      text: isMasuk ? "Penerimaan restock supplier" : "Pengeluaran pesanan toko",
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isMasuk ? "Tambah Stok Masuk (+)" : "Kurang Stok Keluar (-)"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Barang: ${item['nama_barang']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Stok Saat Ini: ${item['stok']} ${item['satuan']}"),
            const SizedBox(height: 12),
            TextField(
              controller: jumlahCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: isMasuk ? "Jumlah Masuk (+)" : "Jumlah Keluar (-)",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ketCtrl,
              decoration: const InputDecoration(
                labelText: "Keterangan / Alasan Mutasi",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isMasuk ? Colors.green : Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final jumlah = int.tryParse(jumlahCtrl.text.trim()) ?? 0;
              if (jumlah <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Jumlah mutasi harus lebih dari 0!")),
                );
                return;
              }

              final perubahan = isMasuk ? jumlah : -jumlah;
              final sukses = await DatabaseHelper.instance.mutasiStok(
                itemId: item['id'],
                namaBarang: item['nama_barang'],
                perubahan: perubahan,
                keterangan: ketCtrl.text.trim(),
              );

              if (mounted) Navigator.pop(ctx);
              if (sukses) {
                _muatData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isMasuk
                          ? "Berhasil menambah $jumlah ${item['satuan']}!"
                          : "Berhasil mengurangi $jumlah ${item['satuan']}!",
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal: Stok di gudang tidak mencukupi!"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(isMasuk ? "Simpan Masuk (+)" : "Simpan Keluar (-)"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Stok SQLite"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: "Tambah Barang Baru",
            icon: const Icon(Icons.add),
            onPressed: _tampilkanDialogTambah,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(icon: const Icon(Icons.inventory_2), text: "Daftar Stok (${_daftarBarang.length})"),
            Tab(icon: const Icon(Icons.history), text: "Riwayat Log (${_daftarLog.length})"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTabDaftarBarang(),
                _buildTabRiwayatLog(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        tooltip: "Tambah Barang Baru",
        onPressed: _tampilkanDialogTambah,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ==========================================================
  // TAB 1: DAFTAR BARANG DENGAN SEARCH & STATUS STOK
  // ==========================================================
  Widget _buildTabDaftarBarang() {
    final list = _barangTerfilter;

    return Column(
      children: [
        // Bar Pencarian
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Cari nama barang, kode SKU, atau kategori...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _kataKunci.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _kataKunci = "");
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (val) {
              setState(() => _kataKunci = val);
            },
          ),
        ),

        // Daftar Card Barang
        Expanded(
          child: list.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada data barang yang cocok.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 90),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final stok = item['stok'] as int;

                    // Status Warna Stok
                    Color badgeColor = Colors.green;
                    String badgeText = "Stok Aman";
                    if (stok <= 5) {
                      badgeColor = Colors.red;
                      badgeText = "Kritis";
                    } else if (stok <= 20) {
                      badgeColor = Colors.orange;
                      badgeText = "Menipis";
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Baris Atas: Kode SKU & Badge Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['kode_barang'] ?? "-",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withAlpha(30),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: badgeColor),
                                  ),
                                  child: Text(
                                    badgeText,
                                    style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Nama Barang
                            Text(
                              item['nama_barang'] ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Detail Info (Kategori, Lokasi Rak, Harga)
                            Row(
                              children: [
                                Text(
                                  "Kategori: ${item['kategori']}  •  ${item['lokasi_rak']}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Harga: Rp ${item['harga_satuan']?.toStringAsFixed(0)} / ${item['satuan']}",
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const Divider(height: 16),

                            // Baris Bawah: Stok Aktif & Tombol Aksi Cepat
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Stok: $stok ${item['satuan']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Tombol Mutasi Masuk (+)
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      iconSize: 22,
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.add_circle, color: Colors.green),
                                      tooltip: "Tambah Stok Masuk",
                                      onPressed: () => _tampilkanDialogMutasi(item, true),
                                    ),
                                    const SizedBox(width: 4),
                                    // Tombol Mutasi Keluar (-)
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      iconSize: 22,
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.remove_circle, color: Colors.orange),
                                      tooltip: "Kurang Stok Keluar",
                                      onPressed: () => _tampilkanDialogMutasi(item, false),
                                    ),
                                    const SizedBox(width: 4),
                                    // Tombol Edit
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      iconSize: 22,
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      tooltip: "Edit Rincian Barang",
                                      onPressed: () => _tampilkanDialogEdit(item),
                                    ),
                                    const SizedBox(width: 4),
                                    // Tombol Hapus
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      iconSize: 22,
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      tooltip: "Hapus Barang",
                                      onPressed: () => _konfirmasiHapus(item),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ==========================================================
  // TAB 2: RIWAYAT MUTASI STOK (AUDIT LOG)
  // ==========================================================
  Widget _buildTabRiwayatLog() {
    if (_daftarLog.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada catatan mutasi stok di SQLite.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 90),
      itemCount: _daftarLog.length,
      itemBuilder: (context, index) {
        final log = _daftarLog[index];
        final isMasuk = log['jenis_mutasi'] == 'MASUK';

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isMasuk ? Colors.green.shade100 : Colors.orange.shade100,
              child: Icon(
                isMasuk ? Icons.arrow_downward : Icons.arrow_upward,
                color: isMasuk ? Colors.green.shade800 : Colors.orange.shade800,
              ),
            ),
            title: Text(
              "${log['nama_barang']} (${isMasuk ? '+' : '-'}${log['jumlah']})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Waktu: ${log['tanggal']}\nKet: ${log['keterangan'] ?? '-'}",
              style: const TextStyle(fontSize: 12),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
