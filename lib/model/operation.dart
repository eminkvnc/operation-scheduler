import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/model/draft.dart';

class Operation extends Draft {
  int date;
  String roomId;
  String departmentId;
  String hospitalId;
  List<String> doctorIds;

  Operation(
      {this.date,
      this.roomId,
      this.departmentId,
      this.hospitalId,
      this.doctorIds,
      Draft draft})
      : super(
            id: draft.id,
            priority: draft.priority,
            description: draft.description,
            customerId: draft.customerId,
            patientId: draft.patientId);

  factory Operation.fromSnapshot(DocumentSnapshot snapshot) {
    Draft draft = Draft.fromSnapshot(snapshot);
    Operation operation = Operation(draft: draft);
    operation.date = snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DATE];
    operation.roomId =
        snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_ROOMID];
    operation.hospitalId =
        snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_HOSPITALID];
    operation.departmentId =
        snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DEPARTMENTID];
    if (snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DOCTOR_IDS] != null)
      operation.doctorIds = List.from(
          snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DOCTOR_IDS]);
    return operation;
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_OPERATION_DATE: this.date,
      Constants.FIRESTORE_FIELD_OPERATION_ROOMID: this.roomId,
      Constants.FIRESTORE_FIELD_OPERATION_DEPARTMENTID: this.departmentId,
      Constants.FIRESTORE_FIELD_OPERATION_HOSPITALID: this.hospitalId,
      Constants.FIRESTORE_FIELD_OPERATION_DOCTOR_IDS: this.doctorIds,
    }..addAll(super.toMap());
  }
}
