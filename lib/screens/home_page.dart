import 'package:flutter/material.dart';
import 'package:operation_reminder/screens/home_operations_page.dart';

import 'home_drafts_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
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
                Tab(text: 'Drafts'),
                Tab(text: 'Operations'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                HomeDraftsPage(),
                HomeOperationsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
