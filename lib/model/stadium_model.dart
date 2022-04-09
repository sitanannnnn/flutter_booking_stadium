class StadiumModel {
  String? stdId;
  String? stdName;
  String? stdNumberOfPlayer;
  String? stdUrlPicture;
  String? stdDescripLocation;
  String? stdProcedure;
  String? stdclosedId;
  String? stdclosedDate;
  String? stdclosedNote;

  StadiumModel(
      {this.stdId,
      this.stdName,
      this.stdNumberOfPlayer,
      this.stdUrlPicture,
      this.stdDescripLocation,
      this.stdProcedure,
      this.stdclosedId,
      this.stdclosedDate,
      this.stdclosedNote});

  StadiumModel.fromJson(Map<String, dynamic> json) {
    stdId = json['std_id'];
    stdName = json['std_name'];
    stdNumberOfPlayer = json['std_number_of_player'];
    stdUrlPicture = json['std_url_picture'];
    stdDescripLocation = json['std_descrip_location'];
    stdProcedure = json['std_procedure'];
    stdclosedId = json['stdclosed_id'];
    stdclosedDate = json['stdclosed_date'];
    stdclosedNote = json['stdclosed_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['std_id'] = this.stdId;
    data['std_name'] = this.stdName;
    data['std_number_of_player'] = this.stdNumberOfPlayer;
    data['std_url_picture'] = this.stdUrlPicture;
    data['std_descrip_location'] = this.stdDescripLocation;
    data['std_procedure'] = this.stdProcedure;
    data['stdclosed_id'] = this.stdclosedId;
    data['stdclosed_date'] = this.stdclosedDate;
    data['stdclosed_note'] = this.stdclosedNote;
    return data;
  }
}
