import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/model/operation_draft.dart';

class Operation extends OperationDraft {
  String date;
  String roomId;
  String departmentId;

  Operation({this.date, this.roomId, this.departmentId});

  factory Operation.fromSnapshot(DocumentSnapshot snapshot) {
    return Operation(
        date: snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DATE],
        roomId: snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_ROOMID],
        departmentId:
            snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DEPARTMENTID]);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_OPERATION_DATE: this.date,
      Constants.FIRESTORE_FIELD_OPERATION_ROOMID: this.roomId,
      Constants.FIRESTORE_FIELD_OPERATION_DEPARTMENTID: this.departmentId
    }..addAll(super.toMap());
  }
}
