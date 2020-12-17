import 'package:flutter/material.dart';

class Invoice extends StatelessWidget {
  Invoice({Key key}) : super(key: key);
  static const routeName = '/invoice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Invoice screen"),
      ),
    );
  }
}
