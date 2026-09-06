/// Model class untuk merepresentasikan Anggota Kelompok Mahasiswa
/// Menerapkan prinsip OOP: Abstraction & Data Modeling
class AnggotaKelompok {
  final String nama;
  final String nim;
  final String peran;

  AnggotaKelompok({
    required this.nama,
    required this.nim,
    required this.peran,
  });

  /// Mengembalikan daftar anggota kelompok default
  static List<AnggotaKelompok> ambilDaftarAnggota() {
    return [
      AnggotaKelompok(
        nama: "Wilda Ghoniyu Jiddan",
        nim: "124240085",
        peran: "",
      ),
      AnggotaKelompok(
        nama: "Rafid Ihsan Naufal",
        nim: "124240095",
        peran: "",
      ),
      AnggotaKelompok(
        nama: "Bagus Fajjar Pambudi",
        nim: "124240108",
        peran: "",
      ),
      AnggotaKelompok(
        nama: "Achmad Maulana",
        nim: "124240112",
        peran: "",
      ),
    ];
  }
}
