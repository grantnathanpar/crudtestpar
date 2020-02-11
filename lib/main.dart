import 'package:flutter/material.dart';
import './screens/login.dart';
import './screens/home.dart';
import './screens/uploading.dart';
import './screens/photooptions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        UploadingScreen.routeName: (ctx) => UploadingScreen(),
        PhotooptionsScreen.routeName: (ctx) => PhotooptionsScreen(),
      },
    );
  }
}
