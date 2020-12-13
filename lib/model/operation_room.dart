import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Hospital {
  String id;
  String name;
  int hospitalId;

  Hospital({this.id, this.name, this.hospitalId});

  factory Hospital.fromSnapshot(DocumentSnapshot snapshot) {
    return Hospital(
        id: snapshot.data()[Constants.FIRESTORE_FIELD_HOSPITAL_ID],
        name: snapshot.data()[Constants.FIRESTORE_FIELD_HOSPITAL_NAME],
        hospitalId:
            snapshot.data()[Constants.FIRESTORE_FIELD_HOSPITAL_CUSTOMERID]);
  }
}
