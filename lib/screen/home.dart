import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/model/user_model.dart';
import 'package:booking_stadium/screen/history_page.dart';
import 'package:booking_stadium/screen/show_stadium.dart';
import 'package:flutter/material.dart';

import 'information_page.dart';
import 'my_booking_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final screens = [
    ShowStadium(),
    MyBooking(),
    History(),
    Information(
      userModel: UserModel(),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'จองสนาม',
            backgroundColor: kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'รายการจอง',
            backgroundColor: kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'ประวัติ',
            backgroundColor: kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'ข้อมูลนิสิต',
            backgroundColor: kPrimaryColor,
          )
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
