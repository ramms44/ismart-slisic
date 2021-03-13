//

class UserCheck {
  UserCheck({
    this.userCheckid,
    this.createdAt,
  });

  String userCheckid;
  DateTime createdAt;

  factory UserCheck.fromJson(Map<String, dynamic> json) => UserCheck(
        userCheckid: json["userid"],
        createdAt: DateTime.parse(json["create_at"]),
      );

  Map<String, dynamic> toJson() => {
        "userid": userCheckid,
        "create_at": createdAt.toIso8601String(),
      };
}
