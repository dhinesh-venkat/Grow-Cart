// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import './services/group_service.dart';
import './services/sub_group_service.dart';
import './services/product_service.dart';
import './models/cart.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import './app.dart';
import './simple_bloc_observer.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => GroupService());
  GetIt.I.registerLazySingleton(() => SubGroupService());
  GetIt.I.registerLazySingleton(() => ProductService());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  setupLocator();
  runApp(
      //     DevicePreview(builder: (context) => ChangeNotifierProvider(
      //   create: (context) => Cart(),
      //   child: MyApp(),
      // ),)
      ChangeNotifierProvider(
          create: (context) => Cart(),
          child: App(authenticationRepository: AuthenticationRepository())));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key key}) : super(key: key);

//   static const BASE_URL = "http://sksapi.suninfotechnologies.in/";

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Easy Shop",
//       theme: ThemeData(
//           primaryColor: Color.fromRGBO(66, 67, 69, 1),
//           accentColor: Colors.orange,
//           fontFamily: 'Poppins',
//           textTheme: TextTheme(
//             headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//             headline3: TextStyle(
//                 fontSize: 36.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white),
//             headline4: TextStyle(fontSize: 24, color: Colors.white),
//             bodyText2: TextStyle(
//                 fontSize: 14.0, fontFamily: 'Fryo', color: Colors.white),
//           )),
//       home: Splash(),
//       routes: {
//         HomePage.routeName: (_) => HomePage(),
//         CartScreen.routeName: (_) => CartScreen(),
//       },
//     );
//   }
// }
