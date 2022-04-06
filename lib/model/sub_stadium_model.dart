class SubStadiumModel {
  String? stdId;
  String? stdName;
  String? stdNumberOfPlayer;
  String? stdUrlPicture;
  String? stdDescripLocation;
  String? stdProcedure;
  String? substdId;
  String? substdName;
  String? substdUrlPicture;

  SubStadiumModel(
      {this.stdId,
      this.stdName,
      this.stdNumberOfPlayer,
      this.stdUrlPicture,
      this.stdDescripLocation,
      this.stdProcedure,
      this.substdId,
      this.substdName,
      this.substdUrlPicture});

  SubStadiumModel.fromJson(Map<String, dynamic> json) {
    stdId = json['std_id'];
    stdName = json['std_name'];
    stdNumberOfPlayer = json['std_number_of_player'];
    stdUrlPicture = json['std_url_picture'];
    stdDescripLocation = json['std_descrip_location'];
    stdProcedure = json['std_procedure'];
    substdId = json['substd_id'];
    substdName = json['substd_name'];
    substdUrlPicture = json['substd_url_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['std_id'] = this.stdId;
    data['std_name'] = this.stdName;
    data['std_number_of_player'] = this.stdNumberOfPlayer;
    data['std_url_picture'] = this.stdUrlPicture;
    data['std_descrip_location'] = this.stdDescripLocation;
    data['std_procedure'] = this.stdProcedure;
    data['substd_id'] = this.substdId;
    data['substd_name'] = this.substdName;
    data['substd_url_picture'] = this.substdUrlPicture;
    return data;
  }
}
