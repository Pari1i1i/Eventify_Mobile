import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  /// Triggers native Android/iOS Google Account Picker dialog
  Future<GoogleSignInAccount?> signIn() async {
    try {
      // Disconnect previous session if any to always allow account selection
      await _googleSignIn.signOut();
      final account = await _googleSignIn.signIn();
      return account;
    } catch (e) {
      // Re-throw or return null
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
