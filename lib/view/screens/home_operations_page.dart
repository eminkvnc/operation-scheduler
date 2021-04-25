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
      // body: RefreshViewWithFuture(
      //   future: _model.getOperations(),
      //   builder: (operations) {
      //     print(operations);
      //     return GridView.count(
      //       crossAxisCount: 2,
      //       children: List.generate(
      //           operations.length,
      //           (index) => OperationCard(
      //                 operation: operations[index],
      //                 onTap: () =>
      //                     _model.navigateToOperationDetails(operations[index]),
      //               )),
      //     );
      //   },
      // ),
      body: RefreshIndicator(
        onRefresh: () => _model.getOperations(),
        child: FutureBuilder<List<Operation>>(
          future: _model.getOperations(),
          builder: (context, snapshot) {
            List<Operation> operations = snapshot.data;
            return snapshot.hasData
                ? GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                        operations.length,
                        (index) => OperationCard(
                              operation: operations[index],
                              onTap: () => _model.navigateToOperationDetails(
                                  operations[index]),
                            )),
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
