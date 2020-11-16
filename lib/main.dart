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
