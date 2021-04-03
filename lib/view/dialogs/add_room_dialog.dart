import 'package:flutter/material.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';

class AddRoomDialog extends StatelessWidget {
  final String _hospitalId;
  AddRoomDialog(this._hospitalId);

  final _formKey = GlobalKey<FormState>();
  final OperationRoom _room = OperationRoom();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add New Room'),
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
                      onSaved: (name) {
                        _room.name = name;
                        _room.hospitalId = _hospitalId;
                      },
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
                child: Text('Add Room to Hospital'),
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
      Navigator.pop(context, _room);
    }
  }
}
