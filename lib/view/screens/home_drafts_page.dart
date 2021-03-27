import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/draft.dart';
import 'package:operation_reminder/view/widgets/operation_draft_card.dart';
import 'package:operation_reminder/viewmodel/home_drafts_model.dart';

class HomeDraftsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeDraftsModel _model = getIt<HomeDraftsModel>();
    return Scaffold(
      body: RefreshViewWithFuture(
        model: _model,
        builder: (drafts) {
          return GridView.count(
            crossAxisCount: 2,
            children: List.generate(
                drafts.length,
                (index) =>
                    OperationDraftCard(draft: drafts[index], model: _model)),
          );
        },
      ),
    );
  }
}

class RefreshViewWithFuture extends StatefulWidget {
  const RefreshViewWithFuture({
    Key key,
    @required HomeDraftsModel model,
    @required Widget Function(List<Draft>) builder,
  })  : _builder = builder,
        _model = model,
        super(key: key);

  final HomeDraftsModel _model;
  final Widget Function(List<Draft>) _builder;

  @override
  _RefreshViewWithFutureState createState() => _RefreshViewWithFutureState();
}

class _RefreshViewWithFutureState extends State<RefreshViewWithFuture> {
  Future _future;

  @override
  Widget build(BuildContext context) {
    _future = widget._model.getDrafts();
    return RefreshIndicator(
      onRefresh: () async {
        _future = widget._model.getDrafts();
        setState(() {});
      },
      child: FutureBuilder<List<Draft>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return widget._builder(snapshot.data);
              // return PaginateFirestore(
              //   listeners: [
              //     _refreshChangeListener,
              //   ],
              //   itemBuilderType: PaginateBuilderType.listView,
              //   query: snapshot.data,
              //   itemsPerPage: 5,
              //   itemBuilder: (index, context, documentSnapshot) {
              //     Draft draft = Draft.fromSnapshot(documentSnapshot);
              //     return OperationDraftCard(draft: draft, model: _model);
              //   },
              // );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
