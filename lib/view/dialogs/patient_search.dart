import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/view/dialogs/add_patient_dialog.dart';
import 'package:operation_reminder/view/widgets/item_loader_card.dart';
import 'package:operation_reminder/viewmodel/search_model.dart';

class PatientSearchList extends StatelessWidget {
  final String query;
  final Function(Patient) onTap;

  const PatientSearchList({Key key, this.query, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchModel model = getIt<SearchModel>();
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
                .map(
                  (patient) => ItemLoaderCard<Patient>(
                    initialValue: patient,
                    onTap: () => onTap(patient),
                    createTitle: (item) => item.name + '(${item.age})',
                  ),
                )
                .toList()),
          );
        },
      ),
    );
  }
}

class PatientSearchDelegate extends SearchDelegate<Patient> {
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
      onTap: (patient) {
        close(context, patient);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return PatientSearchList(
      query: query,
      onTap: (patient) {
        close(context, patient);
      },
    );
  }
}
