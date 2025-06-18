import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Kalau tidak login, arahkan ke halaman login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox(); // supaya tidak crash saat build
    }

    // ✅ Dideklarasikan SEKALI SAJA, setelah null-check
    final name = user.displayName ?? 'Guest';
    final email = user.email ?? 'No email';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('gambar/profil_pengguna/profil.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 180),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF6F3FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -45),
                      child: const CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xFF5A3DBD),
                        backgroundImage: AssetImage(
                          'gambar/profil_pengguna/joe_sadewa.png',
                        ),
                      ),
                    ),
                    const SizedBox(height: 0),
                    Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A3DBD),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuItem(
                      icon: Icons.edit,
                      text: 'Edit Profil',
                      onTap: () {},
                    ),
                    const SizedBox(height: 5),
                    _buildMenuItem(
                      icon: Icons.bookmark,
                      text: 'Berita Tersimpan',
                      onTap: () {
                        Navigator.pushNamed(context, '/simpan_berita');
                      },
                    ),
                    const SizedBox(height: 5),
                    // _buildMenuItem(
                    //   icon: Icons.settings_outlined,
                    //   text: 'Pengaturan',
                    //   onTap: () {},
                    // ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      text: 'Bantuan',
                      onTap: () {
                        Navigator.pushNamed(context, '/bantuan');
                      },
                    ),
                    const SizedBox(height: 5),
                    _buildMenuItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity, // ✅ Lebar penuh
          margin: const EdgeInsets.symmetric(horizontal: 0), // opsional
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // bisa ditambah
          decoration: BoxDecoration(
            color: isLogout ? const Color(0xFFFFF0F0) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? Colors.red : const Color(0xFF5A3DBD),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: isLogout ? Colors.red : Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: isLogout ? Colors.red : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
