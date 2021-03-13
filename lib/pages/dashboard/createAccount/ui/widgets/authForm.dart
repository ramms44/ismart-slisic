import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_psychotest/model/user.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/services/auth.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/ui/screens/authScreens.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/ui/screens/companyScreens.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/ui/screens/homeScreens.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../../createAccountBulk.dart';
import 'originalButton.dart';

class AuthForm extends StatefulWidget {
  final AuthType authType;
  final username;
  final user;

  const AuthForm({
    Key key,
    @required this.authType,
    this.username,
    this.user,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState(
        authType,
        username,
        user,
      );
}

class _AuthFormState extends State<AuthForm> {
  final username;
  final user;
  final AuthType authType;
  final _formKey = GlobalKey<FormState>();
  String _username = '', _password = '';
  AuthBase authBase = AuthBase();
  // user type
  List<String> usertype;

  _AuthFormState(
    this.authType,
    this.username,
    this.user,
  );

  // List<Users> users = List<Users>();

  // add user id
  Future<void> addUserID(userIdData) async {
    // ignore: deprecated_member_use
    Firestore.instance.collection('userid').add(userIdData);
  }

  @override
  Widget build(BuildContext context) {
    print('username pada auth form : $username');
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter user id',
                hintText: 'ex: user1',
              ),
              onChanged: (value) {
                _username = value;
              },
              validator: (value) =>
                  value.isEmpty ? 'You must enter a valid email' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter user password',
              ),
              obscureText: true,
              onChanged: (value) {
                _password = value;
              },
              validator: (value) => value.length <= 3
                  ? 'Your password must be larger than 4 characters'
                  : null,
            ),
            SizedBox(height: 20),
            OriginalButton(
              text: widget.authType == AuthType.login
                  ? 'Login'
                  : username == 'superadmin'
                      ? 'Create Admin Account'
                      : 'Create User Test Account',
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (widget.authType == AuthType.login) {
                    /// update login method [useridCheck] with 'userid' collection
                    useridCheck(username, password) async {
                      // userVersionQuiz(username);
                      bool isSuccessLogin = false;
                      FirebaseFirestore.instance
                          .collection("userid") // userid database firestore
                          .where("username", isEqualTo: username)
                          .get()
                          .then((value) {
                        setState(() {
                          isSuccessLogin = true;
                          // isLogedin = true;
                        });
                        value.docs.forEach((element) {
                          FirebaseFirestore.instance
                              .collection("userid")
                              .doc(element.id)
                              .get()
                              .then((value) {
                            print("value : $value");
                            print("Success!");
                            // dan ke kondisi berikut untuk navigate
                            if (username == password &&
                                isSuccessLogin == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(
                                    user: user,
                                    username: _username,
                                  ),
                                ),
                              );
                            } else {
                              print('password / userid salah');
                              // clear();
                            }
                          });
                        });
                      });
                    }
                    // await authBase.loginWithUsernameAndPassword(
                    //     _username, _password, null);
                    // String email;
                    // String pass;
                    // String username;
                    // var user = ParseUser(_username, _password, '');
                    // var response = await user.login();

                    // if (response.success) {
                    //   // setState(() {
                    //   //   _parseUser = user; //Keep the user
                    //   // });
                    //   print('response.success: ${response.success}');
                    // } else {
                    //   print(response.error.message);
                    // }
                    // Navigator.of(context).pushReplacementNamed('home');

                  } else {
                    // var user = ParseUser(_username, _password,
                    //     null); //You can add Collumns to user object adding "..set(key,value)"
                    // var result = await user.create();
                    // // if (result.success) {
                    // print('result create success : ${result.success}');
                    // add userID data
                    addUserID({
                      'username': username,
                      // 'objectid': user.objectId,
                      'email': {username + '@mail.com'},
                      'password': _password,
                      'usertype':
                          username == 'superadmin' ? 'admin' : 'usertest',
                    });
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(
                          user: user,
                          username: username,
                        ),
                      ),
                    );
                    // } else {
                    //   print(result.error.message);
                    // }
                    // Navigator.of(context).pushReplacementNamed('home');
                  }
                }
              },
            ),
            SizedBox(height: 6),
            FlatButton(
              onPressed: () {
                if (widget.authType == AuthType.login) {
                  Navigator.of(context).pushReplacementNamed('register');
                  print(widget.authType);
                } else {
                  Navigator.of(context).pushReplacementNamed('login');
                }
              },
              child: Text(
                widget.authType == AuthType.login
                    ? 'Don\'t have an account?'
                    : 'Already have an account?',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            SizedBox(height: 6),
            Visibility(
              visible: username == 'superadmin' ? true : false,
              child: OriginalButton(
                text: 'Create Company Name',
                color: Colors.purple,
                textColor: Colors.white,
                onPressed: () async {
                  //
                  username == 'superadmin'
                      ? print('superadmin')
                      : print('admin');
                  // CompanyScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompanyScreen(
                        // user: user,
                        username: username,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 6),
            Visibility(
              visible: username == 'admin1' ||
                      username == 'admin2' ||
                      username == 'admin3' ||
                      username == 'admin4' ||
                      username == 'admin5'
                  ? true
                  : false,
              child: OriginalButton(
                text: 'Create Bulk UserId',
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () async {
                  //
                  username == 'superadmin'
                      ? print('superadmin')
                      : print('admin');
                  // CompanyScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateAccountBulk(
                        // user: user,
                        username: username,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
