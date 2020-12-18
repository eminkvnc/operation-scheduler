import 'package:flutter/material.dart';
import 'package:operation_reminder/viewmodel/add_operation_draft_model.dart';

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
                side:
                    BorderSide(color: Theme.of(context).primaryColor, width: 4))
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
