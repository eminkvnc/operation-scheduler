import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Department {
  String id;
  String name;

  Department({this.id, this.name});

  factory Department.fromSnapshot(DocumentSnapshot snapshot) {
    return Department(
        id: snapshot.id,
        name: snapshot.data()[Constants.FIRESTORE_FIELD_DEPARMENT_NAME]);
  }
  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_DEPARTMENT_ID: this.id,
      Constants.FIRESTORE_FIELD_DEPARMENT_NAME: this.name
    };
  }
}
