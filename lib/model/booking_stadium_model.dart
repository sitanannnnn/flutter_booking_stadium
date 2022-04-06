class BookingStadiumModel {
  String? bkdId;
  String? stuId;
  String? stdId;
  String? substdId;
  String? bkdDate;
  String? bkdTime;
  String? bkdMember;
  String? stdName;
  String? stdNumberOfPlayer;
  String? stdUrlPicture;
  String? stdDescripLocation;
  String? stdProcedure;
  String? substdName;
  String? substdUrlPicture;

  BookingStadiumModel(
      {this.bkdId,
      this.stuId,
      this.stdId,
      this.substdId,
      this.bkdDate,
      this.bkdTime,
      this.bkdMember,
      this.stdName,
      this.stdNumberOfPlayer,
      this.stdUrlPicture,
      this.stdDescripLocation,
      this.stdProcedure,
      this.substdName,
      this.substdUrlPicture});

  BookingStadiumModel.fromJson(Map<String, dynamic> json) {
    bkdId = json['bkd_id'];
    stuId = json['stu_id'];
    stdId = json['std_id'];
    substdId = json['substd_id'];
    bkdDate = json['bkd_date'];
    bkdTime = json['bkd_time'];
    bkdMember = json['bkd_member'];
    stdName = json['std_name'];
    stdNumberOfPlayer = json['std_number_of_player'];
    stdUrlPicture = json['std_url_picture'];
    stdDescripLocation = json['std_descrip_location'];
    stdProcedure = json['std_procedure'];
    substdName = json['substd_name'];
    substdUrlPicture = json['substd_url_picture'];
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
    data['std_name'] = this.stdName;
    data['std_number_of_player'] = this.stdNumberOfPlayer;
    data['std_url_picture'] = this.stdUrlPicture;
    data['std_descrip_location'] = this.stdDescripLocation;
    data['std_procedure'] = this.stdProcedure;
    data['substd_name'] = this.substdName;
    data['substd_url_picture'] = this.substdUrlPicture;
    return data;
  }
}
