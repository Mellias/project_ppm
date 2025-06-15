class AnimePlace {
  String judul;
  String gambar;
  String sumberGambar;
  List<String> deskripsi;

  AnimePlace({
    required this.judul,
    required this.gambar,
    required this.sumberGambar,
    required this.deskripsi,
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