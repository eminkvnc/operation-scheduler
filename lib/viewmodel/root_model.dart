import 'package:operation_reminder/viewmodel/base_model.dart';

class RootModel extends BaseModel {
  int _selectedBottomNavIndex = 0;

  int get selectedBottomNavIndex => _selectedBottomNavIndex;

  set selectedBottomNavIndex(int value) {
    _selectedBottomNavIndex = value;
    notifyListeners();
  }
}
