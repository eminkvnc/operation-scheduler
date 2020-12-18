import 'package:flutter/material.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/view/dialogs/add_patient_dialog.dart';
import 'package:operation_reminder/view/widgets/patient_card.dart';
import 'package:operation_reminder/viewmodel/add_operation_draft_model.dart';

class PatientSearchList extends StatelessWidget {
  final String query;
  final AddOperationDraftModel model;
  final Function(Patient) onTap;

  const PatientSearchList(
      {Key key, this.query, @required this.model, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Patient patient = await showDialog(
            context: context,
            builder: (context) => AddPatientDialog(),
          );
          if (patient != null) await model.addPatient(patient);
          await model.searchPatient('');
        },
      ),
      body: FutureBuilder(
        future: model.searchPatient(query),
        builder: (context, AsyncSnapshot<List<Patient>> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );

          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          return ListView(
            padding: EdgeInsets.all(8.0),
            children: []..addAll(snapshot.data
                .map((patient) => PatientCard(
                        patient: patient, onTap: () => onTap(patient))

                    //     Card(
                    //   margin: EdgeInsets.all(4.0),
                    //   child: ListTile(
                    //     onTap: () => onTap(patient),
                    //     leading: CircleAvatar(
                    //       backgroundColor: Theme.of(context).accentColor,
                    //       child: Text(patient.name[0]),
                    //     ),
                    //     title: Text(patient.name),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       side: BorderSide(
                    //         color: Theme.of(context).primaryColor,
                    //         width: 4,
                    //       ),
                    //     ),
                    //     tileColor: Theme.of(context).primaryColorLight,
                    //   ),
                    // ),
                    )
                .toList()),
          );
        },
      ),
    );
  }
}

class PatientSearchDelegate extends SearchDelegate<Patient> {
  final AddOperationDraftModel _model;

  PatientSearchDelegate(this._model);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return PatientSearchList(
      query: query,
      model: _model,
      onTap: (patient) {
        close(context, patient);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return PatientSearchList(
      query: query,
      model: _model,
      onTap: (patient) {
        close(context, patient);
      },
    );
  }
}
