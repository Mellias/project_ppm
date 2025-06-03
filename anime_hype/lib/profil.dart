import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Gambar background di atas
          Container(
            height: 240,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('gambar/profil_pengguna/profil.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Konten scrollable (dibawah foto profil)
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
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'JOE SADEWA',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A3DBD),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Joesadewa9282@gmail.com',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildMenuItem(
                      icon: Icons.edit,
                      text: 'Edit Profil',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.notifications_none,
                      text: 'Notifikasi',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      text: 'Pengaturan',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      text: 'Bantuan',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      onTap: () {},
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Foto profil di tengah-tengah
          Positioned(
            top: 130,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage:
                  AssetImage('gambar/profil_pengguna/joe_sadewa.png'),
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
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: isLogout ? const Color(0xFFFFF0F0) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? Colors.red : const Color(0xFF5A3DBD),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isLogout ? Colors.red : Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isLogout ? Colors.red : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
