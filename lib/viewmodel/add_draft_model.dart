import 'package:flutter/material.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/draft.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class AddDraftModel extends BaseModel {
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
    Draft draft = Draft();
    draft.description = _description;
    draft.priority = selectedPriorityIndex;
    draft.customerId = (await _operationService.getCurrentDoctor()).customerId;
    draft.patientId = _selectedPatient.id;
    await _operationService.addOperationDraft(draft);
  }

  Future<List<Patient>> getPatients() async {
    return await _operationService.getPatients();
  }

  Future<void> navigateToHome() async {
    dispose();
    navigatorService.pop();
  }
}
