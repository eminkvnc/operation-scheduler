import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/viewmodel/verification_model.dart';

class VerificationPage extends StatelessWidget {
  static const String routeName = 'verification_page';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    VerificationModel _model = getIt<VerificationModel>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('VerificationPage')),
        body: StreamBuilder<bool>(
            stream: _model.checkVerificationSendStatus(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Form(
                      key: _key,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: 'PKMcp7B4B9YLrWYY80if',
                              decoration:
                                  InputDecoration(hintText: 'Customer Id'),
                              validator: (value) =>
                                  value.isEmpty ? 'Type customer Id!' : null,
                              onSaved: (newValue) =>
                                  _model.doctor.customerId = newValue,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Name'),
                              validator: (value) =>
                                  value.isEmpty ? 'Type name!' : null,
                              onSaved: (newValue) =>
                                  _model.doctor.name = newValue,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Surname'),
                              validator: (value) =>
                                  value.isEmpty ? 'Type surname!' : null,
                              onSaved: (newValue) =>
                                  _model.doctor.surname = newValue,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Phone'),
                              validator: (value) =>
                                  value.isEmpty ? 'Type phone!' : null,
                              onSaved: (newValue) =>
                                  _model.doctor.phone = newValue,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              validator: (value) =>
                                  value.isEmpty ? 'Type email!' : null,
                              onSaved: (newValue) =>
                                  _model.doctor.email = newValue,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Grade'),
                              validator: (value) {
                                return value.isEmpty ? 'Type grade' : null;
                              },
                              onSaved: (newValue) =>
                                  _model.doctor.grade = newValue,
                            ),
                            FlatButton(
                              onPressed: () async {
                                if (_key.currentState.validate()) {
                                  _key.currentState.save();
                                  await _model.saveDoctorData();
                                }
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : snapshot.data
                      ? FutureBuilder(
                          future: _model.navigateToRootPage(),
                          builder: (context, snapshot) {
                            return Center(child: CircularProgressIndicator());
                          },
                        )
                      : Text('Waiting for approval...');
            }),
      ),
    );
  }
}
