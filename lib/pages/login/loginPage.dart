import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_psychotest/pages/biodata/biodataPage.dart';
import 'package:flutter_web_psychotest/pages/quiz/pages/instruction.dart';
import 'package:flutter_web_psychotest/styles/string.dart';
import 'package:flutter_web_psychotest/styles/variables.dart';
import 'package:flutter_web_psychotest/widgets/functions.dart';
import 'package:flutter_web_psychotest/pages/dashboard/main/dashboardMain.dart';
import 'package:flutter_web_psychotest/pages/home/homePage.dart';
import 'package:flutter_web_psychotest/widgets/textField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_psychotest/widgets/zoom_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

DateTime loginSession = DateTime.now();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(Duration(seconds: 3), (x) => refreshNum);
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  /// [Login] functions without dual login
  Login(username, pass, email) async {
    Firestore.instance.collection('userIsLogin').get().then((querySnapshot) {
      print('querySnapshot.size : ${querySnapshot.size}');
      querySnapshot.docs.toList().asMap().forEach((key, value) {
        checkidlength = key;
        print('checkidlength : $checkidlength');
        if (value.data()['username'] != username) {
          setState(() {
            iscantLogin = iscantLogin == true ? true : false;
          });
          print('iscantLogin: $iscantLogin');
        }
        if (value.data()['username'] == username) {
          setState(() {
            iscantLogin = true;
          });
          print('iscantLogin: $iscantLogin');
          print('cant login');
          FunctionsClass().showSnackBar(context, 'Anda Sedang Login');
          FunctionsClass().clearPref();
        }
        if (checkidlength == querySnapshot.size - 1 && iscantLogin == false) {
          print('you can login after check until last key : $checkidlength');
          useridCheck(username, password);
        }
      });
    });
  }

  /// update login method [useridCheck] with 'userid' collection
  useridCheck(username, password) async {
    bool isSuccessLogin = false;
    FirebaseFirestore.instance
        .collection("userid") // userid database firestore
        .where("username", isEqualTo: username)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("userid")
            .doc(element.id)
            .get()
            .then((value) {
          ///
          setState(() {
            isSuccessLogin = true;
            isLogedin = true;
          });

          /// [userVersionQuiz]
          userVersionQuiz(username);

          /// [save data pref login page]
          FunctionsClass().savePrefLogin(userid, isLogedin);
          // print("value : $value");
          // print("Success!");
          // print("isLogedin : $isLogedin");
          if (username == password && username != null ||
              password != null && isSuccessLogin == true) {
            print("Success login!");
            FunctionsClass().showSnackBar(context, 'Anda Berhasil Login');
            if (username == 'superadmin' ||
                username == 'admin1' ||
                username == 'admin2' ||
                username == 'admin3' ||
                username == 'admin4' ||
                username == 'admin5') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardPage(
                    user: user,
                    username: username,
                    loginSession: loginSession,
                  ),
                ),
              );
              FunctionsClass().clearPref();
            }
            if (username.contains(new RegExp(r'eka', caseSensitive: false)) ||
                username.contains(new RegExp(r'star', caseSensitive: false)) ||
                username.contains(new RegExp(r'tes', caseSensitive: false))) {
              Firestore.instance.collection('userIsLogin').add({
                'islogin': isLogedin,
                'username': username,
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    user: user,
                    username: username,
                    loginSession: loginSession,
                    versionQuiz: versionQuiz,
                  ),
                ),
              );
            }
            if (username.contains(new RegExp(r'test', caseSensitive: false)) ||
                username.contains(new RegExp(r'aman', caseSensitive: false))) {
              Firestore.instance.collection('userIsLogin').add({
                'islogin': isLogedin,
                'username': username,
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    user: user,
                    username: username,
                    loginSession: loginSession,
                    versionQuiz: versionQuiz,
                  ),
                ),
              );
            }
          } else {
            FunctionsClass().clearPref();
            print('password / userid salah'); //
          }
        });
      });
    });
    username != password
        ? FunctionsClass().showSnackBar(context, 'UserId / Password Salah')
        : null;
  }

  @override
  void initState() {
    // FunctionsClass().clearPref();
    print('typeuserid : $typeuserid');
    getValidationData().whenComplete(
      () async {
        print(
            'isLogedinBiodata initstate getvalidation whencomplete : $isLogedinBiodata');
        print('isPrefInstruction :$isPrefInstruction');
        isLogedin == true &&
                (isLogedinBiodata == null || isLogedinBiodata == false)
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    user: user,
                    username: username,
                    loginSession: loginSession,
                  ),
                ),
              )
            : isLogedinBiodata == true &&
                    isLogedin == true &&
                    (isPrefInstruction == false || isPrefInstruction == null)
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BiodataPage(
                        user: user,
                        loginSession: loginSession,
                        username: username,
                      ),
                    ),
                  )
                : isLogedinBiodata == true &&
                        isLogedin == true &&
                        isPrefInstruction == true
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InstructionQuiz(
                            name: nameBiodata,
                            noHp: noHp,
                            gender: gender,
                            email: emails,
                            tanggalLahir: tanggalLahir,
                            pendidikan: pendidikan,
                            foto: null,
                            soal: soal == null ? 1 : soal,
                            score1st: score1st,
                            score2nd: score2nd,
                            answersdTemp: answerd,
                            loginSession: loginSession,
                            username: username,
                          ),
                        ),
                      )
                    : null;
      },
    );

    ///
    detectRefresh();
    super.initState();
  }

  /// [userVersionQuiz] function with username / userid
  userVersionQuiz(username) async {
    // userid for version questions apps
    // username = ekaa1000, jika username[3] atau char ke 4 pada string username == 'a', maka app test versi 1
    if (username[3] == 'a' || username[3] == 'r') {
      // version quiz 1 (w, n, d, & b quistions for user test)
      setState(() {
        versionQuiz = 'version_1';
      });
      print('versionQuiz : $versionQuiz');
      // username = ekab1000, jika username[3] atau char ke 4 pada string username == 'b', maka app test versi 2
    } else if (username[3] == 'b') {
      // version quiz 2 (w & d)
      setState(() {
        versionQuiz = 'version_2';
      });
      print('versionQuiz : $versionQuiz');
      // username = ekac1000, jika username[3] atau char ke 4 pada string username == 'c', maka app test versi 2
    } else if (username[3] == 'c') {
      // version quiz 2 (d)
      setState(() {
        versionQuiz = 'version_3';
      });
      print('versionQuiz : $versionQuiz');
    }
  }

  Future getValidationData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var obtainLogin = pref.getBool('isLogedin');
    var obtainUsername = pref.getString('username');
    var obtainLogBiodata = pref.getBool('isPrefBiodata');
    var obtainLogInstruction = pref.getBool('isPrefInstruction');
    var obtainnameBiodata = pref.getString('nameBiodata');
    var obtainNoHp = pref.getString('noHp');
    var obtainGender = pref.getString('gender');
    var obtainEmail = pref.getString('emails');
    var obtainTanggalLahir = pref.getString('tanggalLahir');
    var obtainPendidikan = pref.getString('pendidikan');
    var obtainSoal = pref.getInt('soal');
    var obtainScore1 = pref.getInt('score1st');
    var obtainScore2 = pref.getInt('score2nd');
    var obtainAnswerD = pref.getStringList('answerd');
    setState(() {
      isLogedin = obtainLogin;
      username = obtainUsername;
      isLogedinBiodata = obtainLogBiodata;
      isPrefInstruction = obtainLogInstruction;
      nameBiodata = obtainnameBiodata;
      noHp = obtainNoHp;
      gender = obtainGender;
      emails = obtainEmail;
      tanggalLahir = obtainTanggalLahir;
      pendidikan = obtainPendidikan;
      soal = obtainSoal;
      score1st = obtainScore1;
      score2nd = obtainScore2;
      answerd = obtainAnswerD;
    });
  }

  detectRefresh() async {
    html.window.onBeforeUnload.listen((event) async {
      // do something
      print('refresh button detect');
      print('typeuserid : $typeuserid');
      // setState(() {
      //   typeuserid = 'test setstate refresh';
      // // event.cancelable = true;
      // });
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    Size size = MediaQuery.of(context).size;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        child: Builder(
          builder: (context) => Container(
            /// [Zoom] widget
            child: Zoom(
              width: 1000,
              height: 1000,
              canvasColor: Colors.blue,
              backgroundColor: Colors.blue,
              colorScrollBars: Colors.purple,
              opacityScrollBars: 0.9,
              scrollWeight: 10.0,
              centerOnScale: true,
              enableScroll: true,
              doubleTapZoom: true,

              /// [canvasShadow] parameter for shadow canvas disable and enable
              canvasShadow: false,
              zoomSensibility: 2.3,
              initZoom: 0.0,
              onPositionUpdate: (Offset position) {
                print(position);
              },
              onScaleUpdate: (scale, zoom) {
                print("$scale  $zoom");
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(
                                logoImgiSmart,
                              ),
                              width: 300,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 300,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        child: BeautyTextfield(
                                          width: 250,
                                          height: 60,
                                          fontSize: 16,
                                          duration: Duration(milliseconds: 300),
                                          inputType: TextInputType.text,
                                          prefixIcon: Icon(Icons.person),
                                          placeholder: "UserId",
                                          onTap: () {
                                            print('Click');
                                          },
                                          onChanged: (value) {
                                            userid = value;
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: BeautyTextfield(
                                          width: 250,
                                          height: 60,
                                          fontSize: 16,
                                          obscureText: true,
                                          maxLines: 1,
                                          duration: Duration(milliseconds: 300),
                                          inputType: TextInputType.text,
                                          prefixIcon: Icon(Icons.settings),
                                          placeholder: "Password",
                                          onTap: () {
                                            print('Click');
                                          },
                                          onChanged: (value) {
                                            password = value;
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(16),
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                side: BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              color: Colors.blue,
                                              onPressed: () {
                                                // _saveData();
                                                FunctionsClass().savePrefLogin(
                                                    userid, isLogedin);
                                                setState(() {
                                                  // isLogedin = true;
                                                  iscantLogin = false;
                                                });
                                                print(
                                                    'isloggedin : $isLogedin');
                                                Login(userid, password, '');
                                              },
                                              child: const Text(
                                                'SIGN IN',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
