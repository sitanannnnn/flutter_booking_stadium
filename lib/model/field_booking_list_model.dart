class FieldBookingListModel {
  String? substdId;
  String? substdName;
  String? bktId;
  String? bktStartTime;
  String? bktEndTime;
  String? bkdId;
  String? bkdMember;
  String? bkdDate;
  String? bkdTime;

  FieldBookingListModel(
      {this.substdId,
      this.substdName,
      this.bktId,
      this.bktStartTime,
      this.bktEndTime,
      this.bkdId,
      this.bkdMember,
      this.bkdDate,
      this.bkdTime});

  FieldBookingListModel.fromJson(Map<String, dynamic> json) {
    substdId = json['substd_id'];
    substdName = json['substd_name'];
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
    data['substd_id'] = this.substdId;
    data['substd_name'] = this.substdName;
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
