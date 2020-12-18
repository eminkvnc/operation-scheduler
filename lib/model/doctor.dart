import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Doctor {
  String id;
  String name;
  String surname;
  String phone;
  String email;
  String grade;
  String departmentId;
  String hospitalId;

  Doctor(
      {this.id,
      this.name,
      this.surname,
      this.phone,
      this.email,
      this.grade,
      this.departmentId,
      this.hospitalId});

  factory Doctor.fromSnapshot(DocumentSnapshot snapshot) {
    return Doctor(
        id: snapshot.id,
        name: snapshot.data()[Constants.FIRESTORE_FIELD_DEPARMENT_NAME],
        surname: snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_SURNAME],
        phone: snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_PHONE],
        email: snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_EMAIL],
        grade: snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_GRADE],
        departmentId:
            snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_DEPARTMENTID],
        hospitalId:
            snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_HOSPITALID]);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.FIRESTORE_FIELD_DEPARTMENT_ID: this.id,
      Constants.FIRESTORE_FIELD_CUSTOMER_NAME: this.name,
      Constants.FIRESTORE_FIELD_DOCTOR_SURNAME: this.surname,
      Constants.FIRESTORE_FIELD_DOCTOR_PHONE: this.phone,
      Constants.FIRESTORE_FIELD_DOCTOR_EMAIL: this.email,
      Constants.FIRESTORE_FIELD_DOCTOR_GRADE: this.grade,
      Constants.FIRESTORE_FIELD_DOCTOR_DEPARTMENTID: this.departmentId,
      Constants.FIRESTORE_FIELD_DOCTOR_HOSPITALID: this.hospitalId
    };
  }
}
