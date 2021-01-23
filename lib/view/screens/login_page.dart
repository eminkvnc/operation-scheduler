import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login_page';
  final LoginModel model = getIt<LoginModel>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                Buttons.GoogleDark,
                padding: EdgeInsets.all(8.0),
                elevation: 8.0,
                onPressed: () async {
                  try {
                    await model.signInWithGoogle();
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
