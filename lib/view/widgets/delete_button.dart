import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key key,
    @required Function() onDelete,
    @required String title,
  })  : _onDelete = onDelete,
        _title = title,
        super(key: key);

  final Function() _onDelete;
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 50,
      color: Colors.red,
      child: Expanded(
        child: OutlinedButton(
          child: Text(
            'Delete $_title',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            bool isDeleted = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
                title: Text('Do you want to delete this $_title?'),
                actions: [
                  OutlinedButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop<bool>(true);
                    },
                  ),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop<bool>(false);
                    },
                  ),
                ],
              ),
            );
            if (isDeleted) {
              await _onDelete();
            }
          },
        ),
      ),
    );
  }
}
