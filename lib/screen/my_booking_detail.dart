import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/model/booking_stadium_model.dart';
import 'package:booking_stadium/model/history_booking_stadium_model.dart';
import 'package:booking_stadium/screen/booking_detail.dart';
import 'package:booking_stadium/screen/my_booking_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyBookingDetail extends StatefulWidget {
  final BookingStadiumModel bookingStadiumModel;
  const MyBookingDetail({
    Key? key,
    required this.bookingStadiumModel,
  }) : super(key: key);

  @override
  State<MyBookingDetail> createState() => _MyBookingDetailState();
}

class _MyBookingDetailState extends State<MyBookingDetail> {
  BookingStadiumModel? bookingStadiumModel;
  List<List<String>> listnameMembers = [];
  List<String> namemembers = [];
  //ประกาศตัวแปร 3 ตัว ในการเช็คเวลา
  bool loadStatus = true;
  bool? haveData;
  DateTime? startTime;
  DateTime? endTime;
  DateTime currentTime = DateTime.now();
  String? bkd_id;
  @override
  void initState() {
    super.initState();
    bookingStadiumModel = widget.bookingStadiumModel;
    ShowMember();
    //เซตเวลาเริมต้นเป็น 9.00
    startTime =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 09, 00);
    //เซตเวลาสิ้นสุดเป็น 15.00
    endTime =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 20, 00);
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

  Future<void> ShowMember() async {
    namemembers = changeArray(bookingStadiumModel!.bkdMember!);
    setState(() {
      listnameMembers.add(namemembers);
      print("name===>$listnameMembers");
    });
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

  Future<Null> deleteBookingStadium() async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'คุญต้องการยกเลิกการจอง',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("${bookingStadiumModel!.stdName}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text("วันที่ ${bookingStadiumModel!.bkdDate}",
                    style: const TextStyle(fontSize: 20)),
                Text(
                    "เวลา ${bookingStadiumModel!.bkdTime!.toString().substring(0, 5)} น.",
                    style: const TextStyle(fontSize: 20))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก',
                  style: TextStyle(fontSize: 20, color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ยืนยัน',
                  style: TextStyle(fontSize: 20, color: Colors.green)),
              onPressed: () async {
                String url =
                    '${Env().domainDelete}/deleteBooking.php?isAdd=true&bkd_id=$bkd_id';
                await Dio().get(url).then((value) {
                  setState(() {
                    loadStatus = false;
                    haveData = false;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyBooking()));
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: const Text("ข้อมูลการจอง")),
      body: SingleChildScrollView(
        child: buildDetail(),
      ),
    );
  }

  Widget buildDetail() => ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: 1,
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
                      Text(bookingStadiumModel!.stdName!,
                          style: const TextStyle(fontSize: 20))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("สนามย่อย",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      bookingStadiumModel!.substdId == null
                          ? const Text("-", style: TextStyle(fontSize: 20))
                          : Text(bookingStadiumModel!.substdName!,
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
                        bookingStadiumModel!.bkdDate!,
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
                          "${bookingStadiumModel!.bkdTime!.toString().substring(0, 5)} น.",
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
                                  '${Env().domaingetpicture}${bookingStadiumModel!.stdUrlPicture}',
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
                          bookingStadiumModel!.stdDescripLocation!,
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
                          bookingStadiumModel!.stdProcedure!,
                          style: const TextStyle(fontSize: 20),
                          maxLines: 100,
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
                          bkd_id = bookingStadiumModel!.bkdId;
                          print("bkd_id===$bkd_id");
                          bkd_id = bookingStadiumModel!.bkdId!;
                          checkTimeBooking(currentTime)
                              ? deleteBookingStadium()
                              : showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
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
                                                  color: Colors.blue)),
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
