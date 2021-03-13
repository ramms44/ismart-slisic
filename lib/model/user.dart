class Users {
  Users({
    this.username,
    this.objectid,
    this.email,
    this.password,
    this.usertype,
  });

  String username;
  String objectid;
  String email;
  String password;
  String usertype;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        username: json["username"],
        objectid: json["objectid"],
        email: json["email"],
        password: json["password"],
        usertype: json["usertype"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "objectid": objectid,
        "email": email,
        "password": password,
        "usertype": usertype,
      };
}
