import 'package:flutter/material.dart';
import 'package:operation_reminder/view/screens/home_operations_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 1, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColorLight,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: 'Operations'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                HomeOperationsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
