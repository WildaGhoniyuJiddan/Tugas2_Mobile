import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Class DatabaseHelper
/// Mengelola koneksi dan operasi database lokal SQLite untuk aplikasi gudang.
/// Didesain terpisah dalam layer database agar modular dan rapi.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Mengambil instance database SQLite, menginisialisasi jika belum ada
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('warehouse_smart.db');
    return _database!;
  }

  /// Membuka file database lokal
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Membuat tabel-tabel database dan mengisi data awal (seed data)
  Future<void> _createDB(Database db, int version) async {
    // 1. Tabel users (Akun login)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        nama_lengkap TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // 2. Tabel items (Daftar barang inventaris gudang)
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kode_barang TEXT NOT NULL UNIQUE,
        nama_barang TEXT NOT NULL,
        kategori TEXT NOT NULL,
        stok INTEGER NOT NULL DEFAULT 0,
        satuan TEXT NOT NULL,
        harga_satuan REAL NOT NULL DEFAULT 0.0,
        lokasi_rak TEXT
      )
    ''');

    // 3. Tabel stock_logs (Catatan mutasi stok masuk/keluar)
    await db.execute('''
      CREATE TABLE stock_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER,
        nama_barang TEXT NOT NULL,
        jenis_mutasi TEXT NOT NULL,
        jumlah INTEGER NOT NULL,
        keterangan TEXT,
        tanggal TEXT NOT NULL
      )
    ''');

    // 4. Tabel inbound_receipts (Riwayat penerimaan barang & konversi penanggalan)
    await db.execute('''
      CREATE TABLE inbound_receipts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_barang TEXT NOT NULL,
        nomor_do TEXT,
        tanggal_masehi TEXT NOT NULL,
        tanggal_hijriah TEXT NOT NULL,
        weton_jawa TEXT NOT NULL,
        neptu INTEGER NOT NULL,
        saka_bali TEXT NOT NULL,
        wuku_bali TEXT NOT NULL,
        jumlah_masuk INTEGER NOT NULL,
        dicatat_pada TEXT NOT NULL
      )
    ''');

    // Mengisi data awal akun login
    await db.rawInsert('''
      INSERT INTO users (username, password, nama_lengkap, role)
      VALUES 
      ('admin', 'admin123', 'Administrator Gudang', 'Super Admin'),
      ('user', 'user123', 'Staff Operator Gudang', 'Staff Gudang'),
      ('wilda', 'password123', 'Wilda Ghoniyu Jiddan', 'Lead Warehouse Officer')
    ''');

    // Mengisi data awal barang gudang (diselaraskan dengan inventaris sembako)
    await db.rawInsert('''
      INSERT INTO items (kode_barang, nama_barang, kategori, stok, satuan, harga_satuan, lokasi_rak)
      VALUES 
      ('BRG-001', 'Beras Premium 5kg', 'Sembako', 25, 'karung', 68000.0, 'Rak A1'),
      ('BRG-002', 'Minyak Goreng 2L', 'Sembako', 14, 'pouch', 34000.0, 'Rak A2'),
      ('BRG-003', 'Gula Pasir Kristal 1kg', 'Sembako', 30, 'kg', 17500.0, 'Rak B1'),
      ('BRG-004', 'Kopi Bubuk Robusta 250g', 'Minuman', 17, 'pack', 22000.0, 'Rak B2'),
      ('BRG-005', 'Tepung Terigu Serbaguna 1kg', 'Bahan Pokok', 8, 'kg', 13000.0, 'Rak C1'),
      ('BRG-006', 'Indomie', 'Makanan Cepat Saji', 90, 'pcs', 3100.0, 'Rak C2')
    ''');
  }

  // ==========================================
  // OPERASI USER & LOGIN
  // ==========================================

  /// Memvalidasi kredensial login pengguna
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await database;
    final hasil = await db.query(
      'users',
      where: 'LOWER(username) = ? AND password = ?',
      whereArgs: [username.toLowerCase(), password],
    );

    if (hasil.isNotEmpty) {
      return hasil.first;
    }
    return null;
  }

  // ==========================================
  // OPERASI CRUD BARANG GUDANG (ITEMS)
  // ==========================================

  /// Mengambil semua daftar barang gudang
  Future<List<Map<String, dynamic>>> ambilSemuaBarang() async {
    final db = await database;
    return await db.query('items', orderBy: 'id ASC');
  }

  /// Menambah barang baru ke database
  Future<int> tambahBarang({
    required String kodeBarang,
    required String namaBarang,
    required String kategori,
    required int stok,
    required String satuan,
    required double hargaSatuan,
    required String lokasiRak,
  }) async {
    final db = await database;
    return await db.insert('items', {
      'kode_barang': kodeBarang,
      'nama_barang': namaBarang,
      'kategori': kategori,
      'stok': stok,
      'satuan': satuan,
      'harga_satuan': hargaSatuan,
      'lokasi_rak': lokasiRak,
    });
  }

  /// Mengubah/update data barang
  Future<int> updateBarang({
    required int id,
    required String namaBarang,
    required String kategori,
    required String satuan,
    required double hargaSatuan,
    required String lokasiRak,
  }) async {
    final db = await database;
    return await db.update(
      'items',
      {
        'nama_barang': namaBarang,
        'kategori': kategori,
        'satuan': satuan,
        'harga_satuan': hargaSatuan,
        'lokasi_rak': lokasiRak,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Menghapus data barang
  Future<int> hapusBarang(int id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  /// Mutasi Cepat: Tambah (+) atau Kurang (-) stok dan mencatat ke stock_logs
  Future<bool> mutasiStok({
    required int itemId,
    required String namaBarang,
    required int perubahan, // Positif jika Masuk, Negatif jika Keluar
    required String keterangan,
  }) async {
    final db = await database;

    // Ambil data stok saat ini
    final list = await db.query('items', where: 'id = ?', whereArgs: [itemId]);
    if (list.isEmpty) return false;

    final stokLama = list.first['stok'] as int;
    final stokBaru = stokLama + perubahan;

    if (stokBaru < 0) {
      return false; // Stok tidak mencukupi
    }

    // Update stok di tabel items
    await db.update(
      'items',
      {'stok': stokBaru},
      where: 'id = ?',
      whereArgs: [itemId],
    );

    // Catat riwayat ke tabel stock_logs
    final jenis = perubahan >= 0 ? 'MASUK' : 'KELUAR';
    final jumlahPositif = perubahan.abs();
    final waktu = DateTime.now().toString().substring(0, 19);

    await db.insert('stock_logs', {
      'item_id': itemId,
      'nama_barang': namaBarang,
      'jenis_mutasi': jenis,
      'jumlah': jumlahPositif,
      'keterangan': keterangan,
      'tanggal': waktu,
    });

    return true;
  }

  /// Mengambil seluruh riwayat mutasi stok
  Future<List<Map<String, dynamic>>> ambilRiwayatLog() async {
    final db = await database;
    return await db.query('stock_logs', orderBy: 'id DESC');
  }

  // ==========================================
  // OPERASI PENERIMAAN BARANG (INBOUND)
  // ==========================================

  /// Menyimpan pencatatan penerimaan barang beserta hasil konversi penanggalan
  Future<int> simpanPenerimaanBarang({
    required String namaBarang,
    required String nomorDo,
    required String tanggalMasehi,
    required String tanggalHijriah,
    required String wetonJawa,
    required int neptu,
    required String sakaBali,
    required String wukuBali,
    required int jumlahMasuk,
  }) async {
    final db = await database;
    final waktu = DateTime.now().toString().substring(0, 19);

    return await db.insert('inbound_receipts', {
      'nama_barang': namaBarang,
      'nomor_do': nomorDo,
      'tanggal_masehi': tanggalMasehi,
      'tanggal_hijriah': tanggalHijriah,
      'weton_jawa': wetonJawa,
      'neptu': neptu,
      'saka_bali': sakaBali,
      'wuku_bali': wukuBali,
      'jumlah_masuk': jumlahMasuk,
      'dicatat_pada': waktu,
    });
  }

  /// Mengambil daftar riwayat penerimaan barang masuk
  Future<List<Map<String, dynamic>>> ambilRiwayatPenerimaan() async {
    final db = await database;
    return await db.query('inbound_receipts', orderBy: 'id DESC');
  }
}
