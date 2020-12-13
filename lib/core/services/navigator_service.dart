import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/screens/login_page.dart';
import 'package:operation_reminder/screens/root_page.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Future<dynamic> navigateTo({@required String routeName, args}) {
    return args != null
        ? _navigatorKey.currentState.pushNamed(routeName, arguments: args)
        : _navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateToReplace({@required String routeName, args}) {
    return args != null
        ? _navigatorKey.currentState
            .pushReplacementNamed(routeName, arguments: args)
        : _navigatorKey.currentState.pushReplacementNamed(routeName);
  }

  MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginPage.routeName:
        var args = settings.arguments;
        return MaterialPageRoute(builder: (context) => LoginPage());
        break;
      case RootPage.routeName:
        RootPageArgs args = settings.arguments;
        return MaterialPageRoute(builder: (context) => RootPage(args));
        break;

      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}

class RootPageArgs {
  User user;
  RootPageArgs({@required this.user});
}
