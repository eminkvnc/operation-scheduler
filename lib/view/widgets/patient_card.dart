import 'package:flutter/material.dart';
import 'package:operation_reminder/model/patient.dart';

class PatientCard extends StatefulWidget {
  PatientCard({
    Key key,
    @required this.onTap,
    this.patient,
  }) : super(key: key);

  Patient patient;
  final Function onTap;

  @override
  _PatientCardState createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () async {
          Patient p = await widget.onTap();
          if (widget.patient != null) print('card ' + widget.patient.name);
          setState(() {
            widget.patient = p;
          });
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: widget.patient != null
              ? Text(widget.patient.name[0])
              : Icon(Icons.add),
        ),
        title: widget.patient != null
            ? Text(widget.patient.name)
            : Text('Select Patient'),
        tileColor: Theme.of(context).primaryColorLight,
        contentPadding: EdgeInsets.only(
          left: 20.0,
          top: 4.0,
          bottom: 4.0,
        ),
      ),
    );

    // return ListTile(
    //   onTap: (patient) async {
    //     setState(() {
    //       widget.onTap();
    //     });
    //   },
    //   leading: CircleAvatar(
    //     backgroundColor: Theme.of(context).accentColor,
    //     child: widget._model.selectedPatient != null
    //         ? Text(widget._model.selectedPatient.name[0])
    //         : Icon(Icons.add),
    //   ),
    //   title: widget._model.selectedPatient != null
    //       ? Text(widget._model.selectedPatient.name)
    //       : Text('Select Patient'),
    //   tileColor: Theme.of(context).primaryColorLight,
    //   contentPadding: EdgeInsets.only(
    //     left: 20.0,
    //     top: 4.0,
    //     bottom: 4.0,
    //   ),
    // );
  }
}
