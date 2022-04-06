import 'package:booking_stadium/constant/bgcolor.dart';
import 'package:flutter/material.dart';

class ShowNameBooking extends StatefulWidget {
  final bkd_id;
  const ShowNameBooking({Key? key, this.bkd_id}) : super(key: key);

  @override
  State<ShowNameBooking> createState() => _ShowNameBookingState();
}

class _ShowNameBookingState extends State<ShowNameBooking> {
  String? bkd_id;
  @override
  @override
  void initState() {
    super.initState();
    bkd_id = widget.bkd_id;
    print("bkd==>$bkd_id");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text("รายชื่อการจอง"),
      ),
    );
  }
}
