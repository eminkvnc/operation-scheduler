import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:operation_reminder/model/doctor.dart';
import 'package:operation_reminder/model/draft.dart';
import 'package:operation_reminder/model/operation.dart';
import 'package:operation_reminder/view/screens/add_operation_draft_page.dart';
import 'package:operation_reminder/view/screens/draft_details_page.dart';
import 'package:operation_reminder/view/screens/login_page.dart';
import 'package:operation_reminder/view/screens/operation_details_page.dart';
import 'package:operation_reminder/view/screens/profile_page.dart';
import 'package:operation_reminder/view/screens/root_page.dart';
import 'package:operation_reminder/view/screens/verification_page.dart';

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

  Future<dynamic> pop() {
    return _navigatorKey.currentState.maybePop();
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
      case AddDraftPage.routeName:
        return MaterialPageRoute(builder: (context) => AddDraftPage());
        break;

      case VerificationPage.routeName:
        return MaterialPageRoute(builder: (context) => VerificationPage());
        break;
      case DraftDetailsPage.routeName:
        DraftDetailsPageArgs args = settings.arguments;
        return MaterialPageRoute(builder: (context) => DraftDetailsPage(args));
        break;

      case OperationDetailsPage.routeName:
        OperationDetailsPageArgs args = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => OperationDetailsPage(args));
        break;
      case ProfilePage.routeName:
        ProfilePageArgs args = settings.arguments;
        return MaterialPageRoute(builder: (context) => ProfilePage(args));
        break;
      default:
        return MaterialPageRoute(
            builder: (context) => Container(
                  child: Center(child: Text('TEMPLATE PAGE')),
                ));
    }
  }
}

class RootPageArgs {
  Doctor doctor;
  RootPageArgs({@required this.doctor});
}

class ProfilePageArgs {
  Doctor doctor;
  ProfilePageArgs({@required this.doctor});
}

class DraftDetailsPageArgs {
  Draft draft;
  Operation operation;

  DraftDetailsPageArgs({@required this.draft, this.operation});
}

class OperationDetailsPageArgs {
  Operation operation;
  OperationDetailsPageArgs({@required this.operation});
}
