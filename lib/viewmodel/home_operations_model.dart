import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/draft.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/view/screens/add_operation_page.dart';
import 'package:operation_reminder/view/screens/operation_details_page.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class HomeOperationsModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();
  int _limit = 5;
  DocumentSnapshot _lastVisible;
  List<Operation> _operations = [];
  List<Operation> get operations => _operations;

  //TODO: Add nextPage and previouspage methods.
  //  Use local drafts list to store data locally.
  //  Listen firestore to data changes and compare with local data.
  //  Use refresh listener from ui.
  //  Use page listener from ui.

  Future<List<Operation>> getOperations() async {
    return _operationService.getOperations();
  }

  Future<Patient> getPatient(String patientId) async {
    return _operationService.getPatient(patientId);
  }

  Future<void> navigateToOperationDetails(Operation operation) async {
    return await navigatorService.navigateTo(
        routeName: OperationDetailsPage.routeName,
        args: OperationDetailsPageArgs(operation: operation));
  }
}
