import 'package:flutter/material.dart';
import 'package:anime_hype/controllers/auth_controller.dart';
import 'package:anime_hype/widgets/custom_input_field.dart';
import 'package:anime_hype/views/navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final AuthController _authController = AuthController();

  Future<void> _login() async {
    // Validasi input kosong
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authController.loginWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login berhasil')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;

      // Menampilkan error yang lebih ramah
      String errorMessage = 'Gagal login. Coba lagi.';
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'Akun tidak ditemukan.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Password salah.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Header gambar
          Container(
            height: 280,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('gambar/login/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Form login
          Column(
            children: [
              const SizedBox(height: 220),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F3FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A3DBD),
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        CustomInputField(
                          icon: Icons.mail,
                          hintText: 'Input your email',
                          obscure: false,
                          controller: emailController,
                          onSubmitted: (_) => _login(), // Menangani tombol Enter
                        ),
                        const SizedBox(height: 16),

                        const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        CustomInputField(
                          icon: Icons.lock,
                          hintText: 'Input your password',
                          obscure: _obscurePassword,
                          controller: passwordController,
                          toggleObscure: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          onSubmitted: (_) => _login(), // Menangani tombol Enter
                        ),
                        const SizedBox(height: 24),

                        // Tombol login
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5A3DBD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2,
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Navigasi ke register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                "Register",
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
            ],
          ),

          // Header teks
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
                  'Welcome back to AnimeHype',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}