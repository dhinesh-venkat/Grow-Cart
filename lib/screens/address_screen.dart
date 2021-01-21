import 'package:easy_shop/models/address.dart';
import 'package:easy_shop/models/api_response.dart';
import 'package:easy_shop/models/cart.dart';
import 'package:easy_shop/screens/invoice.dart';
import 'package:easy_shop/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import '../widgets/get_customer_details.dart';
import 'package:provider/provider.dart';
import 'package:easy_shop/services/address_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../widgets/modal_with_navigator.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/address';

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  UserService get userService => GetIt.I<UserService>();
  AddressService get addressService => GetIt.I<AddressService>();

  String customerId;
  bool _isGetID = false;
  APIResponse<List<dynamic>> _addressResponse;
  APIResponse<List<Address>> _getAddress;
  bool _saveAddress = false;

  final String mail = getUserMail();

  TextStyle whiteText = TextStyle(color: Colors.white, fontSize: 18.5);

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController pincodeController = TextEditingController();

  TextEditingController houseNoController = TextEditingController();

  TextEditingController streetController = TextEditingController();

  TextEditingController landmarkController = TextEditingController();

  TextEditingController townController = TextEditingController();

  TextEditingController stateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    pincodeController.dispose();
    houseNoController.dispose();
    streetController.dispose();
    landmarkController.dispose();
    townController.dispose();
    stateController.dispose();
    super.dispose();
  }

  void fillAddress(Address address) {
    setState(() {
      //  nameController.text = ;
      //  phoneNumberController.text = ;
      pincodeController.text = address.pincode;
      houseNoController.text = address.doorNo.replaceAll('%', ' ');
      streetController.text = address.street.replaceAll('%', ' ');
      landmarkController.text = address.landmark.replaceAll('%', ' ');
      townController.text = address.city.replaceAll('%', ' ');
    });
  }

  void onSaveAddressChanged(bool newValue) {
    setState(() {
      _saveAddress = newValue;
    });
  }

  void saveAddressInServer() async {
    // Getting the current customer details
    String _idResponse = await getCustomerDetails(userService);
    if (_idResponse == "Not found") {
      // If the current user does not exist in Database, store the details in DB
      storeCustomerDetails(nameController.text,
          int.parse(phoneNumberController.text), userService);
      // Getting the customer Id after storing
      customerId = await getCustomerDetails(userService);
      print("************");
      print(customerId);
      _isGetID = true;
    } else if (_idResponse == "Error") {
      // If this block gets executed there is a problem in the database
      print("Error on the customer Database");
    } else {
      // If the user details are already stored, get only the customer ID
      customerId = await getCustomerDetails(userService);
      _isGetID = true;
    }
    if (_isGetID) {
      _addressResponse = await addressService.storeAddress(
          (double.parse(customerId).toInt()).toString(),
          houseNoController.text,
          streetController.text,
          townController.text,
          landmarkController.text,
          pincodeController.text);
      if (_addressResponse.error) {
        print("Something went wrong while storing address");
      } else {
        print("Address saved");
        print(_addressResponse.data);
      }
    } else {
      print("Something went wrong in the backend");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double netAmount =
        Provider.of<Cart>(context, listen: false).totalAmount;
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Choose Address"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: RaisedButton(
                      onPressed: () async {
                        print("Calling address from server");
                        customerId = await getCustomerDetails(userService);
                        print("Customer ID : "+customerId);
                        if (customerId == "Not found") {
                          // User have no ID yet
                          print("ID not found");
                        } else {
                          _getAddress =
                              await addressService.getExistingAddresses(
                            (double.parse(customerId).toInt()).toString(),
                          );
                          if (_getAddress.error) {
                            print("Error while getting address");
                          } else {
                            print("waiting for modal sheet");
                            final Address address =
                                await showCupertinoModalBottomSheet(
                              expand: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ModalWithNavigator(
                                addressList: _getAddress.data,
                              ),
                            );

                            fillAddress(address);
                          }
                        }
                      },
                      child: Text(
                        "Choose an Existing Address",
                        style: whiteText,
                      ),
                      color: Colors.black,
                      splashColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  SizedBox(height: 20),
                  getCupertinoTextField("Full name", TextInputType.name,
                      nameController, () => node.nextFocus()),
                  getCupertinoTextField("Mobile number", TextInputType.phone,
                      phoneNumberController, () => node.nextFocus()),
                  getCupertinoTextField("PIN code", TextInputType.number,
                      pincodeController, () => node.nextFocus()),
                  getCupertinoTextField(
                      "Flat, House no, Building, Company, Apartment",
                      TextInputType.streetAddress,
                      houseNoController,
                      () => node.nextFocus()),
                  getCupertinoTextField(
                      "Area, Colony, Street, Sector, Village",
                      TextInputType.streetAddress,
                      streetController,
                      () => node.nextFocus()),
                  getCupertinoTextField("Landmark", TextInputType.streetAddress,
                      landmarkController, () => node.nextFocus()),
                  getCupertinoTextField("Town/City", TextInputType.text,
                      townController, () => node.unfocus()),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        onChanged: onSaveAddressChanged,
                        value: _saveAddress,
                      ),
                      Text(
                        "Save Address",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 19.0),
                height: 65,
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () {
                    if (_saveAddress) {
                      saveAddressInServer();
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Invoice(
                            netAmount: (netAmount * 100).toInt(),
                            mail: mail,
                            name: nameController.text,
                            phoneNumber: int.parse(phoneNumberController.text),
                            pincode: pincodeController.text,
                            houseNo: houseNoController.text,
                            street: streetController.text,
                            landmark: landmarkController.text,
                            city: townController.text,
                          ),
                        ));
                  },
                  child: Text("Continue",
                      style: TextStyle(color: Colors.white, fontSize: 18.5)),
                  color: Colors.black,
                  splashColor: Colors.lightBlue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getCupertinoTextField(String placeholder, TextInputType keyboardType,
      TextEditingController controller, Function onEnter) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      height: 45,
      child: CupertinoTextField(
        onEditingComplete: onEnter,
        placeholder: placeholder,
        placeholderStyle: TextStyle(color: Colors.black38),
        keyboardType: keyboardType,
        controller: controller,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
