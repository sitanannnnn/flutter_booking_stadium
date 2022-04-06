class TimeStadiumModel {
  String? bktId;
  String? stdId;
  String? bktStartTime;
  String? bktEndTime;

  TimeStadiumModel(
      {this.bktId, this.stdId, this.bktStartTime, this.bktEndTime});

  TimeStadiumModel.fromJson(Map<String, dynamic> json) {
    bktId = json['bkt_id'];
    stdId = json['std_id'];
    bktStartTime = json['bkt_start_time'];
    bktEndTime = json['bkt_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bkt_id'] = this.bktId;
    data['std_id'] = this.stdId;
    data['bkt_start_time'] = this.bktStartTime;
    data['bkt_end_time'] = this.bktEndTime;
    return data;
  }
}
