import 'package:flutter/material.dart';

class ItemLoaderCard<T> extends StatelessWidget {
  ItemLoaderCard({
    Key key,
    @required this.onTap,
    this.initialValue,
    this.future,
    this.onComplete,
  }) : super(key: key);

  T initialValue;
  Future<T> future;
  Function(T) onComplete;
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
      );
    }
  }
}

class LoaderCard<T> extends StatefulWidget {
  LoaderCard({
    Key key,
    @required this.onTap,
    this.initialValue,
  }) : super(key: key);

  T initialValue;

  final Function onTap;

  @override
  _LoaderCardState<T> createState() => _LoaderCardState();
}

class _LoaderCardState<T> extends State<LoaderCard> {
  @override
  Widget build(BuildContext context) {
    return buildLoaderCard(context);
  }

  Card buildLoaderCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: ListTile(
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
              ? Text(widget.initialValue.name[0])
              : Icon(Icons.add),
        ),
        title: widget.initialValue != null
            ? Text(widget.initialValue.name)
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
