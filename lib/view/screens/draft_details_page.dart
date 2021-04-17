import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/model/department.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/model/draft.dart';
import 'package:operation_reminder/model/hospital.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/view/dialogs/department_search.dart';
import 'package:operation_reminder/view/dialogs/hospital_search.dart';
import 'package:operation_reminder/view/dialogs/room_search.dart';
import 'package:operation_reminder/view/widgets/item_loader_card.dart';
import 'package:operation_reminder/view/widgets/priority_card_list.dart';
import 'package:operation_reminder/viewmodel/draft_details_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_select/smart_select.dart';
import 'package:toast/toast.dart';

class DraftDetailsPage extends StatelessWidget {
  static const String routeName = 'edit_operation_draft_page';
  final DraftDetailsPageArgs args;
  final Draft draft;
  final PriorityCardList priorityCardList = PriorityCardList();
  DraftDetailsPage(this.args) : this.draft = args.draft;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _dateTimeTextController =
        TextEditingController();
    final TextEditingController _descriptionTextController =
        TextEditingController(text: draft.description);
    DraftDetailsModel _model = getIt<DraftDetailsModel>();
    final _formKey = GlobalKey<FormState>();
    priorityCardList.selectedPriorityIndex = draft.priority;
    // if (operation != null) {
    //   initializeDateFormatting('tr_TR', null).then((_) {
    //     DateFormat dateFormat =
    //         DateFormat("dd.MM.yyyy - HH:mm, EEEE ", 'tr_TR');
    //     _dateTimeTextController.text = dateFormat
    //         .format(DateTime.fromMillisecondsSinceEpoch(operation.date));
    //     _model.selectedDate = operation.date;
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Draft'),
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
                  future: _model.getPatient(draft.patientId),
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
                          DateFormat dateFormat =
                              DateFormat("dd.MM.yyyy - HH:mm, EEEE ", 'tr_TR');
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
                        context: context, delegate: DepartmentSearchDelegate());
                    if (department != null) {
                      _model.selectedDepartment = department;
                    }
                    return department;
                  },
                ),
                TextFormField(
                  controller: _descriptionTextController,
                  decoration: InputDecoration(hintText: 'Description'),
                  onSaved: (value) => draft.description = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Description Required!';
                    }
                    if (priorityCardList.selectedPriorityIndex == -1) {
                      return 'Please Select Priority!';
                    }
                    if (draft.patientId == null) {
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
                FutureBuilder<List<Doctor>>(
                  future: _model.getDoctors(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? SmartSelect<Doctor>.multiple(
                            title: 'Doctors',
                            value: [],
                            choiceItems: S2Choice.listFrom<Doctor, Doctor>(
                              source: snapshot.data,
                              value: (index, item) => item,
                              title: (index, item) => item.name,
                            ),
                            tileBuilder: (context, value) {
                              return S2ChipsTile.fromState(value);
                            },
                            onChange: (value) {
                              _model.selectedDoctors = value.value;
                            },
                            choiceType: S2ChoiceType.chips,
                            modalType: S2ModalType.bottomSheet,
                          )
                        : Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(height: 20),
                Container(
                  width: 180,
                  height: 50,
                  child: Expanded(
                    child: OutlinedButton(
                      child: Text('Save to Operations'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          draft.priority =
                              priorityCardList.selectedPriorityIndex;
                          _model.draft = draft;
                          await _model.addOperation();
                          await _model.navigateToHome();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
