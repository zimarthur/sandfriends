import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
      clientId: kIsWeb
          ? "329100803665-mbsc1tv1nav9j2tl9psrnm0tipmb1r1e.apps.googleusercontent.com"
          : null);

  static Future<bool?> isLoggedIn() => _googleSignIn.isSignedIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future<GoogleSignInAccount?> logout() => _googleSignIn.disconnect();
}
