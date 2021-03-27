import 'package:operation_reminder/view/screens/add_operation_draft_page.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class RootModel extends BaseModel {
  int _selectedBottomNavIndex = 0;

  int get selectedBottomNavIndex => _selectedBottomNavIndex;

  set selectedBottomNavIndex(int value) {
    _selectedBottomNavIndex = value;
    notifyListeners();
  }

  Future<void> navigateToAddDraft() async {
    await navigatorService.navigateTo(routeName: AddDraftPage.routeName);
  }
}
