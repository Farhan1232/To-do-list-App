// ignore_for_file: unused_import, avoid_web_libraries_in_flutter, must_be_immutable

//import 'dart:js';

//import 'dart:js';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testingfirebase/Crud_operation/Firestore_Crud.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyC6ChXdG2TryiwcA5x29EpvDlk4iTxPkGo",
          appId: "1:383921684130:android:498804ea202a19bf62e1fb",
          messagingSenderId: "383921684130",
          projectId: "testing-fd449",
        ))
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 390),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          home: FirebaseCrud(),
        );
      },
    );
  }
}
