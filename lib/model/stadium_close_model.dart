class StadiumCloseModel {
  String? stdclosedId;
  String? stdId;
  String? stdclosedDate;
  String? stdclosedTime;
  String? stdclosedNote;

  StadiumCloseModel(
      {this.stdclosedId,
      this.stdId,
      this.stdclosedDate,
      this.stdclosedTime,
      this.stdclosedNote});

  StadiumCloseModel.fromJson(Map<String, dynamic> json) {
    stdclosedId = json['stdclosed_id'];
    stdId = json['std_id'];
    stdclosedDate = json['stdclosed_date'];
    stdclosedTime = json['stdclosed_time'];
    stdclosedNote = json['stdclosed_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stdclosed_id'] = this.stdclosedId;
    data['std_id'] = this.stdId;
    data['stdclosed_date'] = this.stdclosedDate;
    data['stdclosed_time'] = this.stdclosedTime;
    data['stdclosed_note'] = this.stdclosedNote;
    return data;
  }
}
