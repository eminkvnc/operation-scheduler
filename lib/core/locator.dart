import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:operation_reminder/core/services/auth_service.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/viewmodel/add_operation_draft_model.dart';
import 'package:operation_reminder/viewmodel/home_drafts_model.dart';
import 'package:operation_reminder/viewmodel/home_model.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';
import 'package:operation_reminder/viewmodel/root_model.dart';
import 'package:provider/provider.dart';

GetIt getIt = GetIt.instance;

setupLocators() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<NavigatorService>(() => NavigatorService());
  getIt.registerLazySingleton<OperationService>(() => OperationService());
  getIt.registerFactory<LoginModel>(() => LoginModel());
  getIt.registerFactory<RootModel>(() => RootModel());
  getIt.registerFactory<HomeModel>(() => HomeModel());
  getIt.registerFactory<AddOperationDraftModel>(() => AddOperationDraftModel());
  getIt.registerFactory<HomeDraftsModel>(() => HomeDraftsModel());
}
