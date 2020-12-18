import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: ListView.builder(
          itemCount: model.doctors.lenght,
          itemBuilder: (context, index) {
            return Text('test');
          },
        ),
      ),
    );
  }
}
