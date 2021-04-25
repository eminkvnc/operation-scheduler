import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/view/screens/home_page.dart';
import 'package:operation_reminder/view/screens/profile_page.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';
import 'package:operation_reminder/viewmodel/root_model.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  static const String routeName = '/root_page';

  RootPageArgs args;

  final PageController _pageController = PageController();

  RootPage(this.args);

  @override
  Widget build(BuildContext context) {
    LoginModel _loginModel = getIt<LoginModel>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Operation Reminder'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _loginModel.signOut();
              },
            ),
          ],
        ),
        bottomNavigationBar: Consumer<RootModel>(
          builder: (context, model, child) {
            return BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
              onTap: (value) {
                model.selectedBottomNavIndex = value;
                _pageController.jumpToPage(value);
              },
              currentIndex: model.selectedBottomNavIndex,
            );
          },
        ),
        body: Consumer<RootModel>(
          builder: (context, model, child) {
            model.getDoctorStream().listen((event) => model.doctor = event);
            return PageView(
              onPageChanged: (value) {
                model.selectedBottomNavIndex = value;
                _pageController.jumpToPage(value);
              },
              controller: _pageController,
              children: [
                HomePage(),
                // SearchPage(),
                ProfilePage(ProfilePageArgs(doctor: model.doctor)),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.post_add_outlined),
          onPressed: () async {
            await getIt<RootModel>().navigateToAddOperation();
          },
        ),
      ),
    );
  }
}
