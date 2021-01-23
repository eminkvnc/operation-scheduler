import 'package:flutter/material.dart';
import 'package:operation_reminder/model/department.dart';

class DepartmentCard extends StatefulWidget {
  DepartmentCard({
    Key key,
    @required this.onTap,
    this.department,
  }) : super(key: key);

  Department department;
  final Function onTap;

  @override
  _DepartmentCardState createState() => _DepartmentCardState();
}

class _DepartmentCardState extends State<DepartmentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () async {
          Department d = await widget.onTap();
          if (widget.department != null)
            print('card ' + widget.department.name);
          setState(() {
            widget.department = d;
          });
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: widget.department != null
              ? Text(widget.department.name[0])
              : Icon(Icons.add),
        ),
        title: widget.department != null
            ? Text(widget.department.name)
            : Text('Select Department'),
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
