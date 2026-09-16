import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Manajemen Stok Gudang SQLite (Menu 7)
/// Mengimplementasikan CRUD lengkap (Create, Read, Update, Delete) & Log Mutasi
/// Berbasis basis data lokal SQLite (warehouse_smart.db) dengan styling AppStyles & AppColors (Lavender).
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
        title: const Text("Tambah Barang Baru ke SQLite", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: kodeCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Kode Barang (SKU)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: namaCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Nama Barang"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: kategoriCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Kategori"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stokCtrl,
                keyboardType: TextInputType.number,
                decoration: AppStyles.inputDecoration(labelText: "Stok Awal"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: satuanCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Satuan (pcs, kg, dll)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hargaCtrl,
                keyboardType: TextInputType.number,
                decoration: AppStyles.inputDecoration(labelText: "Harga Satuan (Rp)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: rakCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Lokasi Rak"),
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
            style: AppStyles.primaryButton,
            onPressed: () async {
              final nama = namaCtrl.text.trim();
              if (nama.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Nama barang wajib diisi!"),
                    backgroundColor: AppColors.danger,
                  ),
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
                SnackBar(
                  content: Text("Barang '$nama' berhasil disimpan ke SQLite!"),
                  backgroundColor: AppColors.success,
                ),
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
        title: Text("Edit Barang: ${item['nama_barang']}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Nama Barang"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: kategoriCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Kategori"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: satuanCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Satuan"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hargaCtrl,
                keyboardType: TextInputType.number,
                decoration: AppStyles.inputDecoration(labelText: "Harga Satuan (Rp)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: rakCtrl,
                decoration: AppStyles.inputDecoration(labelText: "Lokasi Rak"),
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
            style: AppStyles.primaryButton,
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
                const SnackBar(
                  content: Text("Data barang berhasil diupdate!"),
                  backgroundColor: AppColors.success,
                ),
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
        title: const Text("Konfirmasi Hapus", style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
        content: Text("Apakah Anda yakin ingin menghapus '${item['nama_barang']}' dari SQLite?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: AppStyles.dangerButton,
            onPressed: () async {
              await DatabaseHelper.instance.hapusBarang(item['id']);
              if (mounted) Navigator.pop(ctx);
              _muatData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Barang '${item['nama_barang']}' telah dihapus."),
                  backgroundColor: AppColors.danger,
                ),
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
        title: Text(
          isMasuk ? "Tambah Stok Masuk (+)" : "Kurang Stok Keluar (-)",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isMasuk ? AppColors.success : AppColors.warning,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Barang: ${item['nama_barang']}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            Text("Stok Saat Ini: ${item['stok']} ${item['satuan']}", style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 14),
            TextField(
              controller: jumlahCtrl,
              keyboardType: TextInputType.number,
              decoration: AppStyles.inputDecoration(
                labelText: isMasuk ? "Jumlah Masuk (+)" : "Jumlah Keluar (-)",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ketCtrl,
              decoration: AppStyles.inputDecoration(
                labelText: "Keterangan / Alasan Mutasi",
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
            style: isMasuk ? AppStyles.successButton : AppStyles.warningButton,
            onPressed: () async {
              final jumlah = int.tryParse(jumlahCtrl.text.trim()) ?? 0;
              if (jumlah <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Jumlah mutasi harus lebih dari 0!"),
                    backgroundColor: AppColors.danger,
                  ),
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
                    backgroundColor: isMasuk ? AppColors.success : AppColors.warning,
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
                    backgroundColor: AppColors.danger,
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Manajemen Stok SQLite", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
        actions: [
          IconButton(
            tooltip: "Tambah Barang Baru",
            icon: const Icon(Icons.add),
            onPressed: _tampilkanDialogTambah,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: [
            Tab(icon: const Icon(Icons.inventory_2_outlined), text: "Daftar Stok (${_daftarBarang.length})"),
            Tab(icon: const Icon(Icons.history_outlined), text: "Riwayat Log (${_daftarLog.length})"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTabDaftarBarang(),
                _buildTabRiwayatLog(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
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
            decoration: AppStyles.inputDecoration(
              labelText: "Cari Barang",
              hintText: "Cari nama barang, SKU, atau kategori...",
              prefixIcon: Icons.search,
              suffixIcon: _kataKunci.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textMuted),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _kataKunci = "");
                      },
                    )
                  : null,
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
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 90),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final stok = item['stok'] as int;

                    // Status Warna Stok
                    Color badgeColor = AppColors.success;
                    String badgeText = "Stok Aman";
                    if (stok <= 5) {
                      badgeColor = AppColors.danger;
                      badgeText = "Kritis";
                    } else if (stok <= 20) {
                      badgeColor = AppColors.warning;
                      badgeText = "Menipis";
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: AppStyles.cardBoxDecoration(),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Baris Atas: Kode SKU & Badge Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['kode_barang'] ?? "-",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: badgeColor),
                                ),
                                child: Text(
                                  badgeText,
                                  style: AppTextStyles.badge(badgeColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Nama Barang
                          Text(
                            item['nama_barang'] ?? "",
                            style: AppTextStyles.cardTitle,
                          ),
                          const SizedBox(height: 4),

                          // Detail Info (Kategori, Lokasi Rak, Harga)
                          Text(
                            "Kategori: ${item['kategori']}  •  ${item['lokasi_rak']}",
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Harga: Rp ${item['harga_satuan']?.toStringAsFixed(0)} / ${item['satuan']}",
                            style: const TextStyle(
                              color: AppColors.primaryDark,
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
                                    color: AppColors.textDark,
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
                                    icon: const Icon(Icons.add_circle, color: AppColors.success),
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
                                    icon: const Icon(Icons.remove_circle, color: AppColors.warning),
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
                                    icon: const Icon(Icons.edit, color: AppColors.primary),
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
                                    icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                                    tooltip: "Hapus Barang",
                                    onPressed: () => _konfirmasiHapus(item),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
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
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 90),
      itemCount: _daftarLog.length,
      itemBuilder: (context, index) {
        final log = _daftarLog[index];
        final isMasuk = log['jenis_mutasi'] == 'MASUK';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: AppStyles.cardBoxDecoration(),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isMasuk ? AppColors.successLight : AppColors.warningLight,
              child: Icon(
                isMasuk ? Icons.arrow_downward : Icons.arrow_upward,
                color: isMasuk ? AppColors.success : AppColors.warning,
              ),
            ),
            title: Text(
              "${log['nama_barang']} (${isMasuk ? '+' : '-'}${log['jumlah']})",
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            subtitle: Text(
              "Waktu: ${log['tanggal']}\nKet: ${log['keterangan'] ?? '-'}",
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
