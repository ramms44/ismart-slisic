import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_psychotest/pages/biodata/biodataPage.dart';
import 'package:flutter_web_psychotest/pages/login/loginPage.dart';
import 'package:flutter_web_psychotest/pages/quiz/models/userCheckModel.dart';
import 'package:flutter_web_psychotest/widgets/backbutton/src/back_button_interceptor.dart';
import 'package:flutter_web_psychotest/widgets/bottomNavbar.dart';
import 'package:flutter_web_psychotest/widgets/functions.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:flutter_web_psychotest/styles/string.dart';
import 'package:flutter_web_psychotest/services/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

// date time
DateTime timeNow = DateTime.now();

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    @required this.user,
    @required this.username,
    this.loginSession,
    this.versionQuiz,
  }) : super(key: key);
  var user;
  var username;
  var loginSession;
  final String versionQuiz;
  @override
  _HomePageState createState() => _HomePageState(
        user,
        username,
        loginSession,
        versionQuiz,
      );
}

class _HomePageState extends State<HomePage> {
  //
  //
  List<String> _day = ['fri'];
  //
  var user, username, loginSession;
  String userCompany, userIsLogout;
  final String versionQuiz;
  //
  bool isDoneQuiz = false, isNotLogin = false, isPrefBiodata = false;
  //
  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(Duration(seconds: 3), (x) => refreshNum);

  final formKey = new GlobalKey<FormState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print('username : ${username}');
    print('username char ke 4 : ${username[3]}');
    getDataUser();

    /// add back button interceptor function
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
      refreshNum = new Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              _refreshIndicatorKey.currentState.show();
            },
          ),
        ),
      );
    });
  }

  List<UserCheck> _users = List<UserCheck>();
  List<UserCheck> users = List<UserCheck>();

  _saveData() async {
    // share preference pref
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', username);
    pref.setBool('isPrefBiodata', isPrefBiodata);
  }

  // get data user have quiz or not
  getDataUser() async {
    int lengthData;
    // ignore: deprecated_member_use
    Firestore.instance.collection('user_have_quiz').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        // print(result.data());
        setState(() {
          lengthData = querySnapshot.size;
        });
        users.add(
          UserCheck(
            userCheckid: result.data()['userid'],
            // createdAt: result.data()['createdAt'.toString()],
          ),
        );
      });
      // print('lengthData : $lengthData');
      for (var i = 0; i < lengthData; i++) {
        // print('users[$i].userCheckid : ${users[i].userCheckid}');
        if (users[i].userCheckid == username) {
          // print('userid sudah melakukan quiz test : ${users[i].userCheckid}');
          setState(() {
            isDoneQuiz = !isDoneQuiz;
            // username = '';
          });
        } else {
          // print('userid belum melakukan quiz test');
          if (username.contains(new RegExp(r'eka', caseSensitive: false)) ||
              username.contains(new RegExp(r'star', caseSensitive: false))) {
            // print('user from companyA');
            setState(() {
              userCompany = 'user1';
            });
          }
          if (username.contains(new RegExp(r'user2', caseSensitive: false))||
              username.contains(new RegExp(r'tes', caseSensitive: false))) {
            // print('user from companyB');
            setState(() {
              userCompany = 'user2';
            });
          }
          if (username.contains(new RegExp(r'user3', caseSensitive: false))) {
            // print('user from companyB');
            setState(() {
              userCompany = 'user3';
            });
          }
          if (username.contains(new RegExp(r'user4', caseSensitive: false))) {
            // print('user from companyB');
            setState(() {
              userCompany = 'user4';
            });
          }
          if (username.contains(new RegExp(r'user5', caseSensitive: false))) {
            // print('user from companyB');
            setState(() {
              userCompany = 'user5';
            });
          }
        }
      }
    });
    return users;
  }

  // sign out
  signOut() async {
    //
    setState(() {
      isNotLogin = true;
      userIsLogout = username;
    });
    // ignore: deprecated_member_use
    // await Firestore.instance.collection('session').add({
    //   'logout_time': timeNow,
    //   'login_time': loginSession,
    //   'username': username,
    // });
    await FirestoreMethods().addSession({
      'logout_time': timeNow,
      'login_time': loginSession,
      'username': username,
    });
    FirebaseFirestore.instance
        .collection("userIsLogin")
        .where("username", isEqualTo: userIsLogout)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("userIsLogin")
            .doc(element.id)
            .delete()
            .then((value) {
          print("Success!");
        });
      });
    });

    print("LOGOFF SUCCESS");
    FunctionsClass().clearPref();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(
            // email: username,
            ),
      ),
    );
  }

  // UserCredential
  ParseUser parseUser;

  _HomePageState(
    this.user,
    this.username,
    this.loginSession,
    this.versionQuiz,
  );

  TextEditingController controller = TextEditingController(text: 'No Name');

  @override
  Widget build(BuildContext context) {
    // title web
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    // print('isDoneQuiz: $isDoneQuiz');
    //80% of screen width
    double screenWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(
                logoImgiSmart,
              ),
              width: 200,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavnBar(),
      body: LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: true,
        child: Builder(
          builder: (context) => Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: [
                        Text(
                          descParagraph1st,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          descParagraph2nd,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          descParagraph3rd,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: BorderSide(color: Colors.blue),
                            ),
                            color: Colors.blue,
                            onPressed: () {
                              signOut();
                            },
                            child: const Text(
                              'LOG OUT',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: BorderSide(color: Colors.blue),
                            ),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                isPrefBiodata = true;
                              });

                              FunctionsClass()
                                  .savePrefHome(username, isPrefBiodata);
                              isDoneQuiz == false
                                  ? Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                      builder: (context) => BiodataPage(
                                        // title: "Biodata",
                                        loginSession: loginSession,
                                        username: username,
                                        versionQuiz: versionQuiz,
                                      ),
                                    ))
                                  // ignore: deprecated_member_use
                                  : FunctionsClass().showSnackBar(context,
                                      'Anda Sudah Melakukan Test Online');
                            },
                            child: const Text(
                              'START',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
