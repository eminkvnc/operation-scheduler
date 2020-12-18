import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/operation_draft.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/home_drafts_model.dart';

class HomeDraftsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeDraftsModel _model = getIt<HomeDraftsModel>();
    return Scaffold(
      body: StreamBuilder(
        stream: _model.getDrafts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OperationDraft> drafts = snapshot.data;
            return ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: drafts.length,
              itemBuilder: (context, index) {
                OperationDraft draft = drafts[index];
                return Card(
                  margin: EdgeInsets.all(4.0),
                  child: ListTile(
                    tileColor: draft.priority ==
                            Constants.FIRESTORE_VALUE_PRIORITY_HIGH
                        ? Colors.red
                        : draft.priority ==
                                Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
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
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
