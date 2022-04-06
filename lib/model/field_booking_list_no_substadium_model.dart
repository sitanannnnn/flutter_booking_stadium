class FieldBookingListNoSubstadiumModel {
  String? stdId;
  String? stdName;
  String? bktId;
  String? bktStartTime;
  String? bktEndTime;
  String? bkdId;
  String? bkdMember;
  String? bkdDate;
  String? bkdTime;

  FieldBookingListNoSubstadiumModel(
      {this.stdId,
      this.stdName,
      this.bktId,
      this.bktStartTime,
      this.bktEndTime,
      this.bkdId,
      this.bkdMember,
      this.bkdDate,
      this.bkdTime});

  FieldBookingListNoSubstadiumModel.fromJson(Map<String, dynamic> json) {
    stdId = json['std_id'];
    stdName = json['std_name'];
    bktId = json['bkt_id'];
    bktStartTime = json['bkt_start_time'];
    bktEndTime = json['bkt_end_time'];
    bkdId = json['bkd_id'];
    bkdMember = json['bkd_member'];
    bkdDate = json['bkd_date'];
    bkdTime = json['bkd_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['std_id'] = this.stdId;
    data['std_name'] = this.stdName;
    data['bkt_id'] = this.bktId;
    data['bkt_start_time'] = this.bktStartTime;
    data['bkt_end_time'] = this.bktEndTime;
    data['bkd_id'] = this.bkdId;
    data['bkd_member'] = this.bkdMember;
    data['bkd_date'] = this.bkdDate;
    data['bkd_time'] = this.bkdTime;
    return data;
  }
}
