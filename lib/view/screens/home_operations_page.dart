import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/view/widgets/operation_card.dart';
import 'package:operation_reminder/viewmodel/home_operations_model.dart';

class HomeOperationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeOperationsModel _model = getIt<HomeOperationsModel>();
    return Scaffold(
      body: RefreshViewWithFuture(
        model: _model,
        builder: (operations) {
          print(operations);
          return GridView.count(
            crossAxisCount: 2,
            children: List.generate(
                operations.length,
                (index) =>
                    OperationCard(operation: operations[index], model: _model)),
          );
        },
      ),
    );
  }
}

class RefreshViewWithFuture extends StatefulWidget {
  const RefreshViewWithFuture({
    Key key,
    @required HomeOperationsModel model,
    @required Widget Function(List<Operation>) builder,
  })  : _builder = builder,
        _model = model,
        super(key: key);

  final HomeOperationsModel _model;
  final Widget Function(List<Operation>) _builder;

  @override
  _RefreshViewWithFutureState createState() => _RefreshViewWithFutureState();
}

class _RefreshViewWithFutureState extends State<RefreshViewWithFuture> {
  Future _future;

  @override
  Widget build(BuildContext context) {
    _future = widget._model.getOperations();
    return RefreshIndicator(
      onRefresh: () async {
        _future = widget._model.getOperations();
        setState(() {});
      },
      child: FutureBuilder<List<Operation>>(
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
