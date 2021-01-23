import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/auth_service.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/view/screens/login_page.dart';
import 'package:operation_reminder/view/screens/root_page.dart';
import 'package:operation_reminder/view/screens/verification_page.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class LoginModel extends BaseModel {
  AuthService _authService = getIt<AuthService>();
  OperationService _operationService = getIt<OperationService>();

  Future<void> signInWithGoogle() async {
    try {
      User user = await _authService.signInWithGoogle();
      if (user != null) {
        bool isVerified = await checkVerification(user.uid);
        isVerified
            ? await _navigateToHomepage()
            : await _navigateToVerificationPage();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await _navigateToLoginPage();
  }

  Future<bool> checkVerification(String id) async {
    return await _operationService.checkVerification();
  }

  Future<void> _navigateToHomepage() async {
    Doctor doctor = await _operationService.getCurrentDoctor();
    if (doctor != null)
      await navigatorService.navigateToReplace(
          routeName: RootPage.routeName, args: RootPageArgs(doctor: doctor));
  }

  Future<void> _navigateToVerificationPage() async {
    await navigatorService.navigateToReplace(
        routeName: VerificationPage.routeName);
  }

  Future<void> _navigateToLoginPage() async {
    await navigatorService.navigateToReplace(routeName: LoginPage.routeName);
  }
}
