import 'package:easy_shop/models/address.dart';
import 'package:easy_shop/models/api_response.dart';
import 'package:easy_shop/models/cart.dart';
import 'package:easy_shop/payment/payment_gateway.dart';
import 'package:easy_shop/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../widgets/get_customer_details.dart';
import 'package:provider/provider.dart';
import 'package:easy_shop/services/address_service.dart';

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
  bool _isAddressStored = false;
  APIResponse<List<dynamic>> _addressResponse;
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

  @override
  Widget build(BuildContext context) {
    final double netAmount =
        Provider.of<Cart>(context, listen: false).totalAmount;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: RaisedButton(
                    onPressed: () {
                      // Fetch address from firebase
                      // navigate to new screen and display all the addresses
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
                getCupertinoTextField(
                    "Full name", TextInputType.name, nameController),
                getCupertinoTextField("Mobile number", TextInputType.phone,
                    phoneNumberController),
                getCupertinoTextField(
                    "PIN code", TextInputType.number, pincodeController),
                getCupertinoTextField(
                    "Flat, House no, Building, Company, Apartment",
                    TextInputType.streetAddress,
                    houseNoController),
                getCupertinoTextField("Area, Colony, Street, Sector, Village",
                    TextInputType.streetAddress, streetController),
                getCupertinoTextField("Landmark", TextInputType.streetAddress,
                    landmarkController),
                getCupertinoTextField(
                    "Town/City", TextInputType.text, townController),
              ],
            ),
            GetBuilder<PaymentGateway>(
                init: PaymentGateway(),
                builder: (value) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 19.0),
                    height: 65,
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () async {
                        print("Storing details and Initiating payment gateway");
                        // Getting the current customer details
                        String _idResponse =
                            await getCustomerDetails(userService);
                        if (_idResponse == "Not found") {
                          // If the current user does not exist in Database, store the detailsl in DB
                          storeCustomerDetails(
                              nameController.text,
                              int.parse(phoneNumberController.text),
                              userService);
                          // Getting the customer Id after storing
                          customerId = await getCustomerDetails(userService);
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
                            print(_addressResponse.data);
                            _isAddressStored = true;
                          }
                        } else {
                          print("Something went wrong in the backend");
                        }
                        if (_isAddressStored) {
                          value.dispatchpayment(
                              (netAmount * 100).toInt(),
                              nameController.text,
                              int.parse(phoneNumberController.text),
                              mail,
                              'GooglePay');
                        } else {
                          print("Something went wrong in the backend");
                        }
                      },
                      child: Text("Pay now",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.5)),
                      color: Colors.black,
                      splashColor: Colors.lightBlue,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget getCupertinoTextField(String placeholder, TextInputType keyboardType,
      TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      height: 45,
      child: CupertinoTextField(
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
