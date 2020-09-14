import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({
    FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> sentOtp(
      String mobileNumber,
      Duration timeOut,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout) async {
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  Future<UserCredential> verifyAndLogin(
      String verificationId, String smsCode) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    return _firebaseAuth.signInWithCredential(authCredential);
  }

  Future<User> getUser() async {
    Firebase.initializeApp();
    var user = _firebaseAuth.currentUser;
    return user;
  }

  Future<bool> alreadyRegistered() async {
    // var a = (await FirebaseFirestore.instance
    //     .doc(FirebaseAuth.instance.currentUser.phoneNumber)
    //     .get());
    // //      .data();
    bool valid = false;
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
            valid = true;
          }
        },
      );
    } catch (e) {
      print(e);
    }
    return valid;
  }
}
