import 'package:flutter/material.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:smart_select/smart_select.dart';

class DoctorSelector extends StatelessWidget {
  final Future<List<Doctor>> _future;
  final List<String> _initialIds;
  final Function(List<Doctor> doctors) _onChange;

  const DoctorSelector(
      {Key key,
      @required Future<List<Doctor>> future,
      @required Function(List<Doctor> doctors) onChange,
      List<String> initialIds})
      : _future = future,
        _onChange = onChange,
        _initialIds = initialIds,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doctor>>(
      future: _future,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? SmartSelect<Doctor>.multiple(
                title: 'Doctors',
                value: _getPreSelectedDoctors(snapshot.data, _initialIds),
                choiceItems: S2Choice.listFrom<Doctor, Doctor>(
                  source: snapshot.data,
                  value: (index, item) => item,
                  title: (index, item) => item.name + ' ' + item.surname,
                ),
                tileBuilder: (context, value) {
                  return S2ChipsTile.fromState(value);
                },
                onChange: (value) {
                  _onChange(value.value);
                },
                choiceType: S2ChoiceType.chips,
                modalType: S2ModalType.bottomSheet,
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Doctor> _getPreSelectedDoctors(List<Doctor> doctors, List<String> ids) {
    if (ids != null && ids != null) {
      return doctors.where((element) => ids.contains(element.id)).toList();
    } else {
      return [];
    }
  }
}
