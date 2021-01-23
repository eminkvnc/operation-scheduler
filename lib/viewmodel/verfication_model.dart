import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/auth_service.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/view/screens/root_page.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class VerificationModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();
  AuthService _authService = getIt<AuthService>();
  Doctor doctor = Doctor();

  Future<void> saveDoctorData() async {
    doctor.id = _authService.currentUser.uid;
    doctor.isVerified = false;
    await _operationService.saveDoctorData(doctor);
    await _operationService.sendVerificationRequest(doctor.customerId);
  }

  Future<List<Department>> searchDepartment(String query) async {
    List<Department> departments = await _operationService.getDepartments();
    print(departments.length.toString());
    return departments
        .where((department) =>
            department.name.toLowerCase().contains(query.toLowerCase() ?? ''))
        .toList();
  }

  Stream<bool> checkVerificationSendStatus() {
    return _operationService.checkVerificationSendStatus();
  }

  Future<void> navigateToRootPage() async {
    navigatorService.navigateToReplace(
        routeName: RootPage.routeName,
        args: RootPageArgs(doctor: await _operationService.getCurrentDoctor()));
  }
}
