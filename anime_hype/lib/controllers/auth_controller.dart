import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login dengan email dan password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Tangkap dan lempar ulang pesan error spesifik
      throw e.message ?? 'Terjadi kesalahan saat login.';
    } catch (_) {
      throw 'Kesalahan tidak diketahui saat login.';
    }
  }

  /// Registrasi akun baru dan set display name
  Future<User?> registerWithEmail(String fullName, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user != null) {
        await user.updateDisplayName(fullName);
        await user.reload(); // refresh data user
        return _auth.currentUser;
      } else {
        throw 'Registrasi gagal. User tidak tersedia.';
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Terjadi kesalahan saat registrasi.';
    } catch (_) {
      throw 'Kesalahan tidak diketahui saat registrasi.';
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Ambil user yang sedang login
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
