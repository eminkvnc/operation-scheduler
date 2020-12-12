import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/constants.dart';

class Customer {
  String id;
  String name;

  Customer({this.id, this.name});

  factory Customer.fromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
        id: snapshot.data()[Constants.FIRESTORE_FIELD_CUSTOMER_ID],
        name: snapshot.data()[Constants.FIRESTORE_FIELD_CUSTOMER_NAME]);
  }
}
