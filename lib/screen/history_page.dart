import 'dart:convert';

import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/model/history_booking_stadium_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_detail_history.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryBookingStadiumModel> historybookingstadiumModels = [];
  String? date;
  @override
  @override
  void initState() {
    super.initState();
    readHistoryBookingStadium();
    DateTime dateTime = DateTime.now();
    date = DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<Null> readHistoryBookingStadium() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? stu_id = preferences.getString("stu_id");
    print("stu $stu_id");
    print("dateee==>$date");
    String url =
        '${Env().domaingetData}/getHistoryBookingStadium.php?isAdd=true&stu_id=$stu_id&bkd_date=$date';
    Response response = await Dio().get(url);
    print('res = $response');
    if (response.toString() == 'null') {
    } else {
      var result = json.decode(response.data);
      print('result= $result');
      for (var map in result) {
        HistoryBookingStadiumModel historyBookingStadiumModel =
            HistoryBookingStadiumModel.fromJson(map);
        setState(() {
          historybookingstadiumModels.add(historyBookingStadiumModel);
        });
      }
    }
  }

  //แปลงค่าค่าarray-->string
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
          title: const Text('ประวัติ'),
        ),
        body: historybookingstadiumModels.isEmpty
            ? Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ไม่มีประวัติรายการจอง",
                          style: const TextStyle(fontSize: 20))
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: historybookingstadiumModels.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailHistory(
                                historyBookingStadiumModel:
                                    historybookingstadiumModels[index],
                              ),
                            ));
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  height:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    '${Env().domaingetpicture}${historybookingstadiumModels[index].stdUrlPicture}',
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("สนาม",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Expanded(
                                                    flex: 0,
                                                    child: Text(
                                                      historybookingstadiumModels[
                                                              index]
                                                          .stdName!,
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("สนามย่อย",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  historybookingstadiumModels[
                                                                  index]
                                                              .substdId ==
                                                          null
                                                      ? const Text("-",
                                                          style: TextStyle(
                                                              fontSize: 20))
                                                      : Expanded(
                                                          flex: 0,
                                                          child: Text(
                                                            historybookingstadiumModels[
                                                                    index]
                                                                .substdName!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("วันที่",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                    historybookingstadiumModels[
                                                            index]
                                                        .bkdDate!,
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("เวลา",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      "${historybookingstadiumModels[index].bkdTime!.toString().substring(0, 5)} น.",
                                                      style: const TextStyle(
                                                          fontSize: 18))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )));
  }
}
