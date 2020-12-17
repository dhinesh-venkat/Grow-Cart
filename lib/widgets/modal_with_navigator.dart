import 'package:easy_shop/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalWithNavigator extends StatelessWidget {
  final List<Address> addressList;
  ModalWithNavigator({Key key, this.addressList}) : super(key: key);

  TextStyle _textStyle = TextStyle(color: Colors.white, fontSize: 16);

  @override
  Widget build(BuildContext rootContext) {
    final _width = MediaQuery.of(rootContext).size.width;
    return Material(
        child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context2) => Builder(
          builder: (context) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                leading: Container(), middle: Text('Choose Address')),
            child: SafeArea(
              bottom: false,
              child: ListView(
                shrinkWrap: true,
                controller: ModalScrollController.of(context),
                children: ListTile.divideTiles(
                        context: context,
                        tiles: addressList.map((address) =>
                            addressTile(_width, address, context, rootContext)))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget customText(String text, TextStyle style) {
    return Padding(
      padding: EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        text,
        style: style,
      ),
    );
  }

  Widget addressTile(double width, Address address, BuildContext context,
      BuildContext rootContext) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(rootContext,address);
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        height: 200,
        width: width,
        padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromRGBO(66, 67, 69, 1),
        ),
        child: Column(
          children: <Widget>[
            customText(
              "Name",
              _textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            customText(
              address.doorNo.replaceAll("%", " "),
              _textStyle,
            ),
            customText(
              address.street.replaceAll("%", " "),
              _textStyle,
            ),
            customText(
              address.landmark.replaceAll("%", " "),
              _textStyle,
            ),
            customText(
              address.city.replaceAll("%", " "),
              _textStyle,
            ),
            customText(
              "Tamilnadu " + address.pincode,
              _textStyle,
            ),
            customText(
              "Phone Number : 6379960868",
              _textStyle,
            ),
            customText(
              "India",
              _textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
