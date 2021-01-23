import 'package:flutter/material.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/view/widgets/department_card.dart';
import 'package:operation_reminder/viewmodel/verfication_model.dart';

class DepartmentSearchList extends StatelessWidget {
  final String query;
  final VerificationModel model;
  final Function(Department) onTap;

  const DepartmentSearchList(
      {Key key, this.query, @required this.model, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Department>>(
        future: model.searchDepartment(query),
        builder: (context, AsyncSnapshot<List<Department>> snapshot) {
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
                .map((department) => DepartmentCard(
                        department: department, onTap: () => onTap(department))

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

class DepartmentSearchDelegate extends SearchDelegate<Department> {
  final VerificationModel _model;

  DepartmentSearchDelegate(this._model);

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
    return DepartmentSearchList(
      query: query,
      model: _model,
      onTap: (department) {
        close(context, department);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return DepartmentSearchList(
      query: query,
      model: _model,
      onTap: (department) {
        close(context, department);
      },
    );
  }
}
