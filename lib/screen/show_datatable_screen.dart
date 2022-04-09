import 'dart:convert';
import 'dart:developer';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/constant/normal_dialog.dart';
import 'package:booking_stadium/model/field_booking_list_model.dart';
import 'package:booking_stadium/model/field_booking_list_no_substadium_model.dart';
import 'package:booking_stadium/screen/show_name_booking.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShowDataTableScreen extends StatefulWidget {
  final std_id;
  const ShowDataTableScreen({Key? key, this.std_id}) : super(key: key);

  @override
  State<ShowDataTableScreen> createState() => _ShowDataTableScreenState();
}

class _ShowDataTableScreenState extends State<ShowDataTableScreen> {
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  List<FieldBookingListModel> fieldbookinglistModels = [];
  List<FieldBookingListNoSubstadiumModel> fieldbookinglistnosubstadiumModels =
      [];
  bool loadDataStatus = true;
  String? std_id, bkd_id;
  bool? substd_id;

  @override
  void initState() {
    super.initState();
    std_id = widget.std_id;

    print("std_id===>$std_id");
    readFieldBookingHaveSubStadium().then((value) {
      setState(() {
        loadDataStatus = false;
      });
    });
    readFieldBookingNoSubStadium().then((value) {
      setState(() {
        loadDataStatus = false;
      });
    });
    readSubStadium().then((value) {
      setState(() {
        loadDataStatus = false;
      });
    });
  }

  //อ่านข้อมูลสนามที่มีสนามย่อย
  Future<Null> readSubStadium() async {
    String url =
        '${Env().domaingetData}/getShowSubStadium.php?isAdd=true&std_id=$std_id';
    Response response = await Dio().get(url);
    print('res = $response');
    if (response.toString() == 'null') {
      substd_id = false;
      print("substd_id==>$substd_id");
    } else {
      substd_id = true;
      print("substd_id==>$substd_id");
    }
  }

  //ฟังชั่นอ่านข้อมูลสถานที่มีสนามย่อย
  Future<void> readFieldBookingHaveSubStadium() async {
    if (fieldbookinglistModels.length != 0) {
      fieldbookinglistModels.clear();
    }
    String url =
        '${Env().domaingetData}/getShowFieldBookingList.php?isAdd=true&std_id=$std_id';
    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    print('result= $result');
    for (var map in result) {
      FieldBookingListModel fieldBookingListModel =
          FieldBookingListModel.fromJson(map);
      setState(() {
        fieldbookinglistModels.add(fieldBookingListModel);
      });
    }
  }

  //ฟังชั่นอ่านข้อมูลสถานที่ไม่มีสนามย่อย
  Future<void> readFieldBookingNoSubStadium() async {
    if (fieldbookinglistnosubstadiumModels.length != 0) {
      fieldbookinglistnosubstadiumModels.clear();
    }
    String url =
        '${Env().domaingetData}/getShowFieldBookingListNoSubStadium.php?isAdd=true&std_id=$std_id';
    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    print('result= $result');
    for (var map in result) {
      FieldBookingListNoSubstadiumModel fieldBookingListNoSubstadiumModel =
          FieldBookingListNoSubstadiumModel.fromJson(map);
      setState(() {
        fieldbookinglistnosubstadiumModels
            .add(fieldBookingListNoSubstadiumModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: const Text("รายชื่อการจองสนาม")),
      body: loadDataStatus
          ? MyStyle().showProgress()
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: AdaptiveScrollbar(
                width: 8,
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: Colors.grey.withOpacity(0.7),
                sliderActiveColor: Colors.grey,
                controller: _verticalScrollController,
                child: AdaptiveScrollbar(
                  width: 8,
                  controller: _horizontalScrollController,
                  position: ScrollbarPosition.bottom,
                  underColor: Colors.blueGrey.withOpacity(0.3),
                  sliderDefaultColor: Colors.grey.withOpacity(0.7),
                  sliderActiveColor: Colors.grey,
                  child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        controller: _horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text('สนามย่อย',
                                    style: const TextStyle(fontSize: 20)),
                              ),
                              DataColumn(
                                label: Text('เวลา',
                                    style: const TextStyle(fontSize: 20)),
                              ),
                              DataColumn(
                                label: Text('รายชื่อ',
                                    style: const TextStyle(fontSize: 20)),
                              ),
                              DataColumn(
                                label: Text('สถานะ',
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ],
                            rows: substd_id == true
                                ? buildFieldBookingList()
                                : buildFieldBookingListNoSubStadium())),
                  ),
                ),
              ),
            ),
    );
  }

  //เเสดงข้อมูลของสนามที่มีสนามย่อย
  List<DataRow> buildFieldBookingList() {
    return fieldbookinglistModels.map((fliedbookinglist) {
      return DataRow(cells: [
        DataCell(Text(fliedbookinglist.substdName.toString())),
        DataCell(Text(
            '${fliedbookinglist.bktStartTime.toString().substring(0, 5)} - ${fliedbookinglist.bktEndTime.toString().substring(0, 5)} ')),
        DataCell(TextButton(
          onPressed: () {
            bkd_id = fliedbookinglist.bkdId.toString();
            // for (int index = 0;
            //     index < fieldbookinglistModels.length;
            //     index++) {
            //   bkd_id = fieldbookinglistModels[index].bkdId;
            print("bkd_id==>$bkd_id");
            fliedbookinglist.bkdId.toString() == 'null'
                ? normalDialog(context, "ไม่มีรายชื่อการจอง")
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowNameBooking(
                              bkd_id: bkd_id!,
                            )));
            //}
          },
          child: const Text("ดูรายชื่อ"),
        )),
        DataCell(fliedbookinglist.bkdId.toString() == 'null'
            ? const Text(
                'ว่าง',
                style: TextStyle(color: Colors.green),
              )
            : const Text(
                'จองแล้ว',
                style: TextStyle(color: Colors.red),
              ))
      ]);
    }).toList();
  }

  //เเสดงข้อมูลของสนามที่ไม่มีสนามย่อย
  List<DataRow> buildFieldBookingListNoSubStadium() {
    return fieldbookinglistnosubstadiumModels
        .map((fliedbookinglistnosubstadium) {
      return DataRow(cells: [
        DataCell(Text(fliedbookinglistnosubstadium.stdName.toString())),
        DataCell(Text(
            '${fliedbookinglistnosubstadium.bktStartTime.toString().substring(0, 5)} - ${fliedbookinglistnosubstadium.bktEndTime.toString().substring(0, 5)} ')),
        DataCell(TextButton(
          onPressed: () {
            bkd_id = fliedbookinglistnosubstadium.bkdId.toString();
            print("bkd_id==>$bkd_id");
            fliedbookinglistnosubstadium.bkdId.toString() == 'null'
                ? normalDialog(context, "ไม่มีรายชื่อการจอง")
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowNameBooking(
                              bkd_id: bkd_id!,
                            )));
          },
          child: const Text("ดูรายชื่อ"),
        )),
        DataCell(fliedbookinglistnosubstadium.bkdId.toString() == 'null'
            ? const Text(
                'ว่าง',
                style: TextStyle(color: Colors.green),
              )
            : const Text(
                'จองแล้ว',
                style: TextStyle(color: Colors.red),
              ))
      ]);
    }).toList();
  }
}
