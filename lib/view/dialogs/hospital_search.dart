import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/hospital.dart';
import 'package:operation_reminder/view/widgets/item_loader_card.dart';
import 'package:operation_reminder/viewmodel/search_model.dart';

import 'add_hospital_dialog.dart';

class HospitalSearchList extends StatelessWidget {
  final String query;
  final Function(Hospital) onTap;

  const HospitalSearchList({Key key, this.query, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchModel model = getIt<SearchModel>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Hospital hospital = await showDialog(
            context: context,
            builder: (context) => AddHospitalDialog(),
          );
          if (hospital != null) await model.addHospital(hospital);
          await model.searchHospital('');
        },
      ),
      body: FutureBuilder(
        future: model.searchHospital(query),
        builder: (context, AsyncSnapshot<List<Hospital>> snapshot) {
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
                .map((hospital) => ItemLoaderCard<Hospital>(
                        initialValue: hospital, onTap: () => onTap(hospital))

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

class HospitalSearchDelegate extends SearchDelegate<Hospital> {
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
    return HospitalSearchList(
      query: query,
      onTap: (patient) {
        close(context, patient);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return HospitalSearchList(
      query: query,
      onTap: (patient) {
        close(context, patient);
      },
    );
  }
}
