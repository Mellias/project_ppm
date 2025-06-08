import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  Future<void> _register() async {
    // Validasi kecocokan password
    if (passwordController.text != confirmController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return;
    }

    try {
      // Register akun
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil')),
      );

      // Arahkan ke halaman login
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal registrasi: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            height: 280,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('gambar/login/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Form & konten utama
          Column(
            children: [
              const SizedBox(height: 220),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F3FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5A3DBD),
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildInputField(
                            icon: Icons.mail,
                            hintText: 'Email',
                            obscure: false,
                            controller: emailController,
                          ),
                          const SizedBox(height: 8),

                          _buildInputField(
                            icon: Icons.lock,
                            hintText: 'Password',
                            obscure: true,
                            controller: passwordController,
                          ),
                          const SizedBox(height: 8),

                          _buildInputField(
                            icon: Icons.lock,
                            hintText: 'Password Confirm',
                            obscure: true,
                            controller: confirmController,
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5A3DBD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: const [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('Or Login With'),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Center(
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                'gambar/login/google.png',
                                width: 30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xFF5A3DBD),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Teks di atas gambar
          const Positioned(
            top: 100,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HELLO!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome to AnimeHype',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget input field dengan ikon dan hint
  Widget _buildInputField({
    required IconData icon,
    required String hintText,
    required bool obscure,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
