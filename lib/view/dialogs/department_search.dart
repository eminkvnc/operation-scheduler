import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/view/dialogs/add_department_dialog.dart';
import 'package:operation_reminder/view/widgets/item_loader_card.dart';
import 'package:operation_reminder/viewmodel/search_model.dart';

class DepartmentSearchList extends StatelessWidget {
  final String query;
  final Function(Department) onTap;
  const DepartmentSearchList({Key key, this.query, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchModel _model = getIt<SearchModel>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Department department = await showDialog(
            context: context,
            builder: (context) => AddDepartmentDialog(),
          );
          if (department != null) await _model.addDepartment(department);
          await _model.searchDepartment('');
        },
      ),
      body: FutureBuilder<List<Department>>(
        future: _model.searchDepartment(query),
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
                .map((department) => ItemLoaderCard<Department>(
                        initialValue: department,
                        onTap: () => onTap(department))

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
      onTap: (department) {
        close(context, department);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return DepartmentSearchList(
      query: query,
      onTap: (department) {
        close(context, department);
      },
    );
  }
}
