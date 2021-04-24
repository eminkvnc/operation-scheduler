import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/view/screens/add_operation_draft_page.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class RootModel extends BaseModel {
  int _selectedBottomNavIndex = 0;
  Doctor _doctor;

  OperationService _operationService = getIt<OperationService>();

  Doctor get doctor => _doctor;

  set doctor(Doctor value) {
    _doctor = value;
    notifyListeners();
  }

  Stream<Doctor> getDoctorStream() {
    return _operationService.getDoctorStream();
  }

  int get selectedBottomNavIndex => _selectedBottomNavIndex;

  set selectedBottomNavIndex(int value) {
    _selectedBottomNavIndex = value;
    notifyListeners();
  }

  Future<void> navigateToAddDraft() async {
    await navigatorService.navigateTo(routeName: AddDraftPage.routeName);
  }
}
