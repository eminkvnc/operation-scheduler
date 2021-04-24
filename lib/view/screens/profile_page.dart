import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/model/customer.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/view/dialogs/change_customer_dialog.dart';
import 'package:operation_reminder/view/screens/home_operations_page.dart';
import 'package:operation_reminder/view/widgets/operation_card.dart';
import 'package:operation_reminder/viewmodel/profile_model.dart';
import 'package:toast/toast.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile_page';

  ProfilePageArgs args;

  ProfilePage(this.args);

  @override
  Widget build(BuildContext context) {
    ProfileModel _model = getIt<ProfileModel>();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 400,
              child: Divider(
                thickness: 1,
                color: Colors.black12,
              )),
          Center(
            child: Text(
              args.doctor.name + " " + args.doctor.surname,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              width: 400,
              child: Divider(
                thickness: 1,
                color: Colors.black12,
              )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder<Customer>(
                  future: _model.getCustomer(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Text('Customer: ' + snapshot.data.name)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
                TextButton(
                  onPressed: () async {
                    String customerId = await showDialog(
                        context: context,
                        builder: (context) => ChangeCustomerDialog());
                    bool _customerExists =
                        await _model.changeCustomer(customerId);
                    if (_customerExists) {
                      args.doctor.customerId = customerId;
                      Toast.show('Customer successfully changed.', context,
                          duration: Toast.LENGTH_LONG);
                    } else {
                      Toast.show('Cannot find customer!', context,
                          duration: Toast.LENGTH_LONG);
                    }
                  },
                  child: Text('Change Customer'),
                ),
              ],
            ),
          ),
          Container(
              width: 400,
              child: Divider(
                thickness: 1,
                color: Colors.black12,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Email: ' + args.doctor.email,
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Phone: ' + args.doctor.phone,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          Container(
              width: 400,
              child: Divider(
                thickness: 1,
                color: Colors.black12,
              )),
          Container(
            margin: EdgeInsets.all(4.0),
            padding: EdgeInsets.all(2.0),
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            child: Text(
              'My Operations',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          // Container(
          //     width: 400,
          //     child: Divider(
          //       thickness: 3,
          //       color: Theme.of(context).primaryColor,
          //     )),
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
