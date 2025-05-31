// Halaman untuk mengatur navigation bar

import 'package:flutter/material.dart';
import 'package:anime_hype/beranda.dart';
import 'package:anime_hype/simpan_berita.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BerandaBerita(),
    Center(child: Text('Halaman Pencarian')), // placeholder
    SimpanBerita(),
    Center(child: Text('Halaman Profil')),    // placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.search_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.bookmark_outline), label: ''),
          NavigationDestination(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}

