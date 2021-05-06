import 'package:flutter/material.dart';
import 'package:operation_reminder/view/widgets/sort_button.dart';

class SortableExpandableList<T> extends StatefulWidget {
  final Widget Function(int index, bool isExpanded) itemBuilder;
  final List<T> list;
  final List<int Function(T e1, T e2)> sortOptions;
  final List<String> sortTitles;

  const SortableExpandableList({
    Key key,
    @required this.itemBuilder,
    @required this.list,
    @required this.sortOptions,
    @required this.sortTitles,
  }) : super(key: key);

  @override
  _SortableExpandableListState<T> createState() =>
      _SortableExpandableListState<T>(list, sortOptions);
}

class _SortableExpandableListState<T> extends State<SortableExpandableList> {
  final List<int Function(T e1, T e2)> sortOptions;
  final List<T> list;
  bool isExpanded = true;
  int sortIndex = 0;
  bool asc = true;

  _SortableExpandableListState(this.list, this.sortOptions) {}

  void sort(int sortOptionIndex) {
    print('sortIndex$sortIndex');
    print('sortOptionIndex$sortOptionIndex');
    if (sortIndex == sortOptionIndex) {
      if (asc) {
        widget.list.cast<T>().sort(sortOptions[(sortOptionIndex * 2) + 1]);
      } else {
        widget.list.cast<T>().sort(sortOptions[sortOptionIndex * 2]);
      }
      asc = !asc;
    } else {
      widget.list.cast<T>().sort(
            sortOptions[sortOptionIndex * 2],
          );
      asc = true;
    }
    sortIndex = sortOptionIndex;
    setState(() {});
  }

  void collapse() {
    isExpanded = false;
    setState(() {});
  }

  void expand() {
    isExpanded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: List.generate(
                  widget.sortTitles.length,
                  (index) => SortButton(
                      title: widget.sortTitles[index],
                      state: true,
                      color: sortIndex != index
                          ? Colors.transparent
                          : Colors.black26,
                      onTap: () {
                        sort(index);
                      })).toList(),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                  icon: Icon(Icons.view_agenda_outlined),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                  icon: Icon(Icons.view_comfortable_outlined),
                ),
              ],
            ),
          ],
        ),
        isExpanded
            ? Expanded(
                child: ListView(
                    children: List.generate(widget.list.length,
                        (index) => widget.itemBuilder(index, isExpanded))),
              )
            : Expanded(
                child: GridView.count(
                  childAspectRatio: 3,
                  crossAxisCount: 2,
                  children: List.generate(widget.list.length,
                      (index) => widget.itemBuilder(index, isExpanded)),
                ),
              ),
      ],
    );
  }
}
