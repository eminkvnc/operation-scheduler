import 'package:flutter/material.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/operation_draft.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class AddOperationDraftModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();

  int _selectedPriorityIndex = -1;
  Patient _selectedPatient;
  String _description;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  Patient get selectedPatient => _selectedPatient;

  set selectedPatient(Patient value) {
    _selectedPatient = value;
    notifyListeners();
  }

  int get selectedPriorityIndex => _selectedPriorityIndex;

  set selectedPriorityIndex(int value) {
    _selectedPriorityIndex = value;
    notifyListeners();
  }

  Future<void> addOperationDraft() async {
    print('index: ' + selectedPriorityIndex.toString());
    OperationDraft draft = OperationDraft();
    draft.description = _description;
    draft.priority = selectedPriorityIndex == 0
        ? Constants.FIRESTORE_VALUE_PRIORITY_LOW
        : selectedPriorityIndex == 1
            ? Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
            : Constants.FIRESTORE_VALUE_PRIORITY_HIGH;
    draft.customerId = _operationService.getCurrentCustomer().id;
    draft.patientId = _selectedPatient.id;
    await _operationService.addOperationDraft(draft);
  }

  Future<List<Patient>> getPatients() async {
    return await _operationService.getPatients();
  }

  Future<List<Patient>> searchPatient(String query) async {
    List<Patient> patients = await _operationService.getPatients();
    return patients
        .where((patient) =>
            patient.name.toLowerCase().contains(query.toLowerCase() ?? ''))
        .toList();
  }

  Future<void> addPatient(Patient patient) async {
    await _operationService.addPatient(patient);
  }

  Future<void> navigateToHome() async {
    dispose();
    navigatorService.pop();
  }
}
