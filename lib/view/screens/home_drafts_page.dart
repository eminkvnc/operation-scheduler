import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/operation_draft.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/home_drafts_model.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class HomeDraftsPage extends StatelessWidget {
  final PaginateRefreshedChangeListener _refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    HomeDraftsModel _model = getIt<HomeDraftsModel>();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshChangeListener.refreshed = true;
        },
        child: PaginateFirestore(
          listeners: [
            _refreshChangeListener,
          ],
          itemBuilderType: PaginateBuilderType.listView,
          query: _model.getDraftsQuery(),
          itemsPerPage: 5,
          itemBuilder: (index, context, documentSnapshot) {
            OperationDraft draft =
                OperationDraft.fromSnapshot(documentSnapshot);
            return OperationDraftCard(draft: draft, model: _model);
          },
        ),
      ),
    );
  }
}

class OperationDraftCard extends StatelessWidget {
  const OperationDraftCard({
    Key key,
    @required this.draft,
    @required HomeDraftsModel model,
  })  : _model = model,
        super(key: key);

  final OperationDraft draft;
  final HomeDraftsModel _model;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
