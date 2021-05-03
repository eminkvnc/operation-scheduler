import 'package:flutter/material.dart';

class ItemLoaderCard<T> extends StatelessWidget {
  ItemLoaderCard({
    Key key,
    @required this.onTap,
    this.initialValue,
    this.createTitle,
    this.future,
    this.onComplete,
  }) : super(key: key);

  T initialValue;
  Future<T> future;
  Function(T) onComplete;
  String Function(T) createTitle;
  final Function onTap;

  Widget build(BuildContext context) {
    if (future != null) {
      return FutureBuilder<T>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (onComplete != null) onComplete(snapshot.data);
              initialValue = snapshot.data;
              return LoaderCard(
                onTap: onTap,
                initialValue: initialValue,
                createTitle: createTitle,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    } else {
      return LoaderCard(
        onTap: onTap,
        initialValue: initialValue,
        createTitle: createTitle,
      );
    }
  }
}

class LoaderCard<T> extends StatefulWidget {
  LoaderCard({
    Key key,
    @required this.onTap,
    this.initialValue,
    this.createTitle,
  }) : super(key: key);

  T initialValue;
  String Function(T) createTitle;

  final Function onTap;

  @override
  _LoaderCardState<T> createState() => _LoaderCardState<T>(createTitle);
}

class _LoaderCardState<T> extends State<LoaderCard> {
  String Function(T) createTitle;

  _LoaderCardState(this.createTitle);

  @override
  Widget build(BuildContext context) {
    if (createTitle == null) {
      createTitle = (T data) {
        return widget.initialValue.name;
      };
    }
    return buildLoaderCard(context);
  }

  Widget buildLoaderCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onTap: () async {
          T p = await widget.onTap();
          if (widget.initialValue != null)
            print('card ' + widget.initialValue.name);
          setState(() {
            if (p != null) widget.initialValue = p;
          });
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: widget.initialValue != null
              ? Text(createTitle(widget.initialValue)[0])
              : Icon(Icons.add),
        ),
        title: widget.initialValue != null
            ? Text(createTitle(widget.initialValue))
            : Text('Select ' + T.toString()),
        tileColor: Theme.of(context).primaryColorLight,
        contentPadding: EdgeInsets.only(
          left: 20.0,
          top: 4.0,
          bottom: 4.0,
        ),
      ),
    );
  }
}
