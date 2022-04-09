import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/screen/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Sarabun',
        primarySwatch: Colors.teal,
      ),
      home: const Login(),
    );
  }
}
