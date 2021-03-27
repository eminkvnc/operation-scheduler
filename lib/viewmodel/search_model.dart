import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/hospital.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class SearchModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();
  Future<List<Department>> searchDepartment(String query) async {
    List<Department> departments = await _operationService.getDepartments();
    print(departments.length.toString());
    return departments
        .where((department) =>
            department.name.toLowerCase().contains(query.toLowerCase() ?? ''))
        .toList();
  }

  Future<List<Patient>> searchPatient(String query) async {
    List<Patient> patients = await _operationService.getPatients();
    return patients
        .where((patient) =>
            patient.name.toLowerCase().contains(query.toLowerCase() ?? ''))
        .toList();
  }

  Future<List<Hospital>> searchHospital(String query) async {
    List<Hospital> hospitals = await _operationService.getHospitals();
    return hospitals
        .where((patient) =>
            patient.name.toLowerCase().contains(query.toLowerCase() ?? ''))
        .toList();
  }

  Future<List<OperationRoom>> searchRoom(
      String query, String hospitalId) async {
    List<OperationRoom> rooms =
        await _operationService.getRoomsWithHospitalId(hospitalId);
    return rooms
        .where((room) =>
            room.name.toLowerCase().contains(query.toLowerCase() ?? ''))
        .toList();
  }

  Future<void> addPatient(Patient patient) async {
    await _operationService.addPatient(patient);
  }
}
