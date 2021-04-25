import 'package:flutter/material.dart';
import 'package:operation_reminder/core/constants.dart';

class PriorityCardList extends StatefulWidget {
  PriorityCardList({
    Key key,
    this.selectedPriorityIndex,
  }) : super(key: key);

  int selectedPriorityIndex = -1;

  @override
  _PriorityCardListState createState() => _PriorityCardListState();
}

class _PriorityCardListState extends State<PriorityCardList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: PriorityCard(
            index: 0,
            selectedIndex: widget.selectedPriorityIndex,
            onTap: (selectedPriorityIndex) {
              setState(() {
                widget.selectedPriorityIndex = selectedPriorityIndex;
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: PriorityCard(
            index: 1,
            selectedIndex: widget.selectedPriorityIndex,
            onTap: (selectedPriorityIndex) {
              setState(() {
                widget.selectedPriorityIndex = selectedPriorityIndex;
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: PriorityCard(
            index: 2,
            selectedIndex: widget.selectedPriorityIndex,
            onTap: (selectedPriorityIndex) {
              setState(() {
                widget.selectedPriorityIndex = selectedPriorityIndex;
              });
            },
          ),
        ),
      ],
    );
  }
}

class PriorityCard extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  final int selectedIndex;
  const PriorityCard({
    Key key,
    @required this.index,
    @required this.onTap,
    @required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(index);
      },
      child: Card(
        shape: selectedIndex == index
            ? RoundedRectangleBorder(
                side:
                    BorderSide(color: Theme.of(context).primaryColor, width: 4))
            : null,
        elevation: selectedIndex == index ? 5 : 1,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(12.0),
          color: index == Constants.FIRESTORE_VALUE_PRIORITY_LOW
              ? Colors.green
              : index == Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
                  ? Colors.yellow
                  : Colors.red,
          child: Text(
            index == Constants.FIRESTORE_VALUE_PRIORITY_LOW
                ? 'Low\nPriority'
                : index == Constants.FIRESTORE_VALUE_PRIORITY_NORMAL
                    ? 'Medium\nPriority'
                    : 'High\nPriority',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selectedIndex == index ? Colors.white : Colors.black,
              fontSize: selectedIndex == index ? 18 : 12,
            ),
          ),
        ),
      ),
    );
  }
}
