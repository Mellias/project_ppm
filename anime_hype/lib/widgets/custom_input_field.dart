// Halaman widget form TextField reusable

import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscure;
  final TextEditingController controller;
  final VoidCallback? toggleObscure;
  final Function(String)? onSubmitted; // Tambahkan parameter onSubmitted

  const CustomInputField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.obscure,
    required this.controller,
    this.toggleObscure,
    this.onSubmitted, // Tambahkan parameter onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        hintText: hintText,
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: toggleObscure,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: onSubmitted, // Gunakan onSubmitted
    );
  }
}
