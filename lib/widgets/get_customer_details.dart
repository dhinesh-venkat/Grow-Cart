import 'package:firebase_auth/firebase_auth.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../services/user_service.dart';

String getUserMail() {
  return FirebaseAuth.instance.currentUser.email;
}

void storeCustomerDetails(
    String name, int mobileNumber, UserService service) async {
  final String deviceId = await PlatformDeviceId.getDeviceId;
  final String mail = getUserMail();
  print("Name : " +
      name +
      " | Mobile : " +
      mobileNumber.toString() +
      " | DeviceID : " +
      deviceId +
      " | Mail : " +
      mail);
  await service.storeUserDetails(mobileNumber, name, mail, deviceId);
}

Future<String> getCustomerDetails(UserService service) async {
  final String deviceId = await PlatformDeviceId.getDeviceId;
  final String response = await service.getUserDetails(deviceId);
  print("Device ID : " + deviceId);
  return response;
}
