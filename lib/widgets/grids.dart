import 'package:easy_shop/models/api_response.dart';
import 'package:easy_shop/models/group.dart';
import 'package:easy_shop/services/group_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import '../screens/sub_groups.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:relative_scale/relative_scale.dart';

class Grids extends StatefulWidget {
  //const Grids({Key key}) : super(key: key);

  @override
  _GridsState createState() => _GridsState();
}

class _GridsState extends State<Grids> {
  GroupService get service => GetIt.I<GroupService>();

  APIResponse<List<Group>> _apiResponse;
  bool _isLoading = false;
  int _crossAxisCount = 0;
  TextStyle itemNameText = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins');

  @override
  void initState() {
    _fetchGroups();
    super.initState();
  }

  _fetchGroups() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getGroupList();
    setState(() {
      _isLoading = false;
    });
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
    return RelativeBuilder(
      builder: (context, screenHeight, screenWidth, sy, sx) {
        if (_isLoading) {
          return Center(
              child: Text(
            "Loading...",
            style: TextStyle(color: Colors.white),
          ));
        }
        if (_apiResponse.error) {
          return Center(child: Text(_apiResponse.errorMessage));
        }
        return StaggeredGridView.countBuilder(
          crossAxisCount: _crossAxisCount,
          itemCount: _apiResponse.data.length,
          physics: ClampingScrollPhysics(),
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          shrinkWrap: true,
          itemBuilder: (context, item) {
            return Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SubGroupScreen(
                                groupID: _apiResponse.data[item].id,
                                groupTitle: _apiResponse.data[item].value,
                              )));
                    },
                    child: Container(
                      height: sy(110),
                      width: sy(110),
                      decoration: BoxDecoration(color: Colors.white,
                          //  borderRadius: BorderRadius.circular(15),
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
                          imageUrl: _apiResponse.data[item].imageUrl),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 35),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        _apiResponse.data[item].value,
                        style: itemNameText,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        // return GridView.builder(
        //     physics: ScrollPhysics(),
        //     shrinkWrap: true,
        //     padding: EdgeInsets.all(10),
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: deviceWidth > deviceHeight ? 5 : 2,
        //       childAspectRatio: 1,
        //       crossAxisSpacing: 1,
        //       mainAxisSpacing: 1,
        //     ),
        //     itemCount: _apiResponse.data.length,
        //     itemBuilder: (BuildContext _, int item) {
        //       return Container(
        //         height: 180,
        //         width: 180,
        //         margin: EdgeInsets.all(1),
        //         child: Stack(
        //           //    clipBehavior: Clip.none,
        //           overflow: Overflow.visible,
        //           children: <Widget>[
        //             Container(
        //               height: sy(500),
        //               width: sy(500),
        //               decoration: BoxDecoration(
        //                 boxShadow: [
        //                   BoxShadow(
        //                       color: Colors.blueGrey.withOpacity(0.2),
        //                       offset: Offset(5, 5),
        //                       blurRadius: 10),
        //                   BoxShadow(
        //                       color: Colors.black.withOpacity(0.7),
        //                       offset: Offset(-5, -5),
        //                       blurRadius: 10),
        //                 ],
        //               ),
        //               child: GestureDetector(
        //                 onTap: () {
        //                   Navigator.of(context).push(MaterialPageRoute(
        //                       builder: (_) => SubGroupScreen(
        //                             groupID: _apiResponse.data[item].id,
        //                             groupTitle: _apiResponse.data[item].value,
        //                           )));
        //                 },
        //                 child: Container(
        //                   color: Colors.white,
        //                   child: CachedNetworkImage(
        //                     placeholder: (context, url) => Image.network(
        //                         'https://cdn.pixabay.com/photo/2017/03/09/12/31/error-2129569_960_720.jpg'),
        //                     imageUrl: _apiResponse.data[item].imageUrl,
        //                     fit: BoxFit.fill,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             Positioned.fill(
        //                 bottom: 20,
        //                 child: Align(
        //                   alignment: Alignment.bottomCenter,
        //                   child: Text(_apiResponse.data[item].value,
        //                       overflow: TextOverflow.ellipsis,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.black)),
        //                 ))
        //           ],
        //         ),
        //       );
        //     });
      },
    );
  }
}
