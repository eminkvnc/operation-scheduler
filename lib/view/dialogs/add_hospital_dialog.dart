import 'package:flutter/material.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/hospital.dart';

class AddHospitalDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Hospital _hospital = Hospital();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add New Hospital'),
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
                      onSaved: (name) => _hospital.name = name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name Required!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                child: Text('Add Hospital'),
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
      Navigator.pop(context, _hospital);
    }
  }
}
