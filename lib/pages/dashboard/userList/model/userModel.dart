//

class User {
  User({
    this.objectId,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.email,
  });

  String objectId;
  String username;
  DateTime createdAt;
  DateTime updatedAt;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        objectId: json["objectId"],
        username: json["username"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "objectId": objectId,
        "username": username,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "email": email == null ? null : email,
      };
}
