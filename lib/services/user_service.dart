import 'dart:convert';

import 'package:easy_shop/app.dart';
import 'package:http/http.dart' as http;

import '../models/api_response.dart';

class UserService {
  String url = App.BASE_URL +
      "api/customermaster?&strMode=insert&intOrganizationMasterID=1&";

  Future<APIResponse<void>> storeUserDetails(
      int mobileNumber, String name, String mail, String deviceId) {
    return http
        .get(url +
            "strCUSTOMER_REGMOBILE=" +
            mobileNumber.toString() +
            "&strCUSTOMER_NAME=" +
            name +
            "&strEmailID=" +
            mail +
            "&strDeviceid=" +
            deviceId)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print(jsonData);
      }
      return APIResponse<void>(error: true, errorMessage: "An error occured");
    }).catchError((e) {
      print("Error is thrown : " + e.toString());
      return APIResponse<void>(error: true, errorMessage: "An error occured");
    });
  }
}
