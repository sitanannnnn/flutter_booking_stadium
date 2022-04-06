import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/model/history_booking_stadium_model.dart';
import 'package:flutter/material.dart';

class BookingDetailHistory extends StatefulWidget {
  final HistoryBookingStadiumModel historyBookingStadiumModel;
  const BookingDetailHistory(
      {Key? key, required this.historyBookingStadiumModel})
      : super(key: key);

  @override
  State<BookingDetailHistory> createState() => _BookingDetailHistoryState();
}

class _BookingDetailHistoryState extends State<BookingDetailHistory> {
  HistoryBookingStadiumModel? historyBookingStadiumModel;
  List<List<String>> listnameMembers = [];
  List<String> namemembers = [];
  @override
  void initState() {
    super.initState();
    historyBookingStadiumModel = widget.historyBookingStadiumModel;
    ShowMember();
  }

  Future<void> ShowMember() async {
    namemembers = changeArray(historyBookingStadiumModel!.bkdMember!);
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
                      Text(historyBookingStadiumModel!.stdName!,
                          style: const TextStyle(fontSize: 20))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("สนามย่อย",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      historyBookingStadiumModel!.substdId == null
                          ? const Text("-", style: TextStyle(fontSize: 20))
                          : Text(historyBookingStadiumModel!.substdName!,
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
                        historyBookingStadiumModel!.bkdDate!,
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
                          "${historyBookingStadiumModel!.bkdTime!.toString().substring(0, 5)} น.",
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
                                  '${Env().domaingetpicture}${historyBookingStadiumModel!.stdUrlPicture}',
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
                          historyBookingStadiumModel!.stdDescripLocation!,
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
                          historyBookingStadiumModel!.stdProcedure!,
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
