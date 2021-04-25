import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/model/customer.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/model/hospital.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';

class OperationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Doctor> getCurrentDoctor() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return Doctor.fromSnapshot(await _firestore
          .collection(Constants.FIRESTORE_COL_DOCTORS)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get());
    } else {
      return null;
    }
  }

  // Future<Query> getDraftsQuery() async {
  //   DocumentReference _ref = await getCurrentCustomerRef();
  //   print(_ref.path);
  //   return _ref
  //       .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
  //       .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY);
  // }

  Future<DocumentReference> getCurrentCustomerRef() async {
    Doctor doctor = await getCurrentDoctor();
    return _firestore
        .collection(Constants.FIRESTORE_COL_CUSTOMERS)
        .doc(doctor.customerId);
  }

  Future<bool> changeCustomer(String customerId) async {
    DocumentSnapshot _snapshot = await _firestore
        .collection(Constants.FIRESTORE_COL_CUSTOMERS)
        .doc(customerId)
        .get();
    if (_snapshot.exists) {
      await _firestore
          .collection(Constants.FIRESTORE_COL_DOCTORS)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({Constants.FIRESTORE_FIELD_DOCTOR_CUSTOMERID: customerId},
              SetOptions(merge: true));
      return true;
    } else {
      return false;
    }
  }
  //
  // Future<List<Draft>> getOperationDrafts() async {
  //   var _ref = (await getCurrentCustomerRef())
  //       .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
  //       .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY);
  //   return _ref.get().then(
  //       (value) => value.docs.map((doc) => Draft.fromSnapshot(doc)).toList());
  //   // return _ref.snapshots().map((event) =>
  //   //     event.docs.map((doc) => OperationDraft.fromSnapshot(doc)).toList());
  // }

  // Future<void> deleteDraft(String draftId) async {
  //   var _ref = (await getCurrentCustomerRef())
  //       .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
  //       .doc(draftId);
  //   await _ref.delete();
  // }

  Future<List<Operation>> getOperations() async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_OPERATIONS)
        .orderBy(Constants.FIRESTORE_FIELD_OPERATION_PRIORITY);
    return _ref.get().then((value) {
      return value.docs.map((doc) {
        return Operation.fromSnapshot(doc);
      }).toList();
    });
    // return _ref.snapshots().map((event) =>
    //     event.docs.map((doc) => Operation.fromSnapshot(doc)).toList());
  }

  Future<void> deleteOperation(String operationId) async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_OPERATIONS)
        .doc(operationId);
    await _ref.delete();
  }

  Future<List<Patient>> getPatients() async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_PATIENTS);
    return await _ref.get().then(
        (value) => value.docs.map((doc) => Patient.fromSnapshot(doc)).toList());
  }

  Future<Patient> getPatient(String patientId) async {
    return Patient.fromSnapshot(await (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_PATIENTS)
        .doc(patientId)
        .get());
  }

  Future<void> addPatient(Patient patient) async {
    await (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_PATIENTS)
        .doc(patient.id)
        .set(patient.toMap());
  }

  Future<void> addDepartment(Department department) async {
    await (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_DEPARTMENTS)
        .doc(department.id)
        .set(department.toMap());
  }

  Future<void> addHospital(Hospital hospital) async {
    await (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_HOSPITALS)
        .doc(hospital.id)
        .set(hospital.toMap());
  }

  Future<void> addRoom(OperationRoom room, String hospitalId) async {
    await (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_HOSPITALS)
        .doc(hospitalId)
        .collection(Constants.FIRESTORE_COL_OPERATION_ROOMS)
        .doc(room.id)
        .set(room.toMap());
  }
  //
  // Future<void> addOperationDraft(Draft draft) async {
  //   var _ref = (await getCurrentCustomerRef())
  //       .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS);
  //   await _ref.doc(draft.id).set(draft.toMap(), SetOptions(merge: true));
  // }

  Future<void> addOperation(Operation operation) async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_OPERATIONS);
    await _ref
        .doc(operation.id)
        .set(operation.toMap(), SetOptions(merge: true));
  }

  Future<void> doneOperation(Operation operation) async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_OPERATIONS);
    await _ref.doc(operation.id).set({
      Constants.FIRESTORE_FIELD_OPERATION_STATUS:
          Constants.FIRESTORE_VALUE_STATUS_DONE
    }, SetOptions(merge: true));
  }

  Future<void> saveDoctorData(Doctor doctor) async {
    await _firestore
        .collection(Constants.FIRESTORE_COL_DOCTORS)
        .doc(doctor.id)
        .set(doctor.toMap(), SetOptions(merge: true));
  }

  Future<bool> checkVerification() async {
    DocumentSnapshot snapshot = await _firestore
        .collection(Constants.FIRESTORE_COL_DOCTORS)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    return snapshot.exists && snapshot['is_verified'] == true;
  }

  Stream<bool> checkVerificationSendStatus() {
    return _firestore
        .collection(Constants.FIRESTORE_COL_DOCTORS)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((event) => event['is_verified']);
  }

  // Future<void> sendVerificationRequest(String customerId) async {
  //   Doctor doctor = await getCurrentDoctor();
  //   await _firestore
  //       .collection(Constants.FIRESTORE_COL_VERIFICATION_REQUESTS)
  //       .doc()
  //       .set({
  //     'customer_id': customerId,
  //     'doctor_id': doctor.id,
  //     'verified': false,
  //   });
  // }

  Future<List<Department>> getDepartments() async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_DEPARTMENTS);
    return await _ref.get().then((value) =>
        value.docs.map((doc) => Department.fromSnapshot(doc)).toList());
  }

  Future<List<Hospital>> getHospitals() async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_HOSPITALS);
    return await _ref.get().then((value) =>
        value.docs.map((doc) => Hospital.fromSnapshot(doc)).toList());
  }

  Future<List<OperationRoom>> getRoomsWithHospitalId(String hospitalId) async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_HOSPITALS)
        .doc(hospitalId)
        .collection(Constants.FIRESTORE_COL_OPERATION_ROOMS);
    return await _ref.get().then((value) => value.docs.map((doc) {
          OperationRoom r = OperationRoom.fromSnapshot(doc);
          r.hospitalId = hospitalId;
          return r;
        }).toList());
  }

  Future<Hospital> getHospital(String hospitalId) async {
    return Hospital.fromSnapshot(await (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_HOSPITALS)
        .doc(hospitalId)
        .get());
  }

  Future<OperationRoom> getRoom(String roomId, String hospitalId) async {
    return OperationRoom.fromSnapshot(await (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_HOSPITALS)
        .doc(hospitalId)
        .collection(Constants.FIRESTORE_COL_OPERATION_ROOMS)
        .doc(roomId)
        .get());
  }

  Future<Department> getDepartment(String departmentId) async {
    return Department.fromSnapshot(await (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_DEPARTMENTS)
        .doc(departmentId)
        .get());
  }

  Future<Customer> getCustomer() async {
    return Customer.fromSnapshot(await (await getCurrentCustomerRef()).get());
  }

  Future<Doctor> getDoctorWithId(String doctorId) async {
    DocumentSnapshot _snapshot = await _firestore
        .collection(Constants.FIRESTORE_COL_DOCTORS)
        .doc(doctorId)
        .get();
    return _snapshot.exists ? Doctor.fromSnapshot(_snapshot) : null;
  }

  Stream<Doctor> getDoctorStream() {
    return FirebaseAuth.instance.currentUser != null
        ? _firestore
            .collection(Constants.FIRESTORE_COL_DOCTORS)
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots()
            .map((event) => Doctor.fromSnapshot(event))
        : Stream.empty();
  }

  Future<List<Doctor>> getDoctors() async {
    String customerId = (await getCurrentCustomerRef()).id;
    var _ref = _firestore.collection(Constants.FIRESTORE_COL_DOCTORS);
    return await _ref.where('customer_id', isEqualTo: customerId).get().then(
        (value) => value.docs.map((doc) => Doctor.fromSnapshot(doc)).toList());
  }
}
