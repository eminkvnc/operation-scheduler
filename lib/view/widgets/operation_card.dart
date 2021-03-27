import 'package:flutter/material.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/home_operations_model.dart';

class OperationCard extends StatelessWidget {
  const OperationCard({
    Key key,
    @required this.operation,
    @required HomeOperationsModel model,
  })  : _model = model,
        super(key: key);

  final Operation operation;
  final HomeOperationsModel _model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.navigateToOperationDetails(operation),
      child: Card(
        margin: EdgeInsets.all(4.0),
        child: ListTile(
          tileColor: operation.priority ==
                  Constants.FIRESTORE_VALUE_PRIORITY_HIGH
              ? Colors.red
              : operation.priority == Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
                  ? Colors.yellow
                  : Colors.green,
          title: FutureBuilder(
            future: _model.getPatient(operation.patientId),
            builder: (context, AsyncSnapshot<Patient> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.name);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
