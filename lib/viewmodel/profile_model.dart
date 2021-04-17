import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/customer.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/view/screens/draft_details_page.dart';
import 'package:operation_reminder/view/screens/operation_details_page.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class ProfileModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();

  Future<List<Operation>> getOperationsWithDoctorId(String doctorId) async {
    List<Operation> operations = await _operationService.getOperations();
    print(operations.length);
    return operations
        .where((element) => element.doctorIds.contains(doctorId))
        .toList();
  }

  Future<Department> getDepartment(String departmentId) {
    return _operationService.getDepartment(departmentId);
  }

  Future<Customer> getCustomer() {
    return _operationService.getCustomer();
  }

  Future<void> navigateToOperationDetails(Operation operation) async {
    return await navigatorService.navigateTo(
        routeName: OperationDetailsPage.routeName,
        args: OperationDetailsPageArgs(operation: operation));
  }
}
