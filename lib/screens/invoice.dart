import 'package:easy_shop/models/cart.dart';
import 'package:easy_shop/payment/payment_gateway.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Invoice extends StatelessWidget {
  final int netAmount;
  final String name;
  final int phoneNumber;
  final String mail;
  final String pincode;
  final String houseNo;
  final String street;
  final String landmark;
  final String city;
  Invoice(
      {this.netAmount,
      this.name,
      this.phoneNumber,
      this.mail,
      this.pincode,
      this.houseNo,
      this.street,
      this.landmark,
      this.city});

  TextStyle heading = TextStyle(color: Colors.grey, fontSize: 20);
  TextStyle body = TextStyle(color: Colors.white, fontSize: 18);
  var now = DateTime.now();
  var df = new DateFormat('dd-MM-yyyy');

  List<TableRow> children = [
    TableRow(children: <Widget>[
      Text(
        "Name",
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
      Text(
        "Price",
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
      Text(
        "Quantity",
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
      Text(
        "Subtotal",
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
    ]),
  ];

  Widget header1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Order",
              style: heading,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "3738456879",
              style: body,
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Date",
              style: heading,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              df.format(now).toString(),
              style: body,
            )
          ],
        )
      ],
    );
  }

  Widget displayItems(Map<String, CartItem> items) {
    items.forEach((id, item) {
      final temp = TableRow(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            item.itemName,
            style: body,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '₹' + item.rate.toString(),
            style: body,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            item.quantity.toString(),
            style: body,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '₹' + item.total.toString(),
            style: body,
          ),
        ),
      ]);
      children.add(temp);
    });
    return Table(
      children: children,
    );
  }

  Widget displayAddress() {
    return Container(
        margin: EdgeInsets.all(8),
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Shipping to",
                style: heading,
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
              child: Text(
                name ?? "",
                style: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
              child: Text(
                houseNo ?? "",
                style: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
              child: Text(
                street ?? "",
                style: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
              child: Text(
                landmark ?? "",
                style: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
              child: Text(
                "${city ?? ""} ${pincode ?? ""} TN, India",
                style: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
              child: Text(
                phoneNumber.toString() ?? "",
                style: body,
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              elevation: 0,
              bottomOpacity: 0,
              backgroundColor: Theme.of(context).primaryColor,
              title: Text("Invoice"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: header1(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    color: Colors.grey.withOpacity(0.75),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  height: 300,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: displayItems(cart.items)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    color: Colors.grey.withOpacity(0.75),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Total",
                        style: body,
                      ),
                      Text(
                        '₹' + cart.totalAmount.toString(),
                        style: body,
                      ),
                    ],
                  ),
                ),
                displayAddress(),
                GetBuilder<PaymentGateway>(
                    init: PaymentGateway(),
                    builder: (value) {
                      return Container(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        height: 65,
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () {
                            value.dispatchpayment(netAmount, name, phoneNumber,
                                mail, 'GooglePay');
                          },
                          child: Text("Proceed to payment",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.5)),
                          color: Color.fromRGBO(248, 66, 100, 1),
                          splashColor: Colors.lightBlue,
                        ),
                      );
                    })
              ],
            ));
      },
    );
  }
}
