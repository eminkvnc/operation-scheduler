import 'package:flutter/material.dart';

class CustomerIdDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _customerId;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Please Enter CustomerID'),
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
                      decoration: InputDecoration(hintText: 'CustomerID'),
                      autofocus: true,
                      initialValue: 'PKMcp7B4B9YLrWYY80if',
                      onSaved: (customerId) => _customerId = customerId,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Id Required!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                child: Text('OK'),
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
