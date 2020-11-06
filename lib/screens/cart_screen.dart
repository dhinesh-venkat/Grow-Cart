import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_shop/PhLogin/Model/location_detail.dart';
import 'package:easy_shop/Utils/theme.dart';
import 'package:easy_shop/models/cart.dart';
import 'package:easy_shop/screens/delivary_screen.dart';
import 'package:easy_shop/services/location_serviced.dart';
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
                  style: TextStyle(color: Colors.blue.shade200),
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
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Row(
                    children: [
                      Text(
                        '${cart.itemCount} items',
                        style: Theme.of(context).textTheme.bodyText2,
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                constraints: const BoxConstraints(maxWidth: 500),
                child: RaisedButton(
                  onPressed: () {
                    if (cart.items.length > 0) {
                      setState(() {
                        loading = true;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return StreamProvider<UserLocation>(
                            create: (context) =>
                                LocationService().locationStream,
                            child: DeliveryScreen(),
                          );
                        }
                            // } => DeliveryScreen(
                            //     // user: user,
                            //     ),
                            ),
                      );
                    }
                  },
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Check Out',
                                style: TextStyle(
                                    color: MyColors.primaryColor, fontSize: 20),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: MyColors.primaryColorLight,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
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
                            color: Colors.white,
                            fontFamily: 'Fryo',
                            fontSize: 15),
                      ),
                    ),
                    Text(
                      '₹ ${item.rate * item.quantity}',
                      style: TextStyle(
                          color: Colors.white,
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
                        Text('₹ ' + item.rate.toString()),
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
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 30,
                              color: Colors.white,
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
                          style: TextStyle(fontSize: 15),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
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
