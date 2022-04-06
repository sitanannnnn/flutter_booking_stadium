import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Information extends StatefulWidget {
  final UserModel userModel;
  const Information({Key? key, required this.userModel}) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  UserModel? userModel;
  String? stuName,
      stuUsername,
      stuPassword,
      stuUrlpicture,
      stuFaculty,
      stuMajor;
  bool loadStatus = true;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    findUser().then((value) {
      setState(() {
        loadStatus = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text('ข้อมูลนิสิต'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: loadStatus
            ? MyStyle().showProgress()
            : Column(
                children: [
                  MyStyle().mySizebox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360),
                            image: DecorationImage(
                                image: NetworkImage(
                                  '${Env().domaingetpicture}${stuUrlpicture}',
                                ),
                                fit: BoxFit.cover)),
                      ),
                    ],
                  ),
                  MyStyle().mySizebox(),
                  MyStyle().mySizebox(),
                  MyStyle().mySizebox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stuName == null ? '-' : '$stuName ',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //รหัสนิสิต
                      Text(
                        stuUsername.toString().substring(1, 11),
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "คณะ $stuFaculty",
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "สาขา $stuMajor",
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  )
                ],
              ));
  }

  Future<void> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      String? stuId = preferences.getString('stu_id');
      print('customerId =$stuId');
      stuUsername = preferences.getString('stu_username');
      print('user =$stuUsername');
      stuName = preferences.getString('stu_name');
      stuUrlpicture = preferences.getString('stu_urlpicture');
      print('image===>$stuUrlpicture');
      stuFaculty = preferences.getString('stu_faculty');
      print('fal =$stuFaculty');
      stuMajor = preferences.getString('stu_major');
      print('major =$stuMajor');
    });
  }
}
