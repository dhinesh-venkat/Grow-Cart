import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shop/PhLogin/Authentication/authentication_bloc.dart';
import 'package:easy_shop/Utils/theme.dart';
import 'package:easy_shop/screens/edit_user_page.dart';
import 'package:easy_shop/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:http/http.dart' as http;

import '../phlogin.dart';

class OtpPage extends StatefulWidget {
  const OtpPage(
      {Key key, this.verificationId, this.email, this.name, this.phNo})
      : super(key: key);
  final String verificationId;
  final String phNo;
  final String email;
  final String name;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';
  //bool loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthenticationBloc _authBloc;

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      //   key: loginStore.otpScaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: MyColors.primaryColorLight.withAlpha(20),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: MyColors.primaryColor,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                'Enter 6 digits verification code sent to your number',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500))),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              otpNumberWidget(0),
                              otpNumberWidget(1),
                              otpNumberWidget(2),
                              otpNumberWidget(3),
                              otpNumberWidget(4),
                              otpNumberWidget(5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: RaisedButton(
                      onPressed: () async {
                        // setState(() {
                        //   loading = true;
                        // });
                        final code = text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: widget.verificationId,
                                smsCode: code);

                        UserCredential result =
                            await _auth.signInWithCredential(credential);

                        User user = result.user;

                        if (user != null) {
                          final response = await http.get(
                              "http://sksapi.suninfotechnologies.in/api/customermaster?&strMode=INSERT&@intOrganizationMasterID=1&strCUSTOMER_REGMOBILE=${widget.phNo}&strCUSTOMER_NAME=${widget.name}&strEmailID=${widget.email}");
                          if (response.statusCode == 200) {
                            // If server returns an OK response, parse the JSON.
                            // return Post.fromJson(json.decode(response.body));
                            print(response.body);
                          } else {
                            // If that response was not OK, throw an error.
                            throw Exception(response.body);
                          }
                          Firebase.initializeApp();
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth
                                    .instance.currentUser.phoneNumber)
                                .get()
                                .then(
                              (value) {
                                print(value.get('registered'));
                                if (value.get('registered')) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditUserDetail(),
                                    ),
                                  );
                                }
                              },
                            );
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          //TODO
                        }
                      },
                      color: MyColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: MyColors.accentColor,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  NumericKeyboard(
                    onKeyboardTap: _onKeyboardTap,
                    textColor: MyColors.primaryColorLight,
                    rightIcon: Icon(
                      Icons.backspace,
                      color: MyColors.primaryColorLight,
                    ),
                    rightButtonFn: () {
                      setState(() {
                        text = text.substring(0, text.length - 1);
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
