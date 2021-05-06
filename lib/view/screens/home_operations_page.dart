import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/view/widgets/operation_card.dart';
import 'package:operation_reminder/view/widgets/sortable_list.dart';
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
            if (snapshot.hasData) {
              List<Operation> operations = snapshot.data;
              return SortableExpandableList<Operation>(
                list: operations,
                sortTitles: ['Priority', 'Date'],
                sortOptions: [
                  (e1, e2) => e1.priority.compareTo(e2.priority),
                  (e1, e2) => e2.priority.compareTo(e1.priority),
                  (e1, e2) => DateTime.fromMillisecondsSinceEpoch(e1.date)
                      .compareTo(DateTime.fromMillisecondsSinceEpoch(e2.date)),
                  (e1, e2) => DateTime.fromMillisecondsSinceEpoch(e2.date)
                      .compareTo(DateTime.fromMillisecondsSinceEpoch(e1.date)),
                ],
                itemBuilder: (index, isExpanded) {
                  return OperationCard(
                    isExpanded: isExpanded,
                    operation: operations[index],
                    onTap: () =>
                        _model.navigateToOperationDetails(operations[index]),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // return snapshot.hasData
            //     ? GridView.count(
            //         crossAxisCount: 2,
            //         children: List.generate(
            //             operations.length,
            //             (index) => OperationCard(
            //                   operation: operations[index],
            //                   onTap: () => _model.navigateToOperationDetails(
            //                       operations[index]),
            //                 )),
            //       )
            //     : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
