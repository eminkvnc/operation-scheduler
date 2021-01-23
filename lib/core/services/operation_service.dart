import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/model/operation_draft.dart';
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

  Future<Query> getDraftsQuery() async {
    DocumentReference _ref = await getCurrentCustomerRef();
    print(_ref.path);
    return _ref
        .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
        .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY);
  }

  Future<DocumentReference> getCurrentCustomerRef() async {
    Doctor doctor = await getCurrentDoctor();
    return _firestore
        .collection(Constants.FIRESTORE_COL_CUSTOMERS)
        .doc(doctor.customerId);
  }

  Future<List<OperationDraft>> getOperationDrafts() async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
        .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY);
    return _ref.get().then((value) =>
        value.docs.map((doc) => OperationDraft.fromSnapshot(doc)).toList());
    // return _ref.snapshots().map((event) =>
    //     event.docs.map((doc) => OperationDraft.fromSnapshot(doc)).toList());
  }

  Future<List<QueryDocumentSnapshot>> getNextOperationDraftsPage(
      DocumentSnapshot lastVisible, int limit) async {
    Doctor doctor = await getCurrentDoctor();
    var _ref = (lastVisible != null)
        ? (await getCurrentCustomerRef())
            .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
            .where(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID,
                isEqualTo: doctor.customerId)
            .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY)
            .limit(limit)
            .startAfterDocument(lastVisible)
        : (await getCurrentCustomerRef())
            .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
            .where(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID,
                isEqualTo: doctor.customerId)
            .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY)
            .limit(limit);
    return _ref.get().then((value) => value.docs);
    // return _ref.snapshots().map((event) =>
    //     event.docs.map((doc) => OperationDraft.fromSnapshot(doc)).toList());
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

  Future<void> addOperationDraft(OperationDraft draft) async {
    var _ref = (await getCurrentCustomerRef())
        .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS);
    await _ref.add(draft.toMap());
  }

  Future<Doctor> getDoctorWithId(String doctorId) async {
    DocumentSnapshot _snapshot = await _firestore
        .collection(Constants.FIRESTORE_COL_DOCTORS)
        .doc(doctorId)
        .get();
    return _snapshot.exists ? Doctor.fromSnapshot(_snapshot) : null;
  }

  Future<void> saveDoctorData(Doctor doctor) async {
    await _firestore
        .collection(Constants.FIRESTORE_COL_DOCTORS)
        .doc()
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

  Future<void> sendVerificationRequest(String customerId) async {
    Doctor doctor = await getCurrentDoctor();
    await _firestore
        .collection(Constants.FIRESTORE_COL_VERIFICATION_REQUESTS)
        .doc()
        .set({
      'customer_id': customerId,
      'doctor_id': doctor.id,
      'verified': false,
    });
  }

  Future<List<Department>> getDepartments() async {
    var _ref = _firestore.collection(Constants.FIRESTORE_COL_DEPARTMENTS);
    return await _ref.get().then((value) =>
        value.docs.map((doc) => Department.fromSnapshot(doc)).toList());
  }
}
