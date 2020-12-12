import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

void main() {
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
          setupLocators();
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => getIt<LoginModel>(),
              )
            ],
            child: MaterialApp(
              home: SafeArea(
                child: Consumer<LoginModel>(
                  builder: (context, model, child) {
                    return (model.currentUser != null)
                        ? LoginPage()
                        : LoginPage();
                  },
                ),
              ),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }

  Future<void> initializeApp() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();

      return LoginPage();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      print(e);
    }
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Text('Error!'),
    );
  }
}
