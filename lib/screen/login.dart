import 'dart:convert';
import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:booking_stadium/constant/env.dart';
import 'package:booking_stadium/constant/my_style.dart';
import 'package:booking_stadium/constant/normal_dialog.dart';
import 'package:booking_stadium/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? username, password;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.dstATop),
              image: AssetImage("assets/images/futsal_field.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // MyStyle().mySizebox(),
                // MyStyle().mySizebox(),
                //MyStyle().showBackgroud(),
                MyStyle().mySizebox(),
                MyStyle().mySizebox(),
                //MyStyle().mySizebox(),

                const Text(
                  "จองสนามกีฬา",
                  style: TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
                const Text(
                  "มหาวิทยาลัยเกษตรศาสตร์ ",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const Text(
                  " วิทยาเขตศรีราชา",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                MyStyle().mySizebox(),
                MyStyle().mySizebox(),
                usernameForm(),
                MyStyle().mySizebox(),
                passwordForm(),
                MyStyle().mySizebox(),
                MyStyle().mySizebox(),
                loginButtom(context),
                MyStyle().mySizebox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //function check type user
  Future<void> checkAuthen() async {
    print(username);
    String url =
        '${Env().domaingetData}/getUser.php?isAdd=true&stu_username=$username';

    try {
      Response response = await Dio().get(url);
      // print('res = $response');
      var result = json.decode(response.data);
      print('result = $result');
      if (response.toString() == 'null') {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "ไม่พบรหัสผู้ใช้ในระบบ กรุณาลองใหม่อีกครั้ง",
          ),
        );
        // normalDialog(
        //     context, 'ไม่พบรหัสผู้ใช้ในระบบการจอง กรุณาลองใหม่อีกครั้ง');
      } else {
        for (var map in result) {
          UserModel userModel = UserModel.fromJson(map);
          if (password == userModel.stuPassword) {
            routeTuService(Home(), userModel);
          } else {
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: "รหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง",
              ),
            );
            // normalDialog(context, 'รหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง');
          }
        }
      }
    } catch (e) {}
  }

  Future<void> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('stu_id', userModel.stuId.toString());
    preferences.setString('stu_name', userModel.stuName.toString());
    preferences.setString('stu_faculty', userModel.stuFaculty.toString());
    preferences.setString('stu_major', userModel.stuMajor.toString());
    preferences.setString('stu_username', userModel.stuUsername.toString());
    preferences.setString('stu_password', userModel.stuPassword.toString());
    preferences.setString('stu_urlpicture', userModel.stuUrlpicture.toString());
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  //function show buttom login
  Container loginButtom(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
              onPrimary: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          onPressed: () {
            bool validate = _formKey.currentState!.validate();
            if (validate) {
              print(username);
              print(password);
              checkAuthen();
              // MaterialPageRoute materialPageRoute =
              //     MaterialPageRoute(builder: (BuildContext context) => Home());
              // Navigator.of(context).pushReplacement(materialPageRoute);
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 20),
          )),
    );
  }

//function form input user
  Widget usernameForm() => Container(
        width: 300,
        height: 75,
        child: TextFormField(
          onChanged: (value) => username = value.trim(),
          decoration: InputDecoration(
            filled: true,
            fillColor: kPrimaryLightColor,
            labelText: 'ชื่อผู้ใช้',
            prefixIcon: Icon(
              Icons.account_box,
              color: kPrimaryColor,
            ),
            labelStyle: TextStyle(color: Colors.black, fontSize: 15),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณากรอกชื่อผู้ใช้";
            } else
              return null;
          },
        ),
      );
  //function form input password
  Widget passwordForm() => SizedBox(
        width: 300,
        height: 75,
        child: TextFormField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: kPrimaryLightColor,
            labelText: 'รหัสผ่าน',
            prefixIcon: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            labelStyle: TextStyle(color: Colors.black, fontSize: 15),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณากรอกรหัสผ่าน";
            } else
              return null;
          },
        ),
      );

  //function showimage
  Widget myimage() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showBackgroud(),
        ],
      );
}
