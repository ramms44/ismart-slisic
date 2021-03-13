import 'dart:convert';
import 'package:http/http.dart' as http;

// update user
Future<Map<String, dynamic>> postRequest(String username, String email,
    String password, String objectId, String sessionToken) async {
  // todo - fix baseUrl
  var url = 'https://parseapi.back4app.com/users/' + objectId;
  var body = json.encode({
    'username': username,
    'email': email,
    'password': password,
  });

  print('Body: $body');

  var response = await http.put(
    url,
    headers: {
      'X-Parse-Application-Id': 'uyOKwIvY10U4tvqG7cJayEYDSUW7gGvuY9tycV2M',
      'X-Parse-REST-API-Key': 'NhRHzDXq1cIF5lxvGEgc4ZqM5gbztFiTJfrwN3ri',
      'X-Parse-Session-Token': sessionToken,
      "Content-Type": "application/json",
    },
    body: body,
  );

  // todo - handle non-200 status code, etc
  if (response.statusCode == 200) {
    print('success update');
  } else {
    print('failed update');
  }
  return json.decode(response.body);
}

// delete user
Future<Map<String, dynamic>> deleteRequest(
    String objectId, String sessionToken) async {
  // todo - fix baseUrl
  var url = 'https://parseapi.back4app.com/users/' + objectId;

  var response = await http.delete(
    url,
    headers: {
      'X-Parse-Application-Id': 'uyOKwIvY10U4tvqG7cJayEYDSUW7gGvuY9tycV2M',
      'X-Parse-REST-API-Key': 'NhRHzDXq1cIF5lxvGEgc4ZqM5gbztFiTJfrwN3ri',
      'X-Parse-Session-Token': sessionToken,
    },
    // body: body,
  );

  // todo - handle non-200 status code, etc
  if (response.statusCode == 200) {
    print('success delete');
  } else {
    print('failed delete');
  }
  return json.decode(response.body);
}

// create user
Future<Map<String, dynamic>> createAccount(
    String password, String username, String email) async {
  // todo - fix baseUrl
  var url = 'https://parseapi.back4app.com/users';
  var body = json.encode({
    'password': password,
    'username': username,
    'email': email,
  });

  print('Body: $body');

  var response = await http.post(
    url,
    headers: {
      'X-Parse-Application-Id': 'uyOKwIvY10U4tvqG7cJayEYDSUW7gGvuY9tycV2M',
      'X-Parse-REST-API-Key': 'NhRHzDXq1cIF5lxvGEgc4ZqM5gbztFiTJfrwN3ri',
      'X-Parse-Revocable-Session': '1',
      "Content-Type": "application/json",
    },
    body: body,
  );

  // todo - handle non-200 status code, etc
  if (response.statusCode == 200) {
    print(response.statusCode);
  } else {
    print(response.statusCode);
  }
  return json.decode(response.body);
}
