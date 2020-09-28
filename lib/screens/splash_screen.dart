import 'package:easy_shop/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: HomePage(),
      image: Image.asset("assets/images/logo.png"),
      backgroundColor: Theme.of(context).primaryColor,
      title: Text("GroCart",style: TextStyle(color: Colors.white,fontSize: 28),),
      );
  }
}
