import 'package:flutter/cupertino.dart';
import 'package:easy_shop/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryScreen extends StatefulWidget {
  DeliveryScreen({Key key}) : super(key: key);

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  //bool gmapSelected = false;
  TextEditingController doorNo = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController contackNumber = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  bool loading = false;
  LatLng _target;
  void getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _target = LatLng(
        position.latitude,
        position.longitude,
      );
      //isLoaded = true;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('Delivery Address'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: MyColors.primaryColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 5,
                          ),
                          Center(
                            child:
                                Text('''We will automatically get your location 
so please enable GPS'''),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.accentColor),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      controller: doorNo,
                      //clearButtonMode: OverlayVisibilityMode.editing,
                      keyboardType: TextInputType.streetAddress,
                      maxLines: 1,
                      placeholder: 'Door No',
                    ),
                  ),
                  Container(
                    height: 40,
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.accentColor),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      controller: street,
                      //clearButtonMode: OverlayVisibilityMode.editing,
                      keyboardType: TextInputType.streetAddress,
                      maxLines: 1,
                      placeholder: 'Street Name',
                    ),
                  ),
                  Container(
                    height: 40,
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.accentColor),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      controller: address,
                      //clearButtonMode: OverlayVisibilityMode.editing,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      placeholder: 'Address',
                    ),
                  ),
                  Container(
                    height: 40,
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.accentColor),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      controller: pincode,
                      //clearButtonMode: OverlayVisibilityMode.editing,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      placeholder: 'Area Pincode',
                    ),
                  ),
                  Container(
                    height: 40,
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.accentColor),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      controller: contackNumber,
                      //clearButtonMode: OverlayVisibilityMode.editing,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      placeholder: 'Contact Number',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Center(
                  //       child: Text('SKS CARD HOLDER?',
                  //           style: TextStyle(
                  //               color: Colors.red,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 20)),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Center(
                  //       child: Text(
                  //         'Card or Phone Number',
                  //         style: TextStyle(
                  //             color: Colors.orange,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 17),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(flex: 1, child: SizedBox()),
                  //     Expanded(
                  //       flex: 2,
                  //       child: Container(
                  //         height: 40,
                  //         child: TextField(
                  //           controller: cardNumber,
                  //           autocorrect: true,
                  //           decoration: InputDecoration(
                  //             // hintText: 'Type Text Here...',
                  //             hintStyle: TextStyle(color: Colors.grey),
                  //             filled: true,
                  //             fillColor: Colors.white70,
                  //             enabledBorder: OutlineInputBorder(
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(12.0)),
                  //               borderSide:
                  //                   BorderSide(color: Colors.red, width: 1),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(10.0)),
                  //               borderSide: BorderSide(color: Colors.red),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(flex: 1, child: SizedBox()),
                  //   ],
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                      },
                      color: MyColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: loading
                            ? Center(child: CircularProgressIndicator())
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Next',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      color: MyColors.accentColor,
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
            ],
          ),
        ),
      ),
    );
  }
}

// class GoogleMaps extends StatefulWidget {
//   const GoogleMaps({
//     Key key,
//   }) : super(key: key);

//   @override
//   _GoogleMapsState createState() => _GoogleMapsState();
// }

// class _GoogleMapsState extends State<GoogleMaps> {
//   Completer<GoogleMapController> _controller = Completer();
//   bool currentViewisNormal = true;
//   void _onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);
//   }

//   bool isLoaded = false;
//   LatLng _target;
//   void getCurrentLocation() async {
//     Position position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _target = LatLng(
//         position.latitude,
//         position.longitude,
//       );
//       isLoaded = true;
//     });
//   }

//   @override
//   void initState() {
//     getCurrentLocation();
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     if (isLoaded) {
//       return SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: 270,
//         child: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constrains) {
//             return Stack(
//               children: <Widget>[
//                 Center(
//                   child: GoogleMap(
//                     mapType: currentViewisNormal
//                         ? MapType.normal
//                         : MapType.satellite,
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     onMapCreated: _onMapCreated,
//                     initialCameraPosition:
//                         CameraPosition(target: _target, zoom: 11.0),
//                     onCameraMove: (position) {
//                       //  setState(() {
//                       //print(position.target.latitude);
//                       //print(position.target.longitude);
//                       //  });
//                       _target = LatLng(
//                           position.target.latitude, position.target.longitude);
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8, left: 8),
//                   child: Opacity(
//                     opacity: 0.7,
//                     child: FloatingActionButton(
//                         elevation: 0.0,
//                         //foregroundColor: Colors.white,

//                         mini: true,
//                         backgroundColor: Colors.white,
//                         child: Icon(
//                           currentViewisNormal ? Icons.map : Icons.satellite,
//                           color: Colors.black54,
//                         ),
//                         shape: RoundedRectangleBorder(),
//                         onPressed: () {
//                           setState(() {
//                             if (currentViewisNormal) {
//                               currentViewisNormal = false;
//                             } else {
//                               currentViewisNormal = true;
//                             }
//                           });
//                         }),
//                   ),
//                 ),
//                 Positioned(
//                   height: constrains.maxHeight - 36,
//                   width: constrains.maxWidth,
//                   child: Icon(
//                     Icons.location_on,
//                     color: Colors.red,
//                     size: 36,
//                   ),
//                 ),
//                 Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Opacity(
//                       opacity: 0.7,
//                       child: RaisedButton(
//                           child: Text(
//                             'Confirm',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18.0),
//                             side: BorderSide(color: Colors.black54),
//                           ),
//                           onPressed: () {
//                             print(_target);
//                           }),
//                     ))
//               ],
//             );
//           },
//         ),
//       );
//     } else {
//       return SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: 270,
//         child: Container(
//           child: Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       );
//     }
//   }
// }
