import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class OperationDraft {
  String id;
  String patientId;
  String priority;
  String Description;

  OperationDraft({this.id, this.patientId, this.priority, this.Description});

  factory OperationDraft.fromSnapshot(DocumentSnapshot snapshot) {
    return OperationDraft(
        id: snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DRAFT_ID],
        patientId: snapshot
            .data()[Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PATIENTID],
        priority:
            snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY],
        Description: snapshot
            .data()[Constants.FIRESTORE_FIELD_OPERATION_DRAFT_DESCRIPTION]);
  }
}
