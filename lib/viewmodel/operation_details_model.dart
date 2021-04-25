import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/model/draft.dart';
import 'package:operation_reminder/model/hospital.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class OperationDetailsModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();

  Operation _operation;
  // Patient _selectedPatient;
  // int _selectedPriorityIndex = -1;
  // String _description;
  // Hospital _selectedHospital;
  // OperationRoom _selectedRoom;
  // Department _selectedDepartment;
  // int _selectedDate;
  // List<Doctor> _selectedDoctors;

  Future<void> editOperation() async {
    // _operation.patientId = _selectedPatient.id;
    // _operation.description = _description;
    // _operation.priority = _selectedPriorityIndex;
    // _operation.date = _selectedDate;
    // _operation.roomId = selectedRoom.id;
    // _operation.departmentId = _selectedDepartment.id;
    // _operation.hospitalId = _selectedHospital.id;
    // _operation.doctorIds = _selectedDoctors.map<String>((e) => e.id).toList();

    await _operationService.addOperation(operation);
  }

  Future<void> deleteOperation(String operationId) async {
    await _operationService.deleteOperation(operationId);
  }

  Future<void> doneOperation() async {
    await _operationService.doneOperation(operation);
  }

  Future<void> navigateToHome() async {
    dispose();
    navigatorService.pop();
  }

  Operation get operation => _operation;

  set operation(Operation value) {
    _operation = value;
  }

  Future<Patient> getPatient(String patientId) async {
    return _operationService.getPatient(patientId);
  }

  Future<Hospital> getHospital(String hospitalId) async {
    return _operationService.getHospital(hospitalId);
  }

  Future<OperationRoom> getRoom(String roomId, String hospitalId) async {
    return _operationService.getRoom(roomId, hospitalId);
  }

  Future<Department> getDepartment(String departmentId) async {
    return _operationService.getDepartment(departmentId);
  }

  Future<List<Doctor>> getDoctors() async {
    return _operationService.getDoctors();
  }

// Department get selectedDepartment => _selectedDepartment;
//
// set selectedDepartment(Department value) {
//   _selectedDepartment = value;
// }
//
// Hospital get selectedHospital => _selectedHospital;
//
// set selectedHospital(Hospital value) {
//   _selectedHospital = value;
//   _selectedRoom = null;
// }
  // OperationRoom get selectedRoom => _selectedRoom;
  //
  // set selectedRoom(OperationRoom value) {
  //   _selectedRoom = value;
  // }
  //
  // int get selectedDate => _selectedDate;
  //
  // set selectedDate(int value) {
  //   _selectedDate = value;
  // }
  //
  // List<Doctor> get selectedDoctors => _selectedDoctors;
  //
  // set selectedDoctors(List<Doctor> value) {
  //   _selectedDoctors = value;
  // }
  //
  // Patient get selectedPatient => _selectedPatient;
  //
  // set selectedPatient(Patient value) {
  //   _selectedPatient = value;
  // }
  //
  // int get selectedPriorityIndex => _selectedPriorityIndex;
  //
  // set selectedPriorityIndex(int value) {
  //   _selectedPriorityIndex = value;
  // }
  //
  // String get description => _description;
  //
  // set description(String value) {
  //   _description = value;
  // }
}
