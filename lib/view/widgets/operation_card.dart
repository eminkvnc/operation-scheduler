import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';

class OperationCard extends StatelessWidget {
  OperationCard({
    Key key,
    @required this.operation,
    @required this.onTap,
    this.isExpanded = true,
  }) : super(key: key);

  final bool isExpanded;
  final Operation operation;
  final Function onTap;
  final OperationService _operationService = getIt<OperationService>();

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? GestureDetector(
            onTap: () => onTap(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: operation.status != Constants.FIRESTORE_VALUE_STATUS_DONE
                    ? operation.priority ==
                            Constants.FIRESTORE_VALUE_PRIORITY_HIGH
                        ? Colors.red
                        : operation.priority ==
                                Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
                            ? Colors.yellow
                            : Colors.green
                    : Colors.grey,
              ),
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.all(8.0),
              // color: operation.status != Constants.FIRESTORE_VALUE_STATUS_DONE
              //     ? operation.priority == Constants.FIRESTORE_VALUE_PRIORITY_HIGH
              //         ? Colors.red
              //         : operation.priority ==
              //                 Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
              //             ? Colors.yellow
              //             : Colors.green
              //     : Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: _operationService.getPatient(operation.patientId),
                    builder: (context, AsyncSnapshot<Patient> snapshot) {
                      return snapshot.hasData
                          ? Text(
                              snapshot.data.name + '(${snapshot.data.age})',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                  FutureBuilder(
                    future: initializeDateFormatting('tr_TR', null),
                    builder: (context, snapshot) => Text(
                      DateFormat("dd.MM.yyyy\nHH:mm, EEEE", 'tr_TR')
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              operation.date))
                          .toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FutureBuilder<OperationRoom>(
                    future: _operationService.getRoom(
                        operation.roomId, operation.hospitalId),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? Text(snapshot.data.name)
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                  FutureBuilder<Doctor>(
                    future: _operationService
                        .getDoctorWithId(operation.doctorIds.first),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? Text(
                              snapshot.data.name + ' ' + snapshot.data.surname)
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () => onTap(),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: operation.status != Constants.FIRESTORE_VALUE_STATUS_DONE
                    ? operation.priority ==
                            Constants.FIRESTORE_VALUE_PRIORITY_HIGH
                        ? Colors.red
                        : operation.priority ==
                                Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
                            ? Colors.yellow
                            : Colors.green
                    : Colors.grey,
              ),
              child: FutureBuilder(
                future: _operationService.getPatient(operation.patientId),
                builder: (context, AsyncSnapshot<Patient> snapshot) {
                  return snapshot.hasData
                      ? Text(
                          snapshot.data.name + '(${snapshot.data.age})',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          );
  }
}
