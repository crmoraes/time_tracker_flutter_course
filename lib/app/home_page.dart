import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widget/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmedSignOut = await showAlertDialog(context, title: 'Logout',
        content: 'Are you sure that you want to logout?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout',
    );
    if (confirmedSignOut == true) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
