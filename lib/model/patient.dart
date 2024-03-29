import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Patient {
  String id;
  String name;
  String age;
  String phone;

  Patient({this.id, this.name, this.age, this.phone});

  factory Patient.fromSnapshot(DocumentSnapshot snapshot) {
    return Patient(
        id: snapshot.id,
        name: snapshot.data()[Constants.FIRESTORE_FIELD_PATIENT_NAME],
        age: snapshot.data()[Constants.FIRESTORE_FIELD_PATIENT_AGE],
        phone: snapshot.data()[Constants.FIRESTORE_FIELD_PATIENT_PHONE]);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_PATIENT_ID: this.id,
      Constants.FIRESTORE_FIELD_PATIENT_NAME: this.name,
      Constants.FIRESTORE_FIELD_PATIENT_AGE: this.age,
      Constants.FIRESTORE_FIELD_PATIENT_PHONE: this.phone
    };
  }
}
