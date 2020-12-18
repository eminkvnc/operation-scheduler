import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/operation_draft.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class HomeDraftsModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();

  Stream<List<OperationDraft>> getDrafts() {
    return _operationService.getOperationDrafts();
  }

  Future<Patient> getPatient(String patientId) async {
    return _operationService.getPatient(patientId);
  }
}
