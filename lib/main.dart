import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

void main() {
  runApp(OperationScheduler());
}

class OperationScheduler extends StatefulWidget {
  @override
  _OperationSchedulerState createState() => _OperationSchedulerState();
}

class _OperationSchedulerState extends State<OperationScheduler> {
  Widget home = Loading();

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        home = LoginPage();
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        home = Error();
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    return MaterialApp(
      title: 'Operation Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home,
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Text('Loading...'),
      ),
    );
  }
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Text('Error!'),
      ),
    );
  }
}
