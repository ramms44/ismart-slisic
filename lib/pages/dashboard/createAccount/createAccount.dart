import 'package:flutter/material.dart';

import 'ui/screens/authScreens.dart';
import 'ui/screens/homeScreens.dart';
import 'ui/screens/introScreens.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({
    Key key,
    @required this.user,
    @required this.username,
  }) : super(key: key);
  var user;
  var username;
  @override
  _CreateAccountState createState() => _CreateAccountState(
        user,
        username,
      );
}

class _CreateAccountState extends State<CreateAccount> {
  var user;
  var username;

  _CreateAccountState(
    this.user,
    this.username,
  );

  @override
  Widget build(BuildContext context) {
    // print('user object id: ${user.objectId}');
    print('username pada creeat account page: ${username}');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xfff2f9fe),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[200],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      // create user test or admin
      home: AuthScreen(
        authType: AuthType.register,
        username: username,
        user: user,
      ),
      routes: {
        'intro': (context) => IntroScreen(),
        'home': (context) => HomeScreen(
              user: user,
            ),
        'login': (context) => AuthScreen(
              authType: AuthType.login,
              username: username,
            ),
        'register': (context) => AuthScreen(
              authType: AuthType.register,
              username: username,
            ),
      },
    );
  }
}
