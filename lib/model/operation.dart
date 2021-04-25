import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/model/draft.dart';

class Operation {
  String id;
  String patientId;
  int priority;
  String description;
  String customerId;
  int date;
  String roomId;
  String departmentId;
  String hospitalId;
  int status;
  List<String> doctorIds;

  Operation(
      {this.id,
      this.patientId,
      this.priority,
      this.description,
      this.customerId,
      this.date,
      this.roomId,
      this.departmentId,
      this.hospitalId,
      this.status,
      this.doctorIds});

  factory Operation.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    Operation operation = Operation(
        id: snapshot.id,
        patientId: data[Constants.FIRESTORE_FIELD_OPERATION_PATIENTID],
        priority: data[Constants.FIRESTORE_FIELD_OPERATION_PRIORITY],
        description: data[Constants.FIRESTORE_FIELD_OPERATION_DESCRIPTION],
        customerId: data[Constants.FIRESTORE_FIELD_OPERATION_CUSTOMERID],
        date: data[Constants.FIRESTORE_FIELD_OPERATION_DATE],
        roomId: data[Constants.FIRESTORE_FIELD_OPERATION_ROOMID],
        hospitalId: data[Constants.FIRESTORE_FIELD_OPERATION_HOSPITALID],
        departmentId: data[Constants.FIRESTORE_FIELD_OPERATION_DEPARTMENTID],
        status: data[Constants.FIRESTORE_FIELD_OPERATION_STATUS]);
    if (data[Constants.FIRESTORE_FIELD_OPERATION_DOCTOR_IDS] != null)
      operation.doctorIds =
          List.from(data[Constants.FIRESTORE_FIELD_OPERATION_DOCTOR_IDS]);
    return operation;
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_OPERATION_ID: this.id,
      Constants.FIRESTORE_FIELD_OPERATION_PATIENTID: this.patientId,
      Constants.FIRESTORE_FIELD_OPERATION_PRIORITY: this.priority,
      Constants.FIRESTORE_FIELD_OPERATION_DESCRIPTION: this.description,
      Constants.FIRESTORE_FIELD_OPERATION_CUSTOMERID: this.customerId,
      Constants.FIRESTORE_FIELD_OPERATION_DATE: this.date,
      Constants.FIRESTORE_FIELD_OPERATION_ROOMID: this.roomId,
      Constants.FIRESTORE_FIELD_OPERATION_DEPARTMENTID: this.departmentId,
      Constants.FIRESTORE_FIELD_OPERATION_HOSPITALID: this.hospitalId,
      Constants.FIRESTORE_FIELD_OPERATION_STATUS: this.status,
      Constants.FIRESTORE_FIELD_OPERATION_DOCTOR_IDS: this.doctorIds,
    };
  }
}
