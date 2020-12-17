import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User get currentUser => _auth.currentUser;
  Stream<User> get userStream => _auth.authStateChanges();

  Future<User> signInWithGoogle() async {
    try {
      await _signInWithGoogle();
      return _auth.currentUser;
    } catch (e) {
      throw e;
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
