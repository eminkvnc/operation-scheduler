import 'package:flutter/material.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/model/draft.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/home_drafts_model.dart';

class OperationDraftCard extends StatelessWidget {
  const OperationDraftCard({
    Key key,
    @required this.draft,
    @required HomeDraftsModel model,
  })  : _model = model,
        super(key: key);

  final Draft draft;
  final HomeDraftsModel _model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.navigateToOperationDraftDetails(draft),
      child: Card(
        margin: EdgeInsets.all(4.0),
        child: ListTile(
          tileColor: draft.priority == Constants.FIRESTORE_VALUE_PRIORITY_HIGH
              ? Colors.red
              : draft.priority == Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
                  ? Colors.yellow
                  : Colors.green,
          title: FutureBuilder(
            future: _model.getPatient(draft.patientId),
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
