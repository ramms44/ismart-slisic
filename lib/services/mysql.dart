import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String username = '';

class MySqlTest extends StatefulWidget {
  @override
  _MySqlTestState createState() => _MySqlTestState();
}

class _MySqlTestState extends State<MySqlTest> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();

  Future<List> senddata() async {
    final response =
        await http.post("http://asesmen.slisic.id/user_have_quiz.php", body: {
      "name": name.text,
      "email": email.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Have Quiz"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Username",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'name'),
              ),
              Text(
                "Email",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              RaisedButton(
                child: Text("Input"),
                onPressed: () {
                  senddata;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
