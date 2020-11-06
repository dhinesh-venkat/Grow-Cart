import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_shop/models/api_response.dart';
import 'package:easy_shop/models/product.dart';
import 'package:easy_shop/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import './loading_animation.dart';
import '../models/cart.dart';
//import 'package:number_inc_dec/number_inc_dec.dart';

class ProductsGrid extends StatefulWidget {
  // const ProductsGrid({Key key, this.groupId, this.subGroupId})
  //     : super(key: key);

  final String groupId;
  final String subGroupId;

  ProductsGrid({this.groupId, this.subGroupId});
  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  ProductService get service => GetIt.I<ProductService>();

  APIResponse<List<Product>> _apiResponse;
  bool _isLoading = false;
  List<String> _selectedPackage = [];
  List<bool> _favorites = [];
  List<bool> _isAdded = [];
  List<Map<String, List<String>>> _prices = [];
  List<Map<String, String>> _selectedPrices = [];
  int _temp = 0;
  int _crossAxisCount = 0;

  TextStyle itemNameText = const TextStyle(
      color: Colors.cyan,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins');

  TextStyle priceText = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w800,
      fontFamily: 'Fryo');

  @override
  void initState() {
    _fetchProducts();
    super.initState();
  }

  _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse =
        await service.getProductList(widget.groupId, widget.subGroupId);
    for (int i = 0; i < _apiResponse.data.length; i++) {
      _selectedPackage.add(_apiResponse.data[i].data[0].code);
      _favorites.add(false);
      _isAdded.add(false);
      _prices.add({
        'mrp': _apiResponse.data[i].data.map((e) => e.mRP).toList(),
        'sr': _apiResponse.data[i].data.map((e) => e.sellingRate).toList(),
      });
      _selectedPrices.add({
        'mrp': _apiResponse.data[i].data[0].mRP,
        'sr': _apiResponse.data[i].data[0].sellingRate
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void onSelectedPackage(String value, int index) {
    for (int i = 0; i < _apiResponse.data[index].data.length; i++) {
      if (_apiResponse.data[index].data[i].code == value) {
        _temp = i;
      }
    }
    setState(() {
      _selectedPackage[index] = value;
      _selectedPrices[index]['mrp'] = _prices[index]['mrp'][_temp];
      _selectedPrices[index]['sr'] = _prices[index]['sr'][_temp];
      _isAdded[index] = false;
    });
  }

  double getTotal(int quantity, String price) {
    return quantity * double.parse(price);
  }

  int getDeviceType(double width) {
    if (width < 700) {
      return 2;
    }
    if (width < 900) {
      return 3;
    }
    if (width > 900) {
      return 5;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    _crossAxisCount = getDeviceType(deviceWidth);
    final cart = Provider.of<Cart>(context, listen: false);
    print("GroupId : " + widget.groupId);
    print("SubGroupId : " + widget.subGroupId);
    return RelativeBuilder(
      builder: (context, screenHeight, screenWidth, sy, sx) {
        if (_isLoading) {
          return loadingAnimation();
        }
        if (_apiResponse.error) {
          return Center(child: Text(_apiResponse.errorMessage));
        }
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: StaggeredGridView.countBuilder(
              scrollDirection: Axis.vertical,
              crossAxisCount: _crossAxisCount,
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              physics: ClampingScrollPhysics(),
              itemCount: _apiResponse.data.length,
              itemBuilder: (BuildContext _, int item) {
                return Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: sy(110),
                        width: sy(110),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blueGrey.withOpacity(0.2),
                                  offset: Offset(10, 10),
                                  blurRadius: 10),
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  offset: Offset(-10, -10),
                                  blurRadius: 10),
                            ]),
                        child: CachedNetworkImage(
                            placeholder: (context, url) => Image.network(
                                'https://cdn.pixabay.com/photo/2017/03/09/12/31/error-2129569_960_720.jpg'),
                            imageUrl: _apiResponse.data[item].imageName),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            _apiResponse.data[item].itemName,
                            style: itemNameText,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Text(
                              '₹ ' + _selectedPrices[item]['mrp'],
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.yellow),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              '₹ ' + _selectedPrices[item]['sr'],
                              style: priceText,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: getDropDownForPacking(
                              _apiResponse.data[item].data, item),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.blue,
                            size: 30,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            cart.addItem(
                                _apiResponse.data[item].itemId +
                                    _selectedPackage[item],
                                double.parse(_selectedPrices[item]['sr']),
                                _apiResponse.data[item].itemName,
                                _apiResponse.data[item].imageName,
                                double.parse(_selectedPrices[item]['sr']),
                                1);
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Added to cart'),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  setState(() {
                                    _isAdded[item] = false;
                                  });
                                  cart.removeSingleItem(
                                      _apiResponse.data[item].itemId);
                                },
                              ),
                            ));
                          },
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                          icon: _favorites[item]
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                ),
                          onPressed: () {
                            setState(() {
                              _favorites[item] = !_favorites[item];
                            });
                          }),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }

  Widget getDropDownForPacking(List<Data> list, int index) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      style: TextStyle(color: Colors.white),
      dropdownColor: Colors.black,
      elevation: 8,
      value: _selectedPackage[index],
      items: list.map((item) {
        return DropdownMenuItem<String>(
          child: Text(item.qtyLbl),
          value: item.code,
        );
      }).toList(),
      onChanged: (value) => onSelectedPackage(value, index),
    ));
  }
}
