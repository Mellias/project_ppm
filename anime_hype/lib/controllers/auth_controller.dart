import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ✅ Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ Register
  Future<User?> registerWithEmail(String fullName, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Update display name
      await result.user!.updateDisplayName(fullName);
      await result.user!.reload(); // refresh data user

      return _auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// ✅ Get current user (if logged in)
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
