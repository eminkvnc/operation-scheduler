import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Doctor {
  String id;
  String name;
  String surname;
  String phone;
  String email;
  String grade;
  String DepartmentId;
  String HospitalId;

  Doctor(
      {this.id,
      this.name,
      this.surname,
      this.phone,
      this.email,
      this.grade,
      this.DepartmentId,
      this.HospitalId});

  factory Doctor.fromSnapshot(DocumentSnapshot snapshot) {
    return Doctor(
        id: snapshot.data()[Constants.FIRESTORE_FIELD_DEPARTMENT_ID],
        name: snapshot.data()[Constants.FIRESTORE_FIELD_DEPARMENT_NAME],
        surname: snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_SURNAME],
        phone: snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_PHONE],
        email: snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_EMAIL],
        grade: snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_GRADE],
        DepartmentId:
            snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_DEPARTMENTID],
        HospitalId:
            snapshot.data()[Constants.FIRESTORE_FIELD_DOCTOR_HOSPITALID]);
  }
}
