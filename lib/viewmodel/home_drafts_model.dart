import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/operation_draft.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class HomeDraftsModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();
  int _limit = 5;
  DocumentSnapshot _lastVisible;
  List<OperationDraft> _drafts = [];
  List<OperationDraft> get drafts => _drafts;

  //TODO: Add nextPage and previouspage methods.
  //  Use local drafts list to store data locally.
  //  Listen firestore to data changes and compare with local data.
  //  Use refresh listener from ui.
  //  Use page listener from ui.

  Future<List<OperationDraft>> getDrafts() async {
    return _operationService.getOperationDrafts();
  }

  // Future<List<OperationDraft>> getNextOperationDraftsPage() async {
  //   List<QueryDocumentSnapshot> docs = await _operationService
  //       .getNextOperationDraftsPage(_lastVisible, _limit);
  //   _lastVisible = docs.last;
  //   List<OperationDraft> pageData = docs.map((doc) {
  //     return OperationDraft.fromSnapshot(doc);
  //   }).toList();
  //   _drafts.addAll(pageData);
  //   return pageData;
  // }
  //
  // Future<bool> refreshData() async {
  //   _lastVisible = null;
  //   _drafts.clear();
  //   return true;
  // }

  Query getDraftsQuery() {
    return _operationService.getDraftsQuery();
  }

  Future<Patient> getPatient(String patientId) async {
    return _operationService.getPatient(patientId);
  }
}
