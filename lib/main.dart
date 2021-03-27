import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/view/screens/root_page.dart';
import 'package:operation_reminder/view/screens/verification_page.dart';
import 'package:operation_reminder/viewmodel/add_draft_model.dart';
import 'package:operation_reminder/viewmodel/home_drafts_model.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';
import 'package:operation_reminder/viewmodel/root_model.dart';
import 'package:provider/provider.dart';

import 'core/services/auth_service.dart';
import 'core/services/navigator_service.dart';
import 'model/doctor.dart';
import 'view/screens/login_page.dart';

void main() {
  setupLocators();
  runApp(OperationScheduler());
}

class OperationScheduler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      // Initialize FlutterFire:
      future: initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('error');
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            //TODO: Provider'ları locator'a taşı.
            providers: [
              ChangeNotifierProvider(
                create: (context) => getIt<LoginModel>(),
              ),
              ChangeNotifierProvider(
                create: (context) => getIt<RootModel>(),
              ),
              ChangeNotifierProvider(
                create: (context) => getIt<AddDraftModel>(),
              ),
              ChangeNotifierProvider(
                create: (context) => getIt<HomeDraftsModel>(),
              ),
            ],
            child: MaterialApp(
              navigatorKey: getIt<NavigatorService>().navigatorKey,
              onGenerateRoute: (settings) =>
                  getIt<NavigatorService>().generateRoute(settings),
              home: snapshot.data,
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(home: Loading());
      },
    );
  }

  Future<Widget> initializeApp() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      AuthService _authService = getIt<AuthService>();
      OperationService _operationService = getIt<OperationService>();
      User user = _authService.currentUser;
      if (user != null) {
        Doctor doctor = await _operationService.getCurrentDoctor();
        return doctor.isVerified
            ? RootPage(RootPageArgs(doctor: doctor))
            : VerificationPage();
      } else {
        return LoginPage();
      }
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      print(e);
    }
    return LoginPage();
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Center(child: Text('Error!')),
      ),
    );
  }
}
