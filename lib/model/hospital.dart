import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Hospital {
  String id;
  String name;
  String costumerId;

  Hospital({this.id, this.name, this.costumerId});

  factory Hospital.fromSnapshot(DocumentSnapshot snapshot) {
    return Hospital(
        id: snapshot.id,
        name: snapshot.data()[Constants.FIRESTORE_FIELD_HOSPITAL_NAME],
        costumerId:
            snapshot.data()[Constants.FIRESTORE_FIELD_HOSPITAL_CUSTOMERID]);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_HOSPITAL_ID: this.id,
      Constants.FIRESTORE_FIELD_HOSPITAL_NAME: this.name,
      Constants.FIRESTORE_FIELD_HOSPITAL_CUSTOMERID: this.costumerId
    };
  }
}
