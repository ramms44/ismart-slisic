import 'package:flutter/material.dart';
import 'package:flutter_web_psychotest/model/user.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

/// variables login page
String userid,
    password,
    username,
    userCompany,
    versionQuiz,
    nameBiodata,
    noHp,
    gender,
    emails,
    tanggalLahir,
    pendidikan,
    typeuserid;

bool isLogedin = false,
    iscantLogin = false,
    isLogedinBiodata = false,
    isPrefInstruction = false,
    isSuccessLogin,
    isLogin;

var answerd, user;

int soal, score1st, score2nd, checkidlength = 0;

double scale, zoom;
List<Users> users = List<Users>();
Map<String, dynamic> userdata;

/// variables home page
var loginSession;
String userIsLogout;
//

class homepage {
  // bool isDoneQuiz = false, isNotLogin = false, isPrefBiodata = false;

  // var formKey = new GlobalKey<FormState>();
  // static int refreshNum = 10; // number that changes when refreshed
  // Stream<int> counterStream =
  //     Stream<int>.periodic(Duration(seconds: 3), (x) => refreshNum);
  // static GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  //     GlobalKey<LiquidPullToRefreshState>();
  // static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var user, username, loginSession;
  String userCompany, userIsLogout;
}
