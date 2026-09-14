import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

class GoogleSignInResult {
  final GoogleSignInAccount account;
  final GoogleSignInAuthentication auth;

  GoogleSignInResult({
    required this.account,
    required this.auth,
  });

  String get email => account.email;
  String get displayName => account.displayName ?? account.email.split('@').first;
  String? get photoUrl => account.photoUrl;
  String? get idToken => auth.idToken;
  String? get accessToken => auth.accessToken;
}

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  /// Triggers native Android/iOS Google Authentication Overlay
  Future<GoogleSignInResult?> signIn() async {
    try {
      // Sign out first to ensure account selection dialog always appears
      await _googleSignIn.signOut();
      
      // 1. Trigger the Google Authentication flow overlay (Account Picker)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in dialog
        return null;
      }

      // 2. Obtain auth details (idToken & accessToken)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (kDebugMode) {
        debugPrint('[GoogleAuth] Email: ${googleUser.email}');
        debugPrint('[GoogleAuth] Name: ${googleUser.displayName}');
        debugPrint('[GoogleAuth] ID Token: ${googleAuth.idToken}');
      }

      return GoogleSignInResult(
        account: googleUser,
        auth: googleAuth,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[GoogleAuth Error] $error');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
