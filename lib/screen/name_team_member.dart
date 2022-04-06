import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/constant/normal_dialog.dart';
import 'package:booking_stadium/model/sub_stadium_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameTeamMember extends StatefulWidget {
  final SubStadiumModel subStadiumModel;
  final time, bkt_id, std_id;
  const NameTeamMember(
      {Key? key,
      required this.subStadiumModel,
      this.time,
      this.bkt_id,
      this.std_id})
      : super(key: key);

  @override
  State<NameTeamMember> createState() => _NameTeamMemberState();
}

class _NameTeamMemberState extends State<NameTeamMember> {
  final _formKey = GlobalKey<FormState>();
  SubStadiumModel? subStadiumModel;
  String? timeselect, player, name, std_id, bkd_member, substd_id, bkt_id;
  List<String> savename = [];
  int? num;
  List<TextEditingController> listName = [];
  //ประกาศตัวแปร 3 ตัว ในการเช็คเวลา
  DateTime? startTime;
  DateTime? endTime;
  DateTime currentTime = DateTime.now();
  var number;
  @override
  void initState() {
    super.initState();
    bkt_id = widget.bkt_id;
    subStadiumModel = widget.subStadiumModel;
    timeselect = widget.time;
    print("bkt_id is==>$bkt_id");
    print("this time ===>$timeselect");
    player = subStadiumModel!.stdNumberOfPlayer!;
    print("Player==>$player");
    //แปลงString-->int
    number = int.parse(player!);
    std_id = widget.std_id;
    print("std_id is==>$std_id");
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

  //วนลูปเก็บค่าชื่อสมาชิก
  Future<void> getName(String name) async {
    print("isname=>$name");
    savename.add(name);
    print("list$savename");
  }

  //function บันทึกรายการสนามกีฬา
  Future<void> recordBooking() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? stu_id = preferences.getString("stu_id");

    substd_id = subStadiumModel!.substdId;
    DateTime dateTime = DateTime.now();
    String? bookingDate = DateFormat('yyyy-MM-dd').format(dateTime);
    print("std_id==>$std_id");
    print("substd_id==>$substd_id");
    var url =
        '${Env().domaininsertData}/insertBooking.php?isAdd=true&stu_id=$stu_id&std_id=$std_id&substd_id=$substd_id&bkt_id=$bkt_id&bkd_date=$bookingDate&bkd_time=$timeselect&bkd_member=$savename';
    await Dio().get(url).then((value) {
      print('value is ===> $value');
      if (value.statusCode == 200) {
        //Navigator.pop(context);
      } else {
        normalDialog(context, 'Please try again');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text("จอง${subStadiumModel!.stdName!}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("สนาม", style: TextStyle(fontSize: 20)),
                            Text(subStadiumModel!.stdName!,
                                style: const TextStyle(fontSize: 20))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("สนามย่อย",
                                style: TextStyle(fontSize: 20)),
                            subStadiumModel!.substdId == null
                                ? const Text("-",
                                    style: TextStyle(fontSize: 20))
                                : Text(subStadiumModel!.substdName!,
                                    style: const TextStyle(fontSize: 20))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("วันที่",
                                style: TextStyle(fontSize: 20)),
                            Text(
                              DateFormat("dd/MM/yyyy").format(DateTime.now()),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("เวลา", style: TextStyle(fontSize: 20)),
                            Text("$timeselect น.",
                                style: const TextStyle(fontSize: 20))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            MyStyle().mySizebox(),
            const Text("จองสนามเเล้วจะไม่สามารถเเก้ไขข้อมูลได้",
                style: TextStyle(fontSize: 20, color: Colors.red)),
            Text(
                "จำนวนคน ${subStadiumModel!.stdNumberOfPlayer!} คนเป็นอย่างน้อย",
                style: const TextStyle(fontSize: 20, color: Colors.red)),
            const Text("**หากจำนวนไม่ครบจะไม่สามารถทำการจองได้",
                style: TextStyle(fontSize: 20, color: Colors.red)),
            MyStyle().mySizebox(),
            const Text("เพิ่มข้อมูลรายชื่อเพื่อนร่วมเล่น",
                style: TextStyle(fontSize: 20)),
            MyStyle().mySizebox(),
            Center(
                child: Shortcuts(
                    shortcuts: {},
                    child: FocusTraversalGroup(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        onChanged: () {
                          Form.of(primaryFocus!.context!)!.save();
                        },
                        child: Wrap(
                          children: List<Widget>.generate(number, (index) {
                            listName.add(TextEditingController());
                            return ConstrainedBox(
                              constraints:
                                  BoxConstraints.tight(const Size(350, 60)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: listName[index],
                                  // onSaved: (newValue) {
                                  //   name = newValue;
                                  //   print("index:${index} name==>$name");

                                  //   // savename.add(newValue!);
                                  //   // print("is==>$savename");
                                  // },
                                  decoration: const InputDecoration(
                                    labelText: 'ชื่อ-นามสกุล',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: kPrimaryColor,
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide()),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide()),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "กรุณากรอกชื่อผู้ใช้";
                                    } else
                                      return null;
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kSecondaryColorBrown,
                          onPrimary: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          for (var i = 0; i < number; i++) {
                            print("name $i ${listName[i].text}");
                            getName(listName[i].text);
                          }
                          checkTimeBooking(currentTime)
                              ? recordBooking()
                              : showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'ไม่สามารถจองสนามได้',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text("กรุณาจองสนามกีฬาเวลา",
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
                          // if (checkTimeBooking(currentTime)) {

                          //   // Fluttertoast.showToast(
                          //   //     msg: 'Signup complect',
                          //   //     toastLength: Toast.LENGTH_SHORT,
                          //   //     backgroundColor: kPrimaryColor,
                          //   //     textColor: Colors.white,
                          //   //     fontSize: 16.0);
                          // } else {
                          //   showDialog(
                          //     context: context,
                          //     barrierDismissible:
                          //         false, // user must tap button!
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         title: const Text(
                          //           'ไม่สามารถจองสนามได้',
                          //           style:
                          //               TextStyle(fontWeight: FontWeight.bold),
                          //         ),
                          //         content: SingleChildScrollView(
                          //           child: ListBody(
                          //             children: [
                          //               Text("กรุณาจองสนามกีฬาเวลา",
                          //                   style: const TextStyle(
                          //                       fontSize: 20,
                          //                       fontWeight: FontWeight.bold)),
                          //               Text("09.00 น -15.00 น",
                          //                   style: const TextStyle(
                          //                       fontSize: 20,
                          //                       color: Colors.red)),
                          //             ],
                          //           ),
                          //         ),
                          //         actions: <Widget>[
                          //           TextButton(
                          //             child: const Text('ตกลง',
                          //                 style: TextStyle(
                          //                     fontSize: 20, color: Colors.red)),
                          //             onPressed: () {
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //         ],
                          //       );
                          //     },
                          //   );
                          // }

                          // showDialog(
                          //   context: context,
                          //   builder: (context) => AlertDialog(
                          //         title: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //           children: [
                          //             Column(
                          //               children: [
                          //                 Text('บันทึกข้อมูลสำเร็จ'),
                          //                 Padding(
                          //                     padding:
                          //                         const EdgeInsets.all(
                          //                             8.0),
                          //                     child: IconButton(
                          //                       onPressed: () {
                          //                         Navigator.push(
                          //                             context,
                          //                             MaterialPageRoute(
                          //                                 builder:
                          //                                     (context) =>
                          //                                         const BookinDetail()));
                          //                       },
                          //                       icon: Icon(
                          //                         Icons.check_circle,
                          //                         size: 50,
                          //                         color: kPrimaryColor,
                          //                       ),
                          //                     )),
                          //                 SizedBox(
                          //                   height: 20,
                          //                 )
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ));
                        }
                      },
                      child: const Text(
                        'บันทึกข้อมูล',
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
