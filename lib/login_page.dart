import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String loginState = 'Waiting';

  @override
  Widget build(BuildContext context) {
    _auth.authStateChanges().listen((User user) {
      setState(() {
        user == null
            ? loginState = 'Not logged in.'
            : loginState = 'Logged in. Welcome ${user.displayName}';
      });
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          children: [
            Text(loginState),
            FlatButton(
              child: Text('Login With Google'),
              onPressed: () {
                kIsWeb ? signInWithGoogleWeb() : signInWithGoogleNative();
              },
            ),
            FlatButton(
              child: Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogleNative() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithGoogleWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }
}
