import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Draft {
  String id;
  String patientId;
  int priority;
  String description;
  String customerId;

  Draft(
      {this.id,
      this.patientId,
      this.priority,
      this.description,
      this.customerId});

  factory Draft.fromSnapshot(DocumentSnapshot snapshot) {
    return Draft(
      id: snapshot.id,
      patientId:
          snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PATIENTID],
      priority:
          snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY],
      description: snapshot
          .data()[Constants.FIRESTORE_FIELD_OPERATION_DRAFT_DESCRIPTION],
      customerId:
          snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_OPERATION_DRAFT_ID: this.id,
      Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PATIENTID: this.patientId,
      Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY: this.priority,
      Constants.FIRESTORE_FIELD_OPERATION_DRAFT_DESCRIPTION: this.description,
      Constants.FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID: this.customerId,
    };
  }
}
