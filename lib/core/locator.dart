import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:operation_reminder/core/services/auth_service.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';
import 'package:operation_reminder/viewmodel/root_model.dart';

GetIt getIt = GetIt.instance;

setupLocators() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton(() => NavigatorService());
  getIt.registerFactory<LoginModel>(() => LoginModel());
  getIt.registerFactory<RootModel>(() => RootModel());
}
