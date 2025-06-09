// file: lib/widgets/bookmark_card.dart
import 'package:flutter/material.dart';
import 'package:anime_hype/views/detail_berita.dart';
import 'package:anime_hype/models/anime_place.dart';

class BookmarkCard extends StatelessWidget {
  final AnimePlace place;
  final VoidCallback? onTap;

  const BookmarkCard({super.key, required this.place, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBerita(animePlace: place),
                ),
              );
            },
        child: SizedBox(
          width: 385,
          height: 190,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      place.gambar,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: Text(
                      place.judul,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
