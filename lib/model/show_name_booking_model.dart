class ShowNameBookingModel {
  String? bkdId;
  String? stuId;
  String? stdId;
  String? substdId;
  String? bktId;
  String? bkdDate;
  String? bkdTime;
  String? bkdMember;

  ShowNameBookingModel(
      {this.bkdId,
      this.stuId,
      this.stdId,
      this.substdId,
      this.bktId,
      this.bkdDate,
      this.bkdTime,
      this.bkdMember});

  ShowNameBookingModel.fromJson(Map<String, dynamic> json) {
    bkdId = json['bkd_id'];
    stuId = json['stu_id'];
    stdId = json['std_id'];
    substdId = json['substd_id'];
    bktId = json['bkt_id'];
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
    data['bkt_id'] = this.bktId;
    data['bkd_date'] = this.bkdDate;
    data['bkd_time'] = this.bkdTime;
    data['bkd_member'] = this.bkdMember;
    return data;
  }
}
