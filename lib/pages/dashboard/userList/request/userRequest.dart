import 'dart:convert';
import 'package:flutter_web_psychotest/pages/dashboard/userList/model/userModel.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  var url = 'https://ramms11.github.io/users/users.json';
  var response = await http.get(url);

  // ignore: deprecated_member_use
  var users = List<User>();
  //
  var userData = json.decode(response.body);
  for (var userData in userData) {
    users.add(User.fromJson(userData));
  }
  // print(userData);
  return users;
}

Future<List<User>> fetchAdmin() async {
  var url = 'https://ramms11.github.io/users/useradmin.json';
  var response = await http.get(url);

  // ignore: deprecated_member_use
  var users = List<User>();
  //
  var userData = json.decode(response.body);
  for (var userData in userData) {
    users.add(User.fromJson(userData));
  }
  // print(userData);
  return users;
}
