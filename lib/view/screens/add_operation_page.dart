import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/hospital.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/view/dialogs/department_search.dart';
import 'package:operation_reminder/view/dialogs/hospital_search.dart';
import 'package:operation_reminder/view/dialogs/patient_search.dart';
import 'package:operation_reminder/view/dialogs/room_search.dart';
import 'package:operation_reminder/view/widgets/doctor_selector.dart';
import 'package:operation_reminder/view/widgets/item_loader_card.dart';
import 'package:operation_reminder/view/widgets/priority_card_list.dart';
import 'package:operation_reminder/viewmodel/add_operation_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toast/toast.dart';

class AddOperationPage extends StatelessWidget {
  static const String routeName = 'add_operation_page';
  final PriorityCardList priorityCardList = PriorityCardList();
  @override
  Widget build(BuildContext context) {
    final TextEditingController _dateTimeTextController =
        TextEditingController();
    final TextEditingController _descriptionTextController =
        TextEditingController();
    final FocusNode _focusNode = FocusNode();
    AddOperationModel _model = getIt<AddOperationModel>();
    final _formKey = GlobalKey<FormState>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Operation'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ItemLoaderCard<Patient>(
                    initialValue: _model.selectedPatient,
                    onTap: () async {
                      Patient patient = await showSearch<Patient>(
                          context: context, delegate: PatientSearchDelegate());
                      if (patient != null) {
                        _model.selectedPatient = patient;
                      }
                      return patient;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    height: 120,
                    child: priorityCardList,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Select Date - Time'),
                    controller: _dateTimeTextController,
                    readOnly: true,
                    validator: (value) {
                      if (_model.selectedDate == null) {
                        return 'Please Select Date!';
                      }
                      return null;
                    },
                    onTap: () {
                      DatePicker.showDateTimePicker(
                        context,
                        minTime: DateTime.now(),
                        maxTime: DateTime.now().add(Duration(days: 50 * 365)),
                        currentTime: DateTime.now(),
                        locale: LocaleType.tr,
                        showTitleActions: true,
                        onConfirm: (time) async {
                          initializeDateFormatting('tr_TR', null).then((_) {
                            DateFormat dateFormat = DateFormat(
                                "dd.MM.yyyy - HH:mm, EEEE ", 'tr_TR');
                            _dateTimeTextController.text =
                                dateFormat.format(time);
                          });
                          _model.selectedDate = time.millisecondsSinceEpoch;
                        },
                      );
                    },
                  ),
                  ItemLoaderCard<Hospital>(
                    onComplete: (h) => _model.selectedHospital = h,
                    onTap: () async {
                      Hospital hospital = await showSearch<Hospital>(
                          context: context, delegate: HospitalSearchDelegate());
                      if (hospital != null) {
                        _model.selectedHospital = hospital;
                      }
                      return hospital;
                    },
                  ),
                  ItemLoaderCard<OperationRoom>(
                    onComplete: (r) => _model.selectedRoom = r,
                    onTap: () async {
                      if (_model.selectedHospital != null) {
                        OperationRoom room = await showSearch<OperationRoom>(
                            context: context,
                            delegate:
                                RoomSearchDelegate(_model.selectedHospital.id));
                        if (room != null) {
                          _model.selectedRoom = room;
                        }
                        return room;
                      } else {
                        Toast.show('Please Select Hospital First!', context,
                            duration: Toast.LENGTH_LONG);
                        return null;
                      }
                    },
                  ),
                  ItemLoaderCard<Department>(
                    onComplete: (d) => _model.selectedDepartment = d,
                    onTap: () async {
                      Department department = await showSearch<Department>(
                          context: context,
                          delegate: DepartmentSearchDelegate());
                      if (department != null) {
                        _model.selectedDepartment = department;
                      }
                      return department;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionTextController,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Description',
                    ),
                    onSaved: (value) => _model.description = value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Description Required!';
                      }
                      if (priorityCardList.selectedPriorityIndex == -1) {
                        return 'Please Select Priority!';
                      }
                      if (_model.selectedPatient == null) {
                        return 'Please Select Patient!';
                      }
                      if (_model.selectedHospital == null) {
                        return 'Please Select Hospital!';
                      }
                      if (_model.selectedRoom == null) {
                        return 'Please Select Room!';
                      }
                      if (_model.selectedDepartment == null) {
                        return 'Please Select Department!';
                      }
                      if (_model.selectedDoctors == null ||
                          _model.selectedDoctors.isEmpty) {
                        return 'Please Select Doctor!';
                      }
                      return null;
                    },
                  ),
                  DoctorSelector(
                    future: _model.getDoctors(),
                    onChange: (doctors) {
                      _model.selectedDoctors = doctors;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 180,
                        height: 50,
                        child: Expanded(
                          child: OutlinedButton(
                            child: Text('Save to Operations'),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _model.selectedPriorityIndex =
                                    priorityCardList.selectedPriorityIndex;
                                await _model.addOperation();
                                await _model.navigateToHome();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
