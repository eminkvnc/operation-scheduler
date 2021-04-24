import 'package:flutter/material.dart';

class ChangeCustomerDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _customerId;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Please Type Customer Id'),
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
                      decoration: InputDecoration(hintText: 'Customer Id'),
                      autofocus: true,
                      onSaved: (id) => _customerId = id,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Customer Id Required!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                child: Text('Change Customer'),
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
      Navigator.pop(context, _customerId);
    }
  }
}
