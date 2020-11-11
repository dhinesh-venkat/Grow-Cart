import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Authentication/authentication/authentication.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Text(
              "GroCart",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 30,
              ),
            )),
            ListTile(
              title: Text(
                "My Orders",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                Navigator.pop(context);
                // Should Navigate to My Orders page
              },
            ),
            ListTile(
              title: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                showAlertDialog(context);
                // Sign out accordingly for google and mobile number
              },
            )
          ],
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text("Log out?"),
          content: Text("Are you sure you want to sign out?"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            CupertinoDialogAction(
                textStyle: TextStyle(color: Colors.red),
                isDefaultAction: true,
                // onPressed: () {
                // //  Navigator.pop(context);
                // },
                onPressed: () => context
                    .bloc<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested()),
                child: Text("Log out")),
          ],
        ));
  }
}
