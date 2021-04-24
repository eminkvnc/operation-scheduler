import 'package:flutter/material.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:smart_select/smart_select.dart';

class DoctorSelector extends StatelessWidget {
  final dynamic _model;

  const DoctorSelector({Key key, @required dynamic model})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doctor>>(
      future: _model.getDoctors(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? SmartSelect<Doctor>.multiple(
                title: 'Doctors',
                value: _getPreSelectedDoctors(_model, snapshot),
                choiceItems: S2Choice.listFrom<Doctor, Doctor>(
                  source: snapshot.data,
                  value: (index, item) => item,
                  title: (index, item) => item.name + ' ' + item.surname,
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
    );
  }

  List<Doctor> _getPreSelectedDoctors(
      dynamic model, AsyncSnapshot<List<Doctor>> snapshot) {
    if (model.operation != null && model.operation.doctorIds != null) {
      model.selectedDoctors = snapshot.data
          .where((element) => model.operation.doctorIds.contains(element.id))
          .toList();
      return snapshot.data
          .where((element) => model.operation.doctorIds.contains(element.id))
          .toList();
    } else {
      return [];
    }
  }
}
