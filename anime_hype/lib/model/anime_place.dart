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

var animePlaceList = [
  AnimePlace(
    judul: 'Spy × Family Umumkan Musim Ketiga Tayang Oktober 2025',
    gambar: 'gambar/detail_berita/spyxfam.png',
    sumberGambar: 'Image by www.kawai.com',
    deskripsi: [
      'Setelah penantian panjang, musim ketiga dari anime Spy × Family resmi diumumkan akan tayang pada Oktober 2025.',
      'Pengumuman ini disampaikan dalam acara Jump Festa 2025, di mana para pengisi suara utama hadir untuk membagikan kabar gembira ini kepada para penggemar.',
      'Meskipun belum banyak detail yang diungkap, antusiasme penggemar meningkat dengan dirilisnya visual promosi terbaru yang menampilkan karakter-karakter utama.',
    ],
  ),
  AnimePlace(
    judul: 'One Piece: Petualangan di Pulau Egghead 6 April 2025',
    gambar: 'gambar/detail_berita/one_piece.png',
    sumberGambar: 'Image by www.kawai.com',
    deskripsi: [
      'Petualangan kru Topi Jerami kini memasuki babak baru yang penuh kejutan di Pulau Egghead, markas ilmuwan jenius Dr. Vegapunk. Dalam episode terbaru yang tayang pada 6 April 2025, para penggemar disambut dengan atmosfer futuristik yang kontras dengan dunia-dunia sebelumnya yang telah dijelajahi Luffy dan kawan-kawan. Visual canggih, teknologi yang belum pernah terlihat sebelumnya, dan kemunculan satelit Vegapunk menambah rasa penasaran dan misteri terhadap apa yang sebenarnya disembunyikan Pemerintah Dunia.',
      'Tak hanya soal teknologi, konflik mulai memanas saat agen CP0 mendekat ke pulau dengan misi yang mencurigakan. Di tengah kemeriahan eksplorasi, Luffy justru kembali menunjukkan sisi kocaknya ketika ia asyik bermain dengan robot-robot raksasa yang tak dikenalnya. Namun di balik semua itu, ancaman besar mulai membayang. Episode ini sukses menyulut antusiasme penggemar, membuktikan bahwa alur Egghead tak hanya membawa nuansa baru, tapi juga menandai awal dari konspirasi besar yang bisa mengguncang dunia One Piece.',
    ],
  ),
  AnimePlace(
    judul: 'Franchise Jujutsu Kaisen akan merilis film terbaru',
    gambar: 'gambar/detail_berita/franchise_jujutsu.png',
    sumberGambar: 'Image by www.kawai.com',
    deskripsi: [
      'Setelah kesuksesan besar “Jujutsu Kaisen 0”, franchise anime fenomenal Jujutsu Kaisen resmi mengumumkan perilisan film terbarunya yang tengah dalam tahap produksi. Pengumuman ini disampaikan langsung oleh studio MAPPA dalam acara tahunan Jump Festa 2025.',
      'Meskipun judul resminya belum diumumkan, teaser visual yang dirilis menunjukkan siluet misterius dari karakter populer yang diduga akan menjadi pusat cerita. Para penggemar pun langsung berspekulasi bahwa film ini akan mengeksplorasi masa lalu Gojo Satoru atau memperkenalkan arc baru yang belum ditayangkan di serial animenya.',
    ],
  ),
];

List<AnimePlace> bookmarkedPlaces =
    []; // memastikan list baru terisi kalau berita ditekan tombol bookmark