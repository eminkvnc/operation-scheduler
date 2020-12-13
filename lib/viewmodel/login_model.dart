import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/auth_service.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/screens/login_page.dart';
import 'package:operation_reminder/screens/root_page.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class LoginModel extends BaseModel {
  AuthService _authService = getIt<AuthService>();
  User get currentUser {
    return _authService.currentUser;
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      await navigateToHomepage();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await navigateToLoginPage();
  }

  Future<void> navigateToHomepage() async {
    if (currentUser != null)
      await navigatorService.navigateToReplace(
          routeName: RootPage.routeName, args: RootPageArgs(user: currentUser));
  }

  Future<void> navigateToLoginPage() async {
    if (currentUser == null)
      await navigatorService.navigateToReplace(routeName: LoginPage.routeName);
  }
}
