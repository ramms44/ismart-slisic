import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/ui/widgets/authForm.dart';
import 'package:flutter_web_psychotest/styles/string.dart';

enum AuthType {
  login,
  register,
}

class AuthScreen extends StatefulWidget {
  final AuthType authType;
  final username;
  final user;

  const AuthScreen({
    Key key,
    this.authType,
    this.username,
    this.user,
  }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState(
        authType,
        username,
        user,
      );
}

class _AuthScreenState extends State<AuthScreen> {
  var username;
  final user;
  final AuthType authType;
  _AuthScreenState(
    this.authType,
    this.username,
    this.user,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    print('username pada auth screen : $username');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 65),
                      Text(
                        umScreenTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Hero(
                        tag: 'logoAnimation',
                        child: Image.asset(
                          logoImgCreateAccount,
                          height: 250,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AuthForm(
              authType: widget.authType,
              username: username,
              user: user,
            ),
          ],
        ),
      ),
    );
  }
}
