import 'dart:convert';
import 'dart:developer';

import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/constant/show_image.dart';
import 'package:booking_stadium/model/show_substadium_model.dart';
import 'package:booking_stadium/model/stadium_close_model.dart';
import 'package:booking_stadium/model/stadium_model.dart';
import 'package:booking_stadium/screen/show_datatable_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'booking_stadium.dart';

class ShowStadium extends StatefulWidget {
  const ShowStadium({Key? key}) : super(key: key);

  @override
  _ShowStadiumState createState() => _ShowStadiumState();
}

class _ShowStadiumState extends State<ShowStadium> {
  @override
  List<StadiumModel> stadiumModels = [];
  List<ShowSubstadiumModel> showsubstadiumModels = [];
  String? datenow, staId, checkTime, std_id, date_Time;
  List<String> openstatus = [];
  bool loadStatus = true;
  bool substd_id = true;
  //ประกาศตัวแปร 3 ตัว ในการเช็คเวลา
  DateTime? startTime;
  DateTime? endTime;
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    DateTime dateTime = DateTime.now();
    date_Time = DateFormat('yyyy-MM-dd').format(dateTime);
    datenow = DateFormat('dd/MM/yyyy').format(dateTime);

    print('date now $date_Time');
    readStadium().then((value) {
      setState(() {
        loadStatus = false;
      });
    });
    //เซตเวลาเริมต้นเป็น 9.00
    startTime =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 09, 00);
    //เซตเวลาสิ้นสุดเป็น 15.00
    endTime =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 15, 00);
  }

  //สร้างฟังก์ชันตรวจสอบเวลา โดยรับค่าเป็นเวลาปัจจุบันที่กดปุ่ม (ตอนกดปุ๋มให้เซตสเตตัวแปร  currentTime = DateTime.now(); อีกรอบ แล้วส่งค่าที่เซ็ตสเตท currentTime มาในฟังก์ชันนี้เพื่อเปรียบเทียบ รีเทินค่า true คือ จองได้อยู่ในช่วงเวลา รีเทิน false คือ จองไม่ได้ ไม่อยู่ใชาวงเวลา)
  bool checkTimeBooking(DateTime currenttTimeOnTap) {
    if ((currenttTimeOnTap.isAfter(startTime!) ||
            currenttTimeOnTap.isAtSameMomentAs(startTime!)) &&
        (currenttTimeOnTap.isBefore(endTime!) ||
            currenttTimeOnTap.isAtSameMomentAs(endTime!))) {
      print('จองได้ เวลากดจอง $currenttTimeOnTap');
      return true;
    } else {
      print('จองไม่ได้ เวลากดจอง $currenttTimeOnTap');
      return false;
    }
  }
  //ตัวอย่างเวลาเรียกใช้ฟังก์ชัน แล้วต้องการกำหนดเวลาเอง ให้แก้ตรง 08=ชั่วโมง 59 = นาที
//checkTimeBooking(DateTime(currentTime.year, currentTime.month, currentTime.day, 08, 59));

//อ่านข้อมูลสนามทั้งหมด
  Future<Null> readStadium() async {
    String url =
        '${Env().domaingetData}/getStadiumWhereDateTime.php?isAdd=true&dateTime=$date_Time';
    Response response = await Dio().get(url);
    // print('res = $response');

    var result = json.decode(response.data);
    print('result stasium = $result');
    for (var map in result) {
      StadiumModel stadiumModel = StadiumModel.fromJson(map);
      setState(() {
        stadiumModels.add(stadiumModel);
      });
    }
  }

// //อ่านข้อมูลสนามที่ปิด
//   Future<Null> readStadiumClose() async {
//     for (int index = 0; index < stadiumModels.length; index++) {
//       String? id = stadiumModels[index].stdId;
//       print("std_id-->$id");
//       String url =
//           '${Env().domaingetData}/getStadium_close.php?isAdd=true&std_id=$id&stdclosed_date =$datenow';
//       Response response = await Dio().get(url);
//       print('res = $response');
//       if (response.toString() == 'null') {
//         openstatus.add(id!);
//       } else {
//         var result = json.decode(response.data);
//         print('result close = $result');
//         for (var map in result) {
//           StadiumCloseModel stadiumCloseModel = StadiumCloseModel.fromJson(map);
//           setState(() {
//             stadiumcloseModels.add(stadiumCloseModel);
//           });
//         }
//       }
//     }
//     print("openstatus-->$openstatus");

//     // inspect(stadiumcloseModels);
//   }

  // //เช็คสนามเปิด-ปิด
  // bool checkStatus(String id) {
  //   for (var i = 0; i < openstatus.length; i++) {
  //     print("aomam==>${openstatus[i]}");
  //     if (id == openstatus[i]) {
  //       print("true");
  //       return true;
  //       break;
  //       //มีเปิดสนาม
  //     }
  //   }
  //   return false;
  // }

  //อ่านข้อมูลสนามที่มีสนามย่อย
  Future<Null> readSubStadium() async {
    for (int index = 0; index < stadiumModels.length; index++) {
      std_id = stadiumModels[index].stdId;
      String url =
          '${Env().domaingetData}/getShowSubStadium.php?isAdd=true&std_id=$std_id';
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'null') {
        substd_id = false;
        print("sub==>$substd_id");
      } else {
        substd_id = true;
        print("sub==>$substd_id");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: const Text('จองสนาม'),
        ),
        body: loadStatus
            ? MyStyle().showProgress()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "จองสนามวันที่",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          datenow!,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: stadiumModels.length,
                        itemBuilder: (context, index) => GestureDetector(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 160,
                                decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: new Offset(2.0, 2.0),
                                        blurRadius: 10.0,
                                      )
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 100,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '${Env().domaingetpicture}${stadiumModels[index].stdUrlPicture}',

                                              //filterQuality: FilterQuality.high,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        '${Env().domaingetpicture}${stadiumModels[index].stdUrlPicture}',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                              placeholder: (context, url) =>
                                                  MyStyle().showProgress(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      ShowImage(
                                                          path: MyStyle
                                                              .image_stadium),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 220,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        stadiumModels[index]
                                                            .stdName!,
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false, // user must tap button!
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    'ข้อปฏิบัติการใช้',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        ListBody(
                                                                      children: [
                                                                        Text(
                                                                            stadiumModels[index]
                                                                                .stdName!,
                                                                            style:
                                                                                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                        Text(
                                                                          stadiumModels[index]
                                                                              .stdProcedure!,
                                                                          style:
                                                                              const TextStyle(fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'ตกลง',
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.red)),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.help_outline,
                                                            color: Colors.red,
                                                          ))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "วันที่",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        datenow!,
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "สถานะ",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      stadiumModels[index]
                                                                  .stdclosedId
                                                                  .toString() ==
                                                              'null'
                                                          ? Text(
                                                              "เปิด",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : Text(
                                                              "ปิด",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "หมายเหตุ",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      stadiumModels[index]
                                                                  .stdclosedNote
                                                                  .toString() ==
                                                              'null'
                                                          ? Text("-",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                              ))
                                                          : Text("")
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      stadiumModels[index]
                                                                  .stdclosedNote
                                                                  .toString() ==
                                                              'null'
                                                          ? Text("",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                              ))
                                                          : Expanded(
                                                              child: Text(
                                                                  stadiumModels[
                                                                          index]
                                                                      .stdclosedNote!,
                                                                  maxLines: 5,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .red)),
                                                            )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          stadiumModels[index]
                                                      .stdclosedId
                                                      .toString() ==
                                                  'null'
                                              ? ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: Colors.green,
                                                      onPrimary: Colors.white,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)))),
                                                  onPressed: () {
                                                    setState(() {
                                                      currentTime =
                                                          DateTime.now();
                                                      print(
                                                          "time==>$currentTime");
                                                    });
                                                    print(
                                                        "you click index --> $index");
                                                    checkTimeBooking(
                                                            currentTime)
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    BookingStadium(
                                                                        stadiumModel:
                                                                            stadiumModels[
                                                                                index])))
                                                        : showTopSnackBar(
                                                            context,
                                                            CustomSnackBar
                                                                .error(
                                                              message:
                                                                  "กรุณาจองสนามภายในเวลา 09.00 น -15.00 น",
                                                            ));
                                                  },
                                                  child: const Text("จอง"))
                                              : Text(""),
                                          const SizedBox(width: 5),
                                          stadiumModels[index]
                                                      .stdclosedId
                                                      .toString() ==
                                                  'null'
                                              ? ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: Colors.green,
                                                      onPrimary: Colors.white,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)))),
                                                  onPressed: () {
                                                    // readSubStadium();
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ShowDataTableScreen(
                                                                  std_id: stadiumModels[
                                                                          index]
                                                                      .stdId,
                                                                )));
                                                  },
                                                  child:
                                                      const Text("ดูรายชื่อ"))
                                              : Text("")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )))
                  ],
                ),
              ));
  }
}
