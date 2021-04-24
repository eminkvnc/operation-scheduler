import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/model/customer.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/view/screens/home_operations_page.dart';
import 'package:operation_reminder/view/widgets/operation_card.dart';
import 'package:operation_reminder/viewmodel/profile_model.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile_page';

  ProfilePageArgs args;

  ProfilePage(this.args);

  @override
  Widget build(BuildContext context) {
    ProfileModel _model = getIt<ProfileModel>();
    print(args.doctor.id);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              args.doctor.name + " " + args.doctor.surname,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<Customer>(
                future: _model.getCustomer(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Text(snapshot.data.name)
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                args.doctor.email,
                style: TextStyle(fontSize: 14),
              ),
              Text(
                args.doctor.phone,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          Text('My Operations'),
          SizedBox(height: 10),
          Expanded(
            child: RefreshViewWithFuture(
              future: _model.getOperationsWithDoctorId(args.doctor.id),
              builder: (operations) {
                return GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(
                    operations.length,
                    (index) => OperationCard(
                        operation: operations[index],
                        onTap: () => _model
                            .navigateToOperationDetails(operations[index])),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
