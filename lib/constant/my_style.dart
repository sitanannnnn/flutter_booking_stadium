import 'package:flutter/material.dart';

class MyStyle {
  SizedBox mySizebox() => const SizedBox(
        width: 10.0,
        height: 18.0,
      );
  Widget titleCenter(String string) {
    return Center(
      child: Text(
        string,
        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Image showLogo() {
  //   return Image.asset('assets/images/1.jpg');
  // }

  Widget showProgress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Image showBackgroud() {
    return Image.asset('assets/images/backgroud.jpg');
  }
}
