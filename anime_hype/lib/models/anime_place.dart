class AnimePlace {
  String judul;
  String gambar;
  String sumberGambar;
  List<String> deskripsi;
  String title; // Tambahkan properti title
  String description; // Tambahkan properti description

  AnimePlace({
    required this.judul,
    required this.gambar,
    required this.sumberGambar,
    required this.deskripsi,
    required this.title, // Tambahkan ke konstruktor
    required this.description, // Tambahkan ke konstruktor
  });

  @override
  bool operator ==(Object other) {
    return other is AnimePlace && other.judul == judul;
  }

  @override
  int get hashCode => judul.hashCode;
}

List<AnimePlace> bookmarkedPlaces =
    []; // memastikan list baru terisi kalau berita ditekan tombol bookmark