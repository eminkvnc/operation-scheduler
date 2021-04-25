import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/model/hospital.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/base_model.dart';

class AddOperationModel extends BaseModel {
  OperationService _operationService = getIt<OperationService>();

  Operation _operation;
  Patient _selectedPatient;
  Hospital _selectedHospital;
  OperationRoom _selectedRoom;
  Department _selectedDepartment;
  int _selectedDate;
  List<Doctor> _selectedDoctors;
  int _selectedPriorityIndex = -1;
  String _description;

  Future<void> addOperation() async {
    Operation operation = Operation(
        description: _description,
        priority: selectedPriorityIndex,
        customerId: (await _operationService.getCurrentDoctor()).customerId,
        patientId: _selectedPatient.id,
        date: _selectedDate,
        roomId: selectedRoom.id,
        departmentId: _selectedDepartment.id,
        hospitalId: _selectedHospital.id,
        status: Constants.FIRESTORE_VALUE_STATUS_ACTIVE,
        doctorIds: _selectedDoctors.map<String>((e) => e.id).toList());

    await _operationService.addOperation(operation);
  }

  Future<void> navigateToHome() async {
    dispose();
    navigatorService.pop();
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  Patient get selectedPatient => _selectedPatient;

  set selectedPatient(Patient value) {
    _selectedPatient = value;
    notifyListeners();
  }

  int get selectedPriorityIndex => _selectedPriorityIndex;

  set selectedPriorityIndex(int value) {
    _selectedPriorityIndex = value;
    notifyListeners();
  }

  Operation get operation => _operation;

  set operation(Operation value) {
    _operation = value;
  }

  Department get selectedDepartment => _selectedDepartment;

  set selectedDepartment(Department value) {
    _selectedDepartment = value;
  }

  Hospital get selectedHospital => _selectedHospital;

  set selectedHospital(Hospital value) {
    _selectedHospital = value;
    _selectedRoom = null;
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

  OperationRoom get selectedRoom => _selectedRoom;

  set selectedRoom(OperationRoom value) {
    _selectedRoom = value;
  }

  int get selectedDate => _selectedDate;

  set selectedDate(int value) {
    _selectedDate = value;
  }

  List<Doctor> get selectedDoctors => _selectedDoctors;

  set selectedDoctors(List<Doctor> value) {
    _selectedDoctors = value;
  }
}
