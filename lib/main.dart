import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/screens/root_page.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';
import 'package:operation_reminder/viewmodel/root_model.dart';
import 'package:provider/provider.dart';

import 'core/services/auth_service.dart';
import 'core/services/navigator_service.dart';
import 'screens/login_page.dart';

void main() {
  setupLocators();
  runApp(OperationScheduler());
}

class OperationScheduler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('error');
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          AuthService _authService = getIt<AuthService>();
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => getIt<LoginModel>(),
              ),
              ChangeNotifierProvider(
                create: (context) => getIt<RootModel>(),
              ),
            ],
            child: MaterialApp(
              navigatorKey: getIt<NavigatorService>().navigatorKey,
              onGenerateRoute: (settings) =>
                  getIt<NavigatorService>().generateRoute(settings),
              home: _authService.currentUser != null
                  ? RootPage(RootPageArgs(user: _authService.currentUser))
                  : LoginPage(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(home: Loading());
      },
    );
  }

  Future<void> initializeApp() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      print(e);
    }
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
