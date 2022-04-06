class ShowSubstadiumModel {
  String? substdId;
  String? stdId;
  String? substdName;
  String? substdUrlPicture;

  ShowSubstadiumModel(
      {this.substdId, this.stdId, this.substdName, this.substdUrlPicture});

  ShowSubstadiumModel.fromJson(Map<String, dynamic> json) {
    substdId = json['substd_id'];
    stdId = json['std_id'];
    substdName = json['substd_name'];
    substdUrlPicture = json['substd_url_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['substd_id'] = this.substdId;
    data['std_id'] = this.stdId;
    data['substd_name'] = this.substdName;
    data['substd_url_picture'] = this.substdUrlPicture;
    return data;
  }
}
