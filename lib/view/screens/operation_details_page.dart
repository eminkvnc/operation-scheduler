import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:operation_reminder/core/constants.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/model/hospital.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/view/dialogs/department_search.dart';
import 'package:operation_reminder/view/dialogs/hospital_search.dart';
import 'package:operation_reminder/view/dialogs/room_search.dart';
import 'package:operation_reminder/view/widgets/delete_button.dart';
import 'package:operation_reminder/view/widgets/doctor_selector.dart';
import 'package:operation_reminder/view/widgets/item_loader_card.dart';
import 'package:operation_reminder/view/widgets/priority_card_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:operation_reminder/viewmodel/operation_details_model.dart';
import 'package:smart_select/smart_select.dart';
import 'package:toast/toast.dart';

class OperationDetailsPage extends StatelessWidget {
  static const String routeName = 'edit_operation_page';
  final OperationDetailsPageArgs args;
  final PriorityCardList priorityCardList = PriorityCardList();
  OperationDetailsPage(this.args);
  @override
  Widget build(BuildContext context) {
    OperationDetailsModel _model = getIt<OperationDetailsModel>();
    _model.operation = args.operation;
    final TextEditingController _dateTimeTextController =
        TextEditingController();
    final TextEditingController _descriptionTextController =
        TextEditingController(text: _model.operation.description);
    final FocusNode _focusNode = FocusNode();
    final _formKey = GlobalKey<FormState>();
    priorityCardList.selectedPriorityIndex = _model.operation.priority;
    if (_model.operation != null) {
      initializeDateFormatting('tr_TR', null).then((_) {
        DateFormat dateFormat =
            DateFormat("dd.MM.yyyy - HH:mm, EEEE ", 'tr_TR');
        _dateTimeTextController.text = dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(_model.operation.date));
        _model.operation.date = _model.operation.date;
      });
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Operation'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: IgnorePointer(
                  ignoring: _model.operation.status ==
                      Constants.FIRESTORE_VALUE_STATUS_DONE,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ItemLoaderCard<Patient>(
                          future: _model.getPatient(_model.operation.patientId),
                          onTap: () {
                            return null;
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(12.0),
                          height: 120,
                          child: priorityCardList,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Select Date - Time'),
                          controller: _dateTimeTextController,
                          readOnly: true,
                          validator: (value) {
                            if (_model.operation.date == null) {
                              return 'Please Select Date!';
                            }
                            return null;
                          },
                          onTap: () {
                            DatePicker.showDateTimePicker(
                              context,
                              minTime: DateTime.now(),
                              maxTime:
                                  DateTime.now().add(Duration(days: 50 * 365)),
                              currentTime: DateTime.now(),
                              locale: LocaleType.tr,
                              showTitleActions: true,
                              onConfirm: (time) async {
                                initializeDateFormatting('tr_TR', null)
                                    .then((_) {
                                  DateFormat dateFormat = DateFormat(
                                      "dd.MM.yyyy - HH:mm, EEEE ", 'tr_TR');
                                  _dateTimeTextController.text =
                                      dateFormat.format(time);
                                });
                                _model.operation.date =
                                    time.millisecondsSinceEpoch;
                              },
                            );
                          },
                        ),
                        ItemLoaderCard<Hospital>(
                          future: _model.operation != null
                              ? _model.getHospital(_model.operation.hospitalId)
                              : null,
                          onComplete: (h) => _model.operation.hospitalId = h.id,
                          onTap: () async {
                            Hospital hospital = await showSearch<Hospital>(
                                context: context,
                                delegate: HospitalSearchDelegate());
                            if (hospital != null) {
                              _model.operation.hospitalId = hospital.id;
                            }
                            return hospital;
                          },
                        ),
                        ItemLoaderCard<OperationRoom>(
                          future: _model.operation != null
                              ? _model.getRoom(_model.operation.roomId,
                                  _model.operation.hospitalId)
                              : null,
                          onComplete: (r) => _model.operation.roomId = r.id,
                          onTap: () async {
                            if (_model.operation.hospitalId != null) {
                              OperationRoom room =
                                  await showSearch<OperationRoom>(
                                      context: context,
                                      delegate: RoomSearchDelegate(
                                          _model.operation.hospitalId));
                              if (room != null) {
                                _model.operation.roomId = room.id;
                              }
                              return room;
                            } else {
                              Toast.show(
                                  'Please Select Hospital First!', context,
                                  duration: Toast.LENGTH_LONG);
                              return null;
                            }
                          },
                        ),
                        ItemLoaderCard<Department>(
                          future: _model.operation != null
                              ? _model
                                  .getDepartment(_model.operation.departmentId)
                              : null,
                          onComplete: (d) =>
                              _model.operation.departmentId = d.id,
                          onTap: () async {
                            Department department =
                                await showSearch<Department>(
                                    context: context,
                                    delegate: DepartmentSearchDelegate());
                            if (department != null) {
                              _model.operation.departmentId = department.id;
                            }
                            return department;
                          },
                        ),
                        TextFormField(
                          focusNode: _focusNode,
                          controller: _descriptionTextController,
                          minLines: 1,
                          maxLines: 5,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          decoration: InputDecoration(hintText: 'Description'),
                          onSaved: (value) =>
                              _model.operation.description = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Description Required!';
                            }
                            if (priorityCardList.selectedPriorityIndex == -1) {
                              return 'Please Select Priority!';
                            }
                            if (_model.operation.patientId == null) {
                              return 'Please Select Patient!';
                            }
                            if (_model.operation.hospitalId == null) {
                              return 'Please Select Hospital!';
                            }
                            if (_model.operation.roomId == null) {
                              return 'Please Select Room!';
                            }
                            if (_model.operation.departmentId == null) {
                              return 'Please Select Department!';
                            }
                            if (_model.operation.doctorIds == null ||
                                _model.operation.doctorIds.isEmpty) {
                              return 'Please Select Doctor!';
                            }
                            return null;
                          },
                        ),
                        DoctorSelector(
                          future: _model.getDoctors(),
                          onChange: (doctors) => _model.operation.doctorIds =
                              doctors.map((e) => e.id).toList(),
                          initialIds: _model.operation.doctorIds,
                        ),
                        SizedBox(height: 20),
                        _model.operation.status !=
                                Constants.FIRESTORE_VALUE_STATUS_DONE
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 50,
                                    child: Expanded(
                                      child: OutlinedButton(
                                        child: Text('Save Changes'),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            _model.operation.priority =
                                                priorityCardList
                                                    .selectedPriorityIndex;
                                            _model.operation = _model.operation;
                                            await _model.editOperation();
                                            await _model.navigateToHome();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 50,
                                    color: Colors.black26,
                                    child: Expanded(
                                      child: OutlinedButton(
                                        child: Text(
                                          'Done Operation',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () async {
                                          await _model.doneOperation();
                                          await _model.navigateToHome();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              DeleteButton(
                title: 'Operation',
                onDelete: () async {
                  await _model.deleteOperation(_model.operation.id);
                  await _model.navigateToHome();
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
