import 'package:flutter/material.dart';
import 'package:anime_hype/controllers/auth_controller.dart';
import 'package:anime_hype/widgets/custom_input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final AuthController _authController = AuthController();

  Future<void> _register() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authController.registerWithEmail(
        fullName,
        email,
        password,
      );

      if (!mounted) return;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (!mounted) return;

      String errorMessage = 'Registrasi gagal. Coba lagi.';
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'Email sudah digunakan.';
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
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            height: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('gambar/login/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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

                        const Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        CustomInputField(
                          icon: Icons.person,
                          hintText: 'Enter your full name',
                          obscure: false,
                          controller: fullNameController,
                        ),
                        const SizedBox(height: 16),

                        const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        CustomInputField(
                          icon: Icons.mail,
                          hintText: 'Input your email',
                          obscure: false,
                          controller: emailController,
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
                        ),
                        const SizedBox(height: 16),

                        const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        CustomInputField(
                          icon: Icons.lock,
                          hintText: 'Re-enter your password',
                          obscure: _obscureConfirm,
                          controller: confirmController,
                          toggleObscure: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
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
                                    'Register',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
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
            ],
          ),

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
}
