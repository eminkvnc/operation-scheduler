import 'package:flutter/material.dart';

class SortButton extends StatefulWidget {
  Function() onTap;
  final String title;
  final bool state;
  final Color color;

  SortButton(
      {Key key, this.onTap, this.title = '', this.state = true, this.color})
      : super(key: key);

  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  @override
  void initState() {
    super.initState();
    state = widget.state;
  }

  bool state;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          setState(() {
            state = !state;
          });
        },
        child: Row(children: [
          Text(widget.title),
          Icon(
            state
                ? Icons.arrow_drop_up_outlined
                : Icons.arrow_drop_down_outlined,
            size: 20,
            color: state ? Colors.green : Colors.red,
          ),
        ]),
      ),
    );
  }
}
