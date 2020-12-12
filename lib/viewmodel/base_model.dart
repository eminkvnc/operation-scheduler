import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';

abstract class BaseModel with ChangeNotifier {
  bool _busy = false;

  final NavigatorService navigatorService = getIt<NavigatorService>();

  bool get busy => _busy;

  set busy(bool value) {
    _busy = value;
    notifyListeners();
  }
}