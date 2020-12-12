import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/auth_service.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class LoginModel extends BaseModel {
  AuthService _authService = getIt<AuthService>();
  User get currentUser {
    return _authService.currentUser;
  }

  Future<dynamic> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<void> signOut() async {
    return await _authService.signOut();
  }
}
