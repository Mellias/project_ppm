import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Future<User?> _refreshUser() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    return FirebaseAuth.instance.currentUser;
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _refreshUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          Future.microtask(() {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          });
          return const SizedBox(); // Placeholder sementara navigasi
        }

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
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildMenuItem(
                          icon: Icons.edit,
                          text: 'Edit Profil',
                          onTap: () {
                            Navigator.pushNamed(context, '/edit_profil').then((_) {
                              setState(() {});
                            });
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.bookmark,
                          text: 'Berita Tersimpan',
                          onTap: () {
                            Navigator.pushNamed(context, '/simpan_berita');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          text: 'Bantuan',
                          onTap: () {
                            Navigator.pushNamed(context, '/bantuan');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          text: 'Logout',
                          onTap: () => _logout(context),
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
      },
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
