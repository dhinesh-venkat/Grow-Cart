import 'package:easy_shop/widgets/grids.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key key}) : super(key: key);
  static const routeName = "/homeScreen";

  static final List<String> imgList = [
    "https://cdn.pixabay.com/photo/2017/11/02/09/04/drink-2910441_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/06/04/16/31/banner-2371477_960_720.jpg",
    "https://cdn.pixabay.com/photo/2018/02/04/23/58/easter-eggs-3131190_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/04/03/21/46/snacks-2199659_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/07/05/17/42/candy-1499082_960_720.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, screenHeight, screenWidth, sy, sx) {
        return Scaffold(
          drawer: AppDrawer(),
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            elevation: 0.0,
            bottomOpacity: 0.0,
            actions: [
              IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  })
            ],
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "Easy Shop",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: sy(20),
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                child: Container(
                  height: sy(140),
                  width: double.infinity,
                  margin:
                      EdgeInsets.only(left: sx(5), right: sx(5), top: sx(5)),
                  child: Swiper(
                    viewportFraction: 0.8,
                    scale: 0.9,
                    autoplay: true,
                    loop: true,
                    itemCount: imgList.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Image.network(
                          imgList[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: sy(14),
              ),
              Grids(),
            ],
          ),
        );
      },
    );
  }
}
