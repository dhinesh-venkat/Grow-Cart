import 'package:flutter/material.dart';

class Address {
  String userId;
  String name;
  int mobileNumber;
  int pincode;
  String houseNumber;
  String street;
  String landMark;
  String city;

  Address(
      {@required this.userId,
      this.name,
      this.mobileNumber,
      this.pincode,
      this.houseNumber,
      this.street,
      this.landMark,
      this.city});

  Address.fromJson(Map<String, dynamic> json) {
    userId = json['UserID'];
    name = json['Name'];
    mobileNumber = json['MobileNumber'];
    pincode = json['PinCode'];
    houseNumber = json['HouseNumber'];
    street = json['Street'];
    landMark = json['LandMark'];
    city = json['City'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userId;
    data['Name'] = this.name;
    data['MobileNumber'] = this.mobileNumber;
    data['PinCode'] = this.pincode;
    data['HouseNumber'] = this.houseNumber;
    data['Street'] = this.street;
    data['LandMark'] = this.landMark;
    data['City'] = this.city;
    return data;
  }
}
