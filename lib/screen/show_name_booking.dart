import 'dart:convert';

import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/model/show_name_booking_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowNameBooking extends StatefulWidget {
  final String bkd_id;
  ShowNameBooking({Key? key, required this.bkd_id}) : super(key: key);

  @override
  State<ShowNameBooking> createState() => _ShowNameBookingState();
}

class _ShowNameBookingState extends State<ShowNameBooking> {
  String? bkd_id;
  List<ShowNameBookingModel> shownameBookingModels = [];
  List<List<String>> listnameMembers = [];
  List<String> namemembers = [];
  bool loadStatus = true;
  int number = 1;
  @override
  @override
  void initState() {
    super.initState();
    bkd_id = widget.bkd_id;
    print("bkd==>$bkd_id");
    readBookingNameDetail();
  }

  Future<Null> readBookingNameDetail() async {
    String url =
        '${Env().domaingetData}/getShowNameBooking.php?isAdd=true&bkd_id=$bkd_id';
    Response response = await Dio().get(url);
    // print('res = $response');
    var result = json.decode(response.data);
    print('result booking stadium = $result');
    for (var map in result) {
      ShowNameBookingModel showNameBookingModel =
          ShowNameBookingModel.fromJson(map);
      namemembers = changeArray(showNameBookingModel.bkdMember!);

      setState(() {
        shownameBookingModels.add(showNameBookingModel);
        listnameMembers.add(namemembers);
        print("name===>$listnameMembers");
        loadStatus = false;
      });
    }
  }

  //แปลงค่าarray-->string
  List<String> changeArray(String string) {
    List<String> list = [];
    String myString = string.substring(1, string.length - 1);
    //print('myString =$myString');
    list = myString.split(',');
    int index = 0;
    for (String string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text("รายชื่อการจอง"),
        ),
        body: loadStatus
            ? MyStyle().showProgress()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 2.0 - 8.0,
                      height: MediaQuery.of(context).size.height * 0.4 - 8.0,
                      decoration: ShapeDecoration(
                          color: Colors.grey[350],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: ListView.builder(
                          itemCount: namemembers.length,
                          itemBuilder: (context, index) => Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      '${namemembers[index]}',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              )),
                    ),
                  )
                ],
              ));
  }
}
