import 'package:flutter/material.dart';
import 'package:operation_reminder/core/locator.dart';
import 'package:operation_reminder/core/services/navigator_service.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/view/screens/home_page.dart';
import 'package:operation_reminder/view/screens/profile_page.dart';
import 'package:operation_reminder/viewmodel/login_model.dart';
import 'package:operation_reminder/viewmodel/root_model.dart';

class RootPage extends StatefulWidget {
  static const String routeName = '/root_page';
  RootPageArgs args;
  Doctor doctor;

  RootPage(this.args) {
    doctor = args.doctor;
  }

  @override
  _RootPageState createState() => _RootPageState(doctor);
}

class _RootPageState extends State<RootPage> {
  final PageController _pageController = PageController();

  int currentIndex = 0;
  Doctor _doctor;

  _RootPageState(this._doctor);

  Doctor get doctor => _doctor;

  set doctor(Doctor value) {
    _doctor = value;
    setState(() {});
  }

  @override
  void initState() {
    RootModel _rootModel = getIt<RootModel>();
    _rootModel.getDoctorStream().listen((event) {
      doctor = event;
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginModel _loginModel = getIt<LoginModel>();

    BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (value) {
        // model.selectedBottomNavIndex = value;
        _pageController.jumpToPage(value);
      },
      currentIndex: currentIndex,
    );

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
        bottomNavigationBar: bottomNavigationBar,
        body: PageView(
          onPageChanged: (value) {
            _pageController.jumpToPage(value);
            setState(() {
              currentIndex = value;
            });
          },
          controller: _pageController,
          children: [
            HomePage(),
            // SearchPage(),
            ProfilePage(ProfilePageArgs(doctor: doctor)),
          ],
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
