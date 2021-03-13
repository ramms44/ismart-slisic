import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/ui/screens/homeScreens.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class User {
  final String uid;

//UserCredential
  ParseUser _parseUser;

  User({@required this.uid});
}

class AuthBase {
  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // parse login and register
  //Login
  Future<ParseUser> loginWithUsernameAndPassword(username, pass, email) async {
    var user = ParseUser(username, pass, email);
    var response = await user.login();

    if (response.success) {
      // setState(() {
      //   _parseUser = user; //Keep the user
      // });
      print('user.objectId: ' + user.objectId);
    } else {
      print(response.error.message);
    }
  }

  //Sign UP
  Future<ParseUser> registerWithUsernameAndPassword(
      username, pass, email) async {
    var user = ParseUser(username, pass,
        email); //You can add Collumns to user object adding "..set(key,value)"
    var result = await user.create();

    // // UserCredential
    // ParseUser _parseUser;

    if (result.success) {
      // setState(() {
      // _parseUser = user; //Keep the user
      // });
      print(user.objectId);

      //
      Navigator.push(
        null,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            user: user,
            username: username,
          ),
        ),
      );
    } else {
      print(result.error.message);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
