import 'package:flutter/material.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/patient.dart';

class AddDepartmentDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Department _department = Department();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add New Department'),
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
                      onSaved: (name) => _department.name = name,
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
                child: Text('Add Department'),
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
      Navigator.pop(context, _department);
    }
  }
}
