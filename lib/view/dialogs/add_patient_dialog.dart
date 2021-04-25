import 'package:flutter/material.dart';
import 'package:operation_reminder/model/patient.dart';

class AddPatientDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Patient _patient = Patient();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add New Patient'),
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Name'),
                      autofocus: true,
                      onSaved: (name) => _patient.name = name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name Required!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Age'),
                      autofocus: true,
                      onSaved: (age) => _patient.age = age,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Age Required!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Phone'),
                      autofocus: true,
                      onSaved: (phone) => _patient.phone = phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Phone Required!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                child: Text('Add Patient'),
                onPressed: () => _saveForm(context),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _saveForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context, _patient);
    }
  }
}
