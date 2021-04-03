import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/model/operation_room.dart';
import 'package:operation_reminder/view/widgets/item_loader_card.dart';
import 'package:operation_reminder/viewmodel/search_model.dart';

import 'add_room_dialog.dart';

class RoomSearchList extends StatelessWidget {
  final String query;
  final String hospitalId;
  final Function(OperationRoom) onTap;

  const RoomSearchList(
      {Key key, this.query, this.hospitalId, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchModel model = getIt<SearchModel>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          OperationRoom room = await showDialog(
            context: context,
            builder: (context) => AddRoomDialog(hospitalId),
          );
          if (room != null) await model.addRoom(room, hospitalId);
          await model.searchRoom('', hospitalId);
        },
      ),
      body: FutureBuilder(
        future: model.searchRoom(query, hospitalId),
        builder: (context, AsyncSnapshot<List<OperationRoom>> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );

          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          return ListView(
            padding: EdgeInsets.all(8.0),
            children: []..addAll(snapshot.data
                .map((room) => ItemLoaderCard<OperationRoom>(
                        initialValue: room, onTap: () => onTap(room))

                    //     Card(
                    //   margin: EdgeInsets.all(4.0),
                    //   child: ListTile(
                    //     onTap: () => onTap(patient),
                    //     leading: CircleAvatar(
                    //       backgroundColor: Theme.of(context).accentColor,
                    //       child: Text(patient.name[0]),
                    //     ),
                    //     title: Text(patient.name),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       side: BorderSide(
                    //         color: Theme.of(context).primaryColor,
                    //         width: 4,
                    //       ),
                    //     ),
                    //     tileColor: Theme.of(context).primaryColorLight,
                    //   ),
                    // ),
                    )
                .toList()),
          );
        },
      ),
    );
  }
}

class RoomSearchDelegate extends SearchDelegate<OperationRoom> {
  final String hospitalId;

  RoomSearchDelegate(this.hospitalId);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return RoomSearchList(
      query: query,
      hospitalId: hospitalId,
      onTap: (room) {
        close(context, room);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return RoomSearchList(
      query: query,
      hospitalId: hospitalId,
      onTap: (room) {
        close(context, room);
      },
    );
  }
}
