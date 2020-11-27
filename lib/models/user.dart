class User {
  String deviceId;
  String name;
  int mobileNumber;
  String mail;

  User({this.deviceId, this.name, this.mobileNumber, this.mail});

  User.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    mobileNumber = json['MobileNumber'];
    mail = json['Mail'];
    deviceId = json['DeviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['MobileNumber'] = this.name;
    data['Mail'] = this.mail;
    data['DeviceId'] = this.deviceId;
    return data;
  }
}
