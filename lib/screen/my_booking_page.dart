import 'dart:convert';

import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/model/booking_stadium_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({Key? key}) : super(key: key);

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  List<BookingStadiumModel> bookingstadiumModels = [];
  bool loadStatus = true;
  String? date, bkd_id, checkTime;
  List<List<String>> listnameMembers = [];
  List<String> namemembers = [];

  @override
  @override
  void initState() {
    super.initState();
    readBookingStadium().then((value) {
      setState(() {
        loadStatus = false;
      });
    });
    DateTime dateTime = DateTime.now();
    date = DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<Null> readBookingStadium() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? stu_id = preferences.getString("stu_id");
    String url =
        '${Env().domaingetData}/getBookingStadium.php?isAdd=true&stu_id=$stu_id&bkd_date=$date';
    Response response = await Dio().get(url);
    // print('res = $response');
    if (response.toString() == 'null') {
      print("null");
    } else {
      var result = json.decode(response.data);
      print('result booking stadium = $result');
      for (var map in result) {
        BookingStadiumModel bookingStadiumModel =
            BookingStadiumModel.fromJson(map);
        namemembers = changeArray(bookingStadiumModel.bkdMember!);
        setState(() {
          bookingstadiumModels.add(bookingStadiumModel);
          listnameMembers.add(namemembers);
          print("name===>$listnameMembers");
        });
      }
    }
  }

  Future<Null> deleteBookingStadium() async {
    String url =
        '${Env().domainDelete}/deleteBooking.php?isAdd=true&bkd_id=$bkd_id';
    await Dio().get(url).then((value) => readBookingStadium());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: const Text("ข้อมูลการจอง")),
      body: bookingstadiumModels.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ไม่มีรายการจอง", style: const TextStyle(fontSize: 20))
                ],
              ),
            )
          : SingleChildScrollView(
              child: buildDetail(),
            ),
    );
  }

  Widget buildDetail() => ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: bookingstadiumModels.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Column(
            children: [
              MyStyle().mySizebox(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("สนาม",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(bookingstadiumModels[index].stdName!,
                          style: const TextStyle(fontSize: 20))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("สนามย่อย",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      bookingstadiumModels[index].substdId == null
                          ? const Text("-", style: TextStyle(fontSize: 20))
                          : Text(bookingstadiumModels[index].substdName!,
                              style: const TextStyle(fontSize: 20))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("วันที่",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        bookingstadiumModels[index].bkdDate!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("เวลา",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          "${bookingstadiumModels[index].bkdTime!.toString().substring(0, 5)} น.",
                          style: const TextStyle(fontSize: 20))
                    ],
                  ),
                  MyStyle().mySizebox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            image: DecorationImage(
                                image: NetworkImage(
                                  '${Env().domaingetpicture}${bookingstadiumModels[index].stdUrlPicture}',
                                ),
                                fit: BoxFit.cover)),
                      ),
                    ],
                  ),
                  MyStyle().mySizebox(),
                  const Divider(
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Text("ตำเเหน่งสนาม",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          bookingstadiumModels[index].stdDescripLocation!,
                          style: const TextStyle(fontSize: 20),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Text("ข้อปฏิบัติในการใช้สนาม",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          bookingstadiumModels[index].stdProcedure!,
                          style: const TextStyle(fontSize: 20),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Text("รายชื่อสมาชิก",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  buildListViewNameMember(index),
                  MyStyle().mySizebox(),
                  Column(
                    children: [
                      Text("***กรณียกเลิกการจอง***",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold)),
                      Text("ต้องยกเลิกในเวลา 09:00-15:00 น.",
                          style: TextStyle(fontSize: 20))
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        onPressed: () {
                          bkd_id = bookingstadiumModels[index].bkdId!;
                          checkTime =
                              TimeOfDay.now().toString().substring(10, 12);
                          print(TimeOfDay.now().toString().substring(10, 12));
                          checkTime == 09 &&
                                  checkTime == 10 &&
                                  checkTime == 11 &&
                                  checkTime == 12 &&
                                  checkTime == 13 &&
                                  checkTime == 14
                              ? showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'คุญต้องการยกเลิกการจอง',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                                "${bookingstadiumModels[index].stdName}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "วันที่ ${bookingstadiumModels[index].bkdDate}",
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                            Text(
                                                "เวลา ${bookingstadiumModels[index].bkdTime!.toString().substring(0, 5)} น.",
                                                style: const TextStyle(
                                                    fontSize: 20))
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('ยกเลิก',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('ยืนยัน',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.green)),
                                          onPressed: () {
                                            deleteBookingStadium();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'ไม่สามารถยกเลิกการจองได้',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                                "กรุณายกเลิกการจองสนามกีฬาเวลา",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("09.00 น -15.00 น",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('ตกลง',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                        },
                        child: const Text("ยกเลิกการจอง",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w200))),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  ListView buildListViewNameMember(int index) => ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: namemembers.length,
      itemBuilder: (context, index2) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      listnameMembers[index][index2],
                      style: const TextStyle(fontSize: 20),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ],
          ));
}
