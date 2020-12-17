import 'dart:convert';
import 'package:easy_shop/app.dart';
import 'package:easy_shop/models/address.dart';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class AddressService {
  String url = App.BASE_URL +
      "api/customermaster?&strMode=INSERTADDRESS&intOrganizationMasterID=1&";

  Future<APIResponse<List<dynamic>>> storeAddress(
      String customerMasterId,
      String doorNo,
      String street,
      String city,
      String landMark,
      String pincode) {
    return http
        .get(url +
            "intCustomer_Masterid=" +
            customerMasterId +
            "&strDoorNo=" +
            doorNo +
            "&strStreet=" +
            street +
            "&strCity=" +
            city +
            "&strState=TAMILNADU" +
            "&strLandmark=" +
            landMark +
            "&strPincode=" +
            pincode)
        .then((data) {
      print(url +
          "intCustomer_Masterid=" +
          customerMasterId +
          "&strDoorNo=" +
          doorNo +
          "&strStreet=" +
          street +
          "&strCity=" +
          city +
          "&strState=TAMILNADU" +
          "&strLandmark=" +
          landMark +
          "&strPincode=" +
          pincode);
      print("code " + data.statusCode.toString());
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print(jsonData);
        return APIResponse<List<dynamic>>(error: false, data: jsonData);
      }
      return APIResponse<List<dynamic>>(
          error: true, errorMessage: "An error occured");
    }).catchError((e) {
      print("Error on Address Service while storing: " + e.toString());
      return APIResponse<List<dynamic>>(
          error: true, errorMessage: "An error occured");
    });
  }

  Future<APIResponse<List<Address>>> getExistingAddresses(
      String customerMasterId) {
    return http
        .get(App.BASE_URL +
            "api/customermaster?&intOrganizationMasterID=1&strMode=GET&intCustomer_Masterid=" +
            customerMasterId)
        .then((data) {
      if (data.statusCode == 200) {
        final Iterable jsonData = json.decode(data.body);
        final List<Address> addresses =
            jsonData.map((e) => Address.fromJson(e)).toList();
        return APIResponse<List<Address>>(data: addresses);
      }
      return APIResponse<List<Address>>(
          error: true, errorMessage: "An error occured");
    }).catchError((e) {
      print("Error on Address Service while getting: " + e.toString());
      return APIResponse<List<Address>>(
          error: true, errorMessage: 'An error occured');
    });
  }
}
