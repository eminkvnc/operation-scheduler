import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Operation {
  String date;
  String roomId;
  String deparmentId;

  Operation({this.date, this.roomId, this.deparmentId});

  factory Operation.fromSnapshot(DocumentSnapshot snapshot) {
    return Operation(
        date: snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DATE],
        roomId: snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_ROOMID],
        deparmentId:
            snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_DEPARTMENTID]);
  }
}
