import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Hospital {
  String id;
  String name;
  String phone;

  Hospital({this.id, this.name, this.phone});

  factory Hospital.fromSnapshot(DocumentSnapshot snapshot) {
    return Hospital(
        id: snapshot.data()[Constants.FIRESTORE_FIELD_PATIENT_ID],
        name: snapshot.data()[Constants.FIRESTORE_FIELD_PATIENT_NAME],
        phone: snapshot.data()[Constants.FIRESTORE_FIELD_PATIENT_PHONE]);
  }
}
