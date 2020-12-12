import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: Consumer<LoginModel>(
            builder: (context, model, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(model.currentUser != null
                      ? model.currentUser.displayName
                      : 'Not signed in.'),
                  Divider(),
                  SignInButton(
                    Buttons.GoogleDark,
                    padding: EdgeInsets.all(8.0),
                    elevation: 8.0,
                    onPressed: () async {
                      await model.signInWithGoogle().catchError((error) {
                        print(error);
                      });
                      print(model.currentUser.displayName);
                      //TODO: Navigate to homepage.
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => Loading(),
                      //     ));
                    },
                  ),
                  Divider(),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await model.signOut().catchError((error) {
                        print(error);
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
