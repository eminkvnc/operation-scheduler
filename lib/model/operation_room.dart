import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class OperationRoom {
  String id;
  String name;
  String hospitalId;

  OperationRoom({this.id, this.name, this.hospitalId});

  factory OperationRoom.fromSnapshot(DocumentSnapshot snapshot) {
    return OperationRoom(
        id: snapshot.id,
        name: snapshot.data()[Constants.FIRESTORE_FIELD_OPERATION_ROOM_NAME],
        hospitalId: snapshot
            .data()[Constants.FIRESTORE_FIELD_OPERATION_ROOM_HOSPITALID]);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_OPERATION_ROOM_ID: this.id,
      Constants.FIRESTORE_FIELD_OPERATION_ROOM_NAME: this.name,
      Constants.FIRESTORE_FIELD_OPERATION_ROOM_HOSPITALID: this.hospitalId
    };
  }
}
