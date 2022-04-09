import 'dart:convert';

import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/model/stadium_model.dart';
import 'package:booking_stadium/model/sub_stadium_model.dart';
import 'package:booking_stadium/model/time_stadium_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';

import 'name_team_member.dart';

class BookingStadium extends StatefulWidget {
  final StadiumModel stadiumModel;
  const BookingStadium({Key? key, required this.stadiumModel})
      : super(key: key);

  @override
  _BookingStadiumState createState() => _BookingStadiumState();
}

class _BookingStadiumState extends State<BookingStadium> {
  StadiumModel? stadiumModel;
  List<SubStadiumModel> substadiumModels = [];
  List<TimeStadiumModel> timestadiumModels = [];
  String? std_id, time, date, bkt_id, getTime;
  bool loadStatus = true;
  @override
  void initState() {
    super.initState();
    stadiumModel = widget.stadiumModel;
    std_id = stadiumModel!.stdId;
    print("std_id==> $std_id");
    readSubStadium().then((value) => readTimeStadium().then((value) {
          setState(() {
            loadStatus = false;
          });
        }));

    //วันที่ปัจจุบัน
    DateTime dateTime = DateTime.now();
    date = DateFormat('yyyy-MM-dd').format(dateTime);
  }

  //เช็ควันที่เเละเวลาของการจองสนาม
  Future<void> cheackTimeBooking(int index) async {
    print("Time===>$time");
    print("Date===>$date");
    String url =
        '${Env().domaingetData}/getCheckBooking.php?isAdd=true&std_id=$std_id&bkd_date=$date&bkd_time=$time';
    Response response = await Dio().get(url);
    print('res is booking stadium = $response');
    if (response.toString() == 'null') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NameTeamMember(
                    subStadiumModel: substadiumModels[index],
                    time: time,
                    bkt_id: bkt_id,
                    std_id: std_id,
                    getTime: getTime,
                  )));
    } else {
      showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('Please select ',
                            style: TextStyle(fontSize: 25)),
                        const Text(' another time. ',
                            style: TextStyle(fontSize: 20)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                onPrimary: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'))
                      ],
                    ),
                  ],
                ),
              ));
    }
  }

  //อ่านข้อมูลสนามย่อย
  Future<Null> readSubStadium() async {
    String url =
        '${Env().domaingetData}/getSub_stadium.php?isAdd=true&std_id=$std_id';
    Response response = await Dio().get(url);
    // print('res = $response');

    var result = json.decode(response.data);
    print('result Sub stadium = $result');
    for (var map in result) {
      SubStadiumModel subStadiumModel = SubStadiumModel.fromJson(map);
      setState(() {
        substadiumModels.add(subStadiumModel);
      });
    }
  }

  //อ่านข้อมูลเวลาที่เปิดให้จองของสนาม
  Future<Null> readTimeStadium() async {
    String url =
        '${Env().domaingetData}/getTimeStadium.php?isAdd=true&std_id=$std_id';
    Response response = await Dio().get(url);
    // print('res = $response');

    var result = json.decode(response.data);
    print('result Time stadium = $result');
    for (var map in result) {
      TimeStadiumModel timeStadiumModel = TimeStadiumModel.fromJson(map);
      setState(() {
        timestadiumModels.add(timeStadiumModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text(stadiumModel!.stdName!),
      ),
      body: loadStatus
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: substadiumModels.length,
              itemBuilder: (context, index) => Column(
                    children: [
                      substadiumModels[index].substdId == null
                          ? Column(
                              children: [
                                //ไม่มีสนามย่อย
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(substadiumModels[index].stdName!,
                                        style: const TextStyle(fontSize: 25)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 350,
                                      height: 250,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                '${Env().domaingetpicture}${substadiumModels[index].stdUrlPicture}',
                                              ),
                                              fit: BoxFit.cover)),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          //มีสนามย่อย
                          : Column(
                              children: [
                                Text(substadiumModels[index].substdName!,
                                    style: const TextStyle(fontSize: 25)),
                                Container(
                                  width: 350,
                                  height: 250,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            '${Env().domaingetpicture}${substadiumModels[index].substdUrlPicture}',
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                              ],
                            ),
                      Container(
                        width: 350,
                        // color: kPrimaryColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("ตำเเหน่งของสนาม",
                                    style: TextStyle(fontSize: 25)),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    substadiumModels[index].stdDescripLocation!,
                                    style: TextStyle(fontSize: 15),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("เลือกเวลา",
                                    style: TextStyle(fontSize: 25)),
                              ],
                            ),
                            Container(
                                height: 60,
                                child: buildListViewTimeStadium(index)),
                            // TimeList(
                            //   timeStep: 60,
                            //   activeTextStyle: const TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.white,
                            //     fontSize: 20,
                            //   ),

                            //   borderColor: Colors.white,
                            //   textStyle: const TextStyle(
                            //       fontWeight: FontWeight.normal,
                            //       color: Colors.white,
                            //       fontSize: 20),

                            //   activeBorderColor: kPrimaryLightColor,
                            //   backgroundColor: kPrimaryColor,
                            //   activeBackgroundColor: kPrimaryLightColor,
                            //   firstTime: const TimeOfDay(hour: 18, minute: 00),
                            //   lastTime: const TimeOfDay(hour: 20, minute: 00),
                            //   onHourSelected: (TimeOfDay hour) {
                            //     setState(() {
                            //       time = hour.toString().substring(10, 15);
                            //       print("Time  select $time");
                            //       cheackTimeBooking(index);
                            //     });
                            //   },

                            //   // onHourSelected: (TimeOfDay choosetime) {
                            //   //   setState(() {
                            //   //     cheackTimeBooking(index);

                            //   //     // print('time =$choosetime');
                            //   //     time =
                            //   //         choosetime.toString().substring(10, 15);
                            //   //     print("Time format =>$time");
                            //   //   });
                            //   // },
                            // ),
                          ],
                        ),
                      ),
                    ],
                  )),
    );
  }

  ListView buildListViewTimeStadium(int index) => ListView.builder(
      physics: const ScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: timestadiumModels.length,
      itemBuilder: (context, index2) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                bkt_id = timestadiumModels[index2].bktId;
                getTime = timestadiumModels[index2].bktStartTime;

                time = timestadiumModels[index2]
                    .bktStartTime
                    .toString()
                    .substring(0, 5);
                print("Time==>$time");
                print("bkt_id==>$bkt_id");
                cheackTimeBooking(index);
                // print(
                //     "you click time===>${timestadiumModels[index2].bktStartTime}");
              },
              child: Text(
                timestadiumModels[index2]
                    .bktStartTime!
                    .toString()
                    .substring(0, 5),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ));
}
