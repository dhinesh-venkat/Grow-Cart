import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_shop/models/cart.dart';
import 'package:easy_shop/screens/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  //const CartScreen({Key key}) : super(key: key);
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // List<int> _quantities = [];
  // List<double> _price = [];
  // List<CartItem> _cartList = [];
  // List<String> _uniqueId = [];
  // double _totalAmount = 0.0;
  bool loading = false;
  @override
  void initState() {
    // _totalAmount = Provider.of<Cart>(context, listen: false).totalAmount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottomOpacity: 0,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            FlatButton(
                onPressed: () {
                  cart.clear();
                },
                child: Text(
                  'Clear',
                  style: TextStyle(color: Colors.lightBlue),
                ))
          ],
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Cart',
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: Colors.black),
                  ),
                  Row(
                    children: [
                      Text(
                        '${cart.itemCount} items',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 60,
                        width: 140,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          color: Colors.black,
                          onPressed: () {},
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Text('₹ ' + cart.totalAmount.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'Fryo',
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => CartListItem(
                    product: cart.productList[index],
                    item: cart.itemList[index],
                    addItemCallback: (p, i) => cart.addItem(
                      p,
                      i.rate,
                      i.itemName,
                      i.imageUrl,
                      i.total,
                      i.quantity,
                    ),
                    subItemCallback: (p, i) => cart.removeSingleItem(p),
                    removeItemCallback: (p, i) => cart.removeItem(p, i),
                  ),
                  itemCount: cart.items.length,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(19.0),
                height: 80,
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddressScreen.routeName);
                  },
                  child: Text("Order now",
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
}

class CartListItem extends StatelessWidget {
  final CartItem item;
  final String product;
  final Function(String, CartItem) addItemCallback;
  final Function(String, CartItem) subItemCallback;
  final Function(String, CartItem) removeItemCallback;

  const CartListItem(
      {Key key,
      this.item,
      this.product,
      this.addItemCallback,
      this.removeItemCallback,
      this.subItemCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 120,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 120,
                width: 90,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Image.network(
                      'https://cdn.pixabay.com/photo/2017/03/09/12/31/error-2129569_960_720.jpg'),
                  imageUrl: item.imageUrl,
                ),
              ),
              Container(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        item.itemName,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Fryo',
                            fontSize: 15),
                      ),
                    ),
                    Text(
                      '₹ ${item.rate * item.quantity}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Fryo',
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 110,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '₹ ' + item.rate.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeItemCallback(
                            product,
                            item,
                          ),
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 30,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              subItemCallback(
                                product,
                                item,
                              );
                            }),
                        Text(
                          item.quantity.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            addItemCallback(
                              product,
                              item,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          endIndent: 15,
          indent: 15,
        )
      ],
    );
  }
}
