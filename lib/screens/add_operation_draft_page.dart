import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/operation_service.dart';
import 'package:operation_reminder/model/operation_draft.dart';
import 'package:operation_reminder/model/patient.dart';
import 'package:operation_reminder/viewmodel/add_operation_draft_model.dart';
import 'package:provider/provider.dart';

import 'dialogs/dialog.dart';

class AddOperationDraftPage extends StatelessWidget {
  static const String routeName = '/add_operation_draft_page';

  final _formKey = GlobalKey<FormState>();

  //TODO: Hasta seçme dropdownlist hatası çözülecek.
  //TODO: Geri çıkıldığında model dispose edilecek.

  @override
  Widget build(BuildContext context) {
    AddOperationDraftModel _model =
        Provider.of<AddOperationDraftModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Draft'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  StreamBuilder<List<Patient>>(
                    stream: _model.getPatients(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Patient> patients = snapshot.data;
                        if (_model.selectedPatient != null &&
                            patients
                                .where((element) =>
                                    element.name == _model.selectedPatient.name)
                                .toList()
                                .isEmpty) _model.selectedPatient = null;
                        return Expanded(
                          child: Container(
                            child: PatientDropdownMenu(
                                model: _model, patients: patients),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Container(
                            child: DropdownButton<Patient>(
                              isExpanded: true,
                              hint: Text('Loading...'),
                              items: [],
                              onChanged: (value) {},
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  RaisedButton(
                    child: Text('Add Patient'),
                    onPressed: () async {
                      Patient patient = await showDialog(
                        context: context,
                        builder: (context) => AddDialog(),
                      );
                      if (patient != null) await _model.addPatient(patient);
                    },
                  ),
                ],
              ),
              Container(
                height: 120,
                child: PriorityCardList(model: _model),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Description'),
                onSaved: (value) => _model.description = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Description Required!';
                  }
                  return null;
                },
              ),
              RaisedButton(
                child: Text('Save Draft'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    await _model.addOperationDraft();
                    await _model.navigateToHome();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PriorityCardList extends StatefulWidget {
  const PriorityCardList({
    Key key,
    @required AddOperationDraftModel model,
  })  : _model = model,
        super(key: key);

  final AddOperationDraftModel _model;

  @override
  _PriorityCardListState createState() => _PriorityCardListState();
}

class _PriorityCardListState extends State<PriorityCardList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return PriorityCard(
          model: widget._model,
          index: index,
          onTap: () {
            setState(() {});
          },
        );
      },
    );
  }
}

class PatientDropdownMenu extends StatefulWidget {
  const PatientDropdownMenu({
    Key key,
    @required this.model,
    @required this.patients,
  });

  final AddOperationDraftModel model;
  final List<Patient> patients;

  @override
  _PatientDropdownMenuState createState() => _PatientDropdownMenuState();
}

class _PatientDropdownMenuState extends State<PatientDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Patient>(
      isExpanded: true,
      hint: Text('Hasta Seçin'),
      value: widget.model.selectedPatient,
      items: widget.patients
          .map((patient) => DropdownMenuItem(
                child: Text(patient.name),
                value: patient,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.model.selectedPatient = value;
        });
      },
    );
  }
}

class PriorityCard extends StatelessWidget {
  final int index;
  final AddOperationDraftModel model;
  final Function() onTap;
  const PriorityCard({
    Key key,
    @required this.model,
    @required this.index,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        model.selectedPriorityIndex = index;
        onTap();
      },
      child: Card(
        shape: model.selectedPriorityIndex == index
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 8))
            : null,
        elevation: model.selectedPriorityIndex == index ? 5 : 1,
        child: Container(
          width: model.selectedPriorityIndex == index ? 120 : 100,
          alignment: Alignment.center,
          padding: EdgeInsets.all(12.0),
          color: index == 0
              ? Colors.green
              : index == 1
                  ? Colors.yellow
                  : Colors.red,
          child: Text(
            index == 0
                ? 'Low'
                : index == 1
                    ? 'Medium'
                    : 'High',
          ),
        ),
      ),
    );
  }
}
