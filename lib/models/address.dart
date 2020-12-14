class Address {
  num customerAddressId;
  num customerMasterId;
  String contactPerson;
  String doorNo;
  String street;
  String state;
  String city;
  String landmark;
  String pincode;
  String location;
  bool isActive;
  int createdBy;
  String createdDate;

  Address(
      {this.customerAddressId,
      this.customerMasterId,
      this.contactPerson,
      this.doorNo,
      this.street,
      this.state,
      this.city,
      this.landmark,
      this.pincode,
      this.location,
      this.isActive,
      this.createdBy,
      this.createdDate});

  Address.fromJson(Map<String, dynamic> json) {
    customerAddressId = json['CUSTOMER_ADDRESSID'];
    customerMasterId = json['CUSTOMER_MASTERID'];
    contactPerson = json['CONTACT_PERSON'];
    doorNo = json['DoorNo'];
    street = json['Street'];
    state = json['State'];
    city = json['City'];
    landmark = json['Landmark'];
    pincode = json['PINCODE'];
    location = json['LOCATION'];
    isActive = json['IsActive'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['CUSTOMER_ADDRESSID'] = this.customerAddressId;
  //   data['CUSTOMER_MASTERID'] = this.customerMasterId;
  //   data['CONTACT_PERSON'] = this.contactPerson;
  //   data['DoorNo'] = this.doorNo;
  //   data['Street'] = this.street;
  //   data['State'] = this.state;
  //   data['City'] = this.city;
  //   data['Landmark'] = this.landmark;
  //   data['PINCODE'] = this.pincode;
  //   data['LOCATION'] = this.location;
  //   data['IsActive'] = this.isActive;
  //   data['CreatedBy'] = this.createdBy;
  //   data['CreatedDate'] = this.createdDate;
  //   return data;
  // }
}
