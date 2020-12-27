import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/model/customer.dart';
import 'package:operation_reminder/model/operation_draft.dart';
import 'package:operation_reminder/model/patient.dart';

class OperationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Customer getCurrentCustomer() {
    return Customer(id: 'PKMcp7B4B9YLrWYY80if', name: 'test_costomer_1');
  }

  Query getDraftsQuery() {
    return getCurrentCustomerRef()
        .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
        .where(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID,
            isEqualTo: getCurrentCustomer().id)
        .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY);
  }

  DocumentReference getCurrentCustomerRef() {
    return _firestore
        .collection(Constants.FIRESTORE_COL_CUSTOMERS)
        .doc(getCurrentCustomer().id);
  }

  Future<List<OperationDraft>> getOperationDrafts() async {
    var _ref = getCurrentCustomerRef()
        .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
        .where(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID,
            isEqualTo: getCurrentCustomer().id)
        .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY);
    return _ref.get().then((value) =>
        value.docs.map((doc) => OperationDraft.fromSnapshot(doc)).toList());
    // return _ref.snapshots().map((event) =>
    //     event.docs.map((doc) => OperationDraft.fromSnapshot(doc)).toList());
  }

  Future<List<QueryDocumentSnapshot>> getNextOperationDraftsPage(
      DocumentSnapshot lastVisible, int limit) async {
    var _ref = (lastVisible != null)
        ? getCurrentCustomerRef()
            .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
            .where(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID,
                isEqualTo: getCurrentCustomer().id)
            .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY)
            .limit(limit)
            .startAfterDocument(lastVisible)
        : getCurrentCustomerRef()
            .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS)
            .where(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID,
                isEqualTo: getCurrentCustomer().id)
            .orderBy(Constants.FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY)
            .limit(limit);
    return _ref.get().then((value) => value.docs);
    // return _ref.snapshots().map((event) =>
    //     event.docs.map((doc) => OperationDraft.fromSnapshot(doc)).toList());
  }

  Future<List<Patient>> getPatients() async {
    var _ref =
        getCurrentCustomerRef().collection(Constants.FIRESTORE_COL_PATIENTS);
    return await _ref.get().then(
        (value) => value.docs.map((doc) => Patient.fromSnapshot(doc)).toList());
  }

  Future<Patient> getPatient(String patientId) async {
    return Patient.fromSnapshot(await getCurrentCustomerRef()
        .collection(Constants.FIRESTORE_COL_PATIENTS)
        .doc(patientId)
        .get());
  }

  Future<void> addPatient(Patient patient) async {
    await getCurrentCustomerRef()
        .collection(Constants.FIRESTORE_COL_PATIENTS)
        .doc(patient.id)
        .set(patient.toMap());
  }

  Future<void> addOperationDraft(OperationDraft draft) async {
    var _ref = getCurrentCustomerRef()
        .collection(Constants.FIRESTORE_COL_OPERATION_DRAFTS);
    await _ref.add(draft.toMap());
  }
}
