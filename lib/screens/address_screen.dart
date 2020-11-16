import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddressScreen extends StatelessWidget {
  // const AddressScreen({Key key}) : super(key: key);
  static const routeName = '/address';

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
  Widget build(BuildContext context) {
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
            Container(
              padding: const EdgeInsets.only(bottom: 19.0),
              height: 65,
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () {
                  // post the address in firebase
                  // Navigate to payment
                  
                },
                child: Text("Pay now",
                    style: TextStyle(color: Colors.white, fontSize: 18.5)),
                color: Colors.black,
                splashColor: Colors.lightBlue,
              ),
            )
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
