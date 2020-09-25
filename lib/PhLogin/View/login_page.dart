import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shop/Utils/theme.dart';
import 'package:easy_shop/main.dart';
import 'package:easy_shop/screens/edit_user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../phlogin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  bool loading = false;
  AuthenticationBloc _authBloc;
  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  Future<void> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    //bool x = false;

    if (kIsWeb) {
      //Here do whatever I want on web
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
      googleProvider
          .addScope('https://www.googleapis.com/auth/user.phonenumbers.read');
      googleProvider
          .addScope('https://www.googleapis.com/auth/userinfo.profile');

      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      _auth.signInWithPopup(googleProvider).then((result) async {
        User user = result.user;
        if (user != null) {
          // x = true;
          final response = await http.get(
              "http://sksapi.suninfotechnologies.in/api/customermaster?&strMode=INSERT&@intOrganizationMasterID=1&strCUSTOMER_REGMOBILE=${_auth.currentUser.phoneNumber}&strCUSTOMER_NAME=${_auth.currentUser.displayName}&strEmailID=${_auth.currentUser.email}");
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
                .doc(FirebaseAuth.instance.currentUser.phoneNumber)
                .get()
                .then(
              (value) {
                print(value.get('registered'));
                if (value.get('registered')) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
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
          print("Error");
        }
      });
    } else {
      //Verify with phone on mobile
      _auth.verifyPhoneNumber(
          phoneNumber: '+91' + phone,
          timeout: Duration(minutes: 2),
          verificationCompleted: (AuthCredential credential) async {
            //Navigator.of(context).pop();
            UserCredential result =
                await _auth.signInWithCredential(credential);
            User user = result.user;
            if (user != null) {
              // x = true;
              final response = await http.get(
                  "http://sksapi.suninfotechnologies.in/api/customermaster?&strMode=INSERT&@intOrganizationMasterID=1&strCUSTOMER_REGMOBILE=${phoneController.text.trim()}&strCUSTOMER_NAME=${nameController.text.trim()}&strEmailID=${emailController.text.trim()}");
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
                    .doc(FirebaseAuth.instance.currentUser.phoneNumber)
                    .get()
                    .then(
                  (value) {
                    print(value.get('registered'));
                    if (value.get('registered')) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(),
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
              print("Error");
            }

            //This callback would gets called when verification is done auto maticlly
          },
          verificationFailed: (FirebaseAuthException exception) {
            print(exception);
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            // if (x == false) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  verificationId: verificationId,
                  email: emailController.text.trim(),
                  name: nameController.text.trim(),
                  phNo: phoneController.text.trim(),
                ),
              ),
            );
            // Navigator.p(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => OtpPage(
            //         verificationId: verificationId,
            //         email: emailController.text.trim(),
            //         name: nameController.text.trim(),
            //         phNo: phoneController.text.trim(),
            //       ),
            //     ),
            //     (route) => false);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => OtpPage(
            //       verificationId: verificationId,
            //       email: emailController.text.trim(),
            //       name: nameController.text.trim(),
            //       phNo: phoneController.text.trim(),
            //     ),
            //   ),
            // );
            //  }
          },
          codeAutoRetrievalTimeout: (String veriD) {
            print(veriD);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset('assets/images/logo.png'),
                              height: 200,
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: const BoxDecoration(
                                  color: MyColors.primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('GrowKart',
                            style: TextStyle(
                                color: MyColors.primaryColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w800)))
                  ],
                ),
                loginDetailsWidget(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginDetailsWidget(BuildContext context) {
    if (kIsWeb) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 500),
        child: RaisedButton(
          onPressed: () {
            setState(() {
              loading = true;
            });
            //Navigator.of(context).pop();
            loginUser(null, context);
          },
          color: MyColors.primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: loading
                ? Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Log in with Google',
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
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
              constraints: const BoxConstraints(maxWidth: 500),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: 'We will send you an ',
                      style: TextStyle(color: MyColors.primaryColor)),
                  TextSpan(
                      text: 'One Time Password ',
                      style: TextStyle(
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'on this mobile number',
                      style: TextStyle(color: MyColors.primaryColor)),
                ]),
              )),
          cupertinoTextField(nameController, TextInputType.name, "Your Name"),
          cupertinoTextField(
              emailController, TextInputType.emailAddress, "Your Email"),
          cupertinoTextField(phoneController, TextInputType.phone, "+91 "),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 500),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                });
                final phone = phoneController.text.trim();
                //Navigator.of(context).pop();
                loginUser(phone, context);
              },
              color: MyColors.primaryColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Next',
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
        ],
      );
    }
  }

  Widget cupertinoTextField(TextEditingController controller,
      TextInputType textInputType, String placeHolder) {
    return Container(
      height: 40,
      constraints: const BoxConstraints(maxWidth: 500),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CupertinoTextField(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        controller: controller,
        clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: textInputType,
        maxLines: 1,
        placeholder: placeHolder,
      ),
    );
  }
}
