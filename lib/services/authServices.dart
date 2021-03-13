import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_psychotest/pages/dashboard/main/dashboardMain.dart';
import 'package:flutter_web_psychotest/pages/home/homePage.dart';
import 'package:flutter_web_psychotest/pages/login/loginPage.dart';

class AuthService {
  // String _email;
  // String password;
  // Handle Authentication
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.data != null && !snapshot.hasError) {
          //
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User user = auth.currentUser;
          final email = user.email;
          //
          print('user data email : ${user.email}');
          print('user data creation time : ${user.metadata.creationTime.day}');
          //
          print('user data email : ${user.tenantId}');
          //
          if (email == 'yudi@prakarsa.com' ||
              email == 'yudikc@gmail.com' ||
              email == 'admin@mail.com' ||
              email == 'superadmin@mail.com') {
            // you are login with admin user or superadmin
            return DashboardPage(
              user: email,
            );
          } else {
            // login with user
            return HomePage(
              user: user,
            );
          }
        } else {
          return LoginPage();
        }
      },
    );
  }

  // Sign Out function
  signOut() {
    // FirebaseAuth.instance.signOut();
    // print('Signed out');
  }

  // Sign in function
  signIn(String username, String password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: '${username}@mail.com',
      password: password,
    )
        .then((user) {
      print('Signed in');
      // _email = email;
      // print('user _email: $userEmail');
    }).catchError((e) {
      print(e);
    });
  }
}
