import 'package:easy_shop/main.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_shop/PhLogin/phlogin.dart';
import 'package:easy_shop/screens/edit_user_page.dart';

class MyAppLogin extends StatefulWidget {
  final UserRepository _userRepository;

  MyAppLogin({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppLogin> {
  UserRepository get userRepository => widget._userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Shop',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(66, 67, 69, 1),
          accentColor: Colors.orange,
          fontFamily: 'Poppins',
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline3: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            headline4: TextStyle(fontSize: 24, color: Colors.white),
            bodyText2: TextStyle(
                fontSize: 14.0, fontFamily: 'Fryo', color: Colors.white),
          )),
      home: Scaffold(
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitilized) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SplashPage(),
                //   ),
                // );
              });
            } else if (state is UnAuthenticated) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              });
            } else if (state is Authenticated) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              });
            } else if (state is AuthenticatedButNotRegistered) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserDetail(),
                  ),
                );
              });
            } else if (state is IsOldUserNotRegisteredState) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserDetail(),
                  ),
                );
              });
            } else if (state is IsOldUserRegisteredState) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              });
            } else {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SplashPage(),
                //   ),
                // );
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
