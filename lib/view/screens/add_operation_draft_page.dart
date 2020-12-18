import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/add_operation_draft_model.dart';

import '../dialogs/patient_search.dart';
import '../widgets/patient_card.dart';
import '../widgets/priority_card_list.dart';

class AddOperationDraftPage extends StatelessWidget {
  static const String routeName = '/add_operation_draft_page';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AddOperationDraftModel _model = getIt<AddOperationDraftModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Draft'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PatientCard(
                patient: _model.selectedPatient,
                onTap: () async {
                  Patient patient = await showSearch<Patient>(
                      context: context,
                      delegate: PatientSearchDelegate(_model));
                  if (patient != null) {
                    _model.selectedPatient = patient;
                  }
                  return patient;
                },
              ),
              Container(
                padding: EdgeInsets.all(12.0),
                height: 120,
                child: PriorityCardList(model: _model),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Description'),
                onSaved: (value) => _model.description = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Description Required!';
                  }
                  if (_model.selectedPriorityIndex == -1) {
                    return 'Please Select Priority!';
                  }
                  if (_model.selectedPatient == null) {
                    return 'Please Select Patient!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Container(
                width: 100,
                height: 50,
                child: Expanded(
                  child: OutlinedButton(
                    child: Text('Save Draft'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        await _model.addOperationDraft();
                        await _model.navigateToHome();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
