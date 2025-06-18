import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  final List<Map<String, String>> faqList = const [
    {
      'pertanyaan': 'Bagaimana cara menyimpan berita?',
      'jawaban': 'Klik ikon bookmark di halaman detail berita.'
    },
    {
      'pertanyaan': 'Bagaimana cara mengganti foto profil?',
      'jawaban': 'Fitur ini belum tersedia. Nantikan di versi berikutnya.'
    },
    {
      'pertanyaan': 'Apa itu Trending Topik?',
      'jawaban': 'Berisi berita anime yang sedang populer atau viral.'
    },
    {
      'pertanyaan': 'Bagaimana cara membagikan berita?',
      'jawaban': 'Klik ikon share di pojok kanan atas, lalu pilih platform.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        backgroundColor: const Color(0xFFBEB9FF),
        // foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFFDFDFF),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final item = faqList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  item['pertanyaan']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A3DBD),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(item['jawaban']!),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
