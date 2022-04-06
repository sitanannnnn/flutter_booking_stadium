class CheckBookingModel {
  String? bkdId;
  String? stuId;
  String? stdId;
  String? substdId;
  String? bkdDate;
  String? bkdTime;
  String? bkdMember;

  CheckBookingModel(
      {this.bkdId,
      this.stuId,
      this.stdId,
      this.substdId,
      this.bkdDate,
      this.bkdTime,
      this.bkdMember});

  CheckBookingModel.fromJson(Map<String, dynamic> json) {
    bkdId = json['bkd_id'];
    stuId = json['stu_id'];
    stdId = json['std_id'];
    substdId = json['substd_id'];
    bkdDate = json['bkd_date'];
    bkdTime = json['bkd_time'];
    bkdMember = json['bkd_member'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bkd_id'] = this.bkdId;
    data['stu_id'] = this.stuId;
    data['std_id'] = this.stdId;
    data['substd_id'] = this.substdId;
    data['bkd_date'] = this.bkdDate;
    data['bkd_time'] = this.bkdTime;
    data['bkd_member'] = this.bkdMember;
    return data;
  }
}