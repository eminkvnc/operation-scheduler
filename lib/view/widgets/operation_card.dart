import 'package:flutter/material.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/model/patient.dart';

class OperationCard extends StatelessWidget {
  OperationCard({
    Key key,
    @required this.operation,
    @required this.onTap,
  }) : super(key: key);

  final Operation operation;
  final Function onTap;
  final OperationService _operationService = getIt<OperationService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        margin: EdgeInsets.all(4.0),
        child: ListTile(
          tileColor: operation.status != Constants.FIRESTORE_VALUE_STATUS_DONE
              ? operation.priority == Constants.FIRESTORE_VALUE_PRIORITY_HIGH
                  ? Colors.red
                  : operation.priority ==
                          Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
                      ? Colors.yellow
                      : Colors.green
              : Colors.grey,
          title: FutureBuilder(
            future: _operationService.getPatient(operation.patientId),
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
