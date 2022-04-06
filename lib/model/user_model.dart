class UserModel {
  String? stuId;
  String? stuName;
  String? stuFaculty;
  String? stuMajor;
  String? stuUsername;
  String? stuPassword;
  String? stuUrlpicture;

  UserModel(
      {this.stuId,
      this.stuName,
      this.stuFaculty,
      this.stuMajor,
      this.stuUsername,
      this.stuPassword,
      this.stuUrlpicture});

  UserModel.fromJson(Map<String, dynamic> json) {
    stuId = json['stu_id'];
    stuName = json['stu_name'];
    stuFaculty = json['stu_faculty'];
    stuMajor = json['stu_major'];
    stuUsername = json['stu_username'];
    stuPassword = json['stu_password'];
    stuUrlpicture = json['stu_urlpicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stu_id'] = this.stuId;
    data['stu_name'] = this.stuName;
    data['stu_faculty'] = this.stuFaculty;
    data['stu_major'] = this.stuMajor;
    data['stu_username'] = this.stuUsername;
    data['stu_password'] = this.stuPassword;
    data['stu_urlpicture'] = this.stuUrlpicture;
    return data;
  }
}
