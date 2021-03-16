import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'quizPage.dart';
import 'otherQuizPage/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_psychotest/pages/quiz/models/category.dart';
import 'package:flutter_web_psychotest/pages/quiz/models/question.dart';
import 'package:flutter_web_psychotest/resources/apiProvider.dart';
import 'package:flutter_web_psychotest/styles/string.dart';
import 'package:flutter_web_psychotest/widgets/bottomNavbar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class InstructionQuiz extends StatefulWidget {
  final Category category;
  //
  // var mydata;
  final String name;
  final String noHp;
  Image foto;
  final String gender;
  final String email;
  final String tanggalLahir;
  final String pendidikan;
  String userVersionQuiz;

  final int soal;
  var username;
  var user;
  var loginSession;
  int durationTest;
  // final ;
  var answersdTemp = new List(24);
  final int score1st;
  final int score2nd;
  // final bool isPrevious;

  InstructionQuiz({
    Key key,
    //
    this.name,
    this.noHp,
    this.gender,
    this.email,
    this.tanggalLahir,
    this.pendidikan,
    this.foto,
    //
    this.soal,
    this.score1st,
    this.score2nd,
    this.answersdTemp,
    this.category,
    // this.user,
    this.loginSession,
    this.username,
    this.durationTest,
    this.userVersionQuiz,
  }) : super(key: key);
  @override
  _InstructionQuizState createState() => _InstructionQuizState(
        this.name,
        this.noHp,
        this.gender,
        this.email,
        this.tanggalLahir,
        this.pendidikan,
        this.foto,
        //
        this.soal,
        this.score1st,
        this.score2nd,
        this.answersdTemp,
        this.category,
        // this.user,
        this.loginSession,
        this.durationTest,
        this.username,
        this.userVersionQuiz,
      );
}

class _InstructionQuizState extends State<InstructionQuiz> {
  //
  String userCompany;
  int durationTest;
  String userVersionQuiz;
  var username;
  var answersdTemp = new List(24);

  //
  @override
  void initState() {
    // print('answersdTemp: $answersdTemp');
    //
    // print('soal pada instruction page: $soal');
    // //
    // print('name pada instruction page : $name');
    // print('email pada instruction page : $email');
    // print('gender pada instruction page : $gender');
    // print('noHp pada instruction page : $noHp');
    // print('pendidikan pada instruction page : $pendidikan');
    // print('tanggal lahir pada instruction page : $tanggalLahir');
    // print('get data biodata complete');
    // //
    // print('score 1 pada instruction page $score1st');
    // print('score 2 pada instruction page $score2nd');
    // print('score d pada instruction page $answersdTemp');
    // print(
    //     'score d1_1 pada instruction page ${answersdTemp == null ? '' : answersdTemp[0][0]}');
    // print(
    //     'score d1_2 pada instruction page ${answersdTemp == null ? '' : answersdTemp[0][1]}');
    // print(
    //     'score d2_1 pada instruction page ${answersdTemp == null ? '' : answersdTemp[1][0]}');
    // print(
    //     'score d2_2 pada instruction page ${answersdTemp == null ? '' : answersdTemp[1][1]}');
    // print(
    //     'score d3_1 pada instruction page ${answersdTemp == null ? '' : answersdTemp[2][0]}');
    // print(
    //     'score d3_2 pada instruction page ${answersdTemp == null ? '' : answersdTemp[2][1]}');

    // print('username pada instruction page: $username');

    //
    if (username.contains(new RegExp(r'eka', caseSensitive: false))) {
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
    getDataCompany();
    versionQuiz(username);

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

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(Duration(seconds: 3), (x) => refreshNum);

  final formKey = new GlobalKey<FormState>();
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
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }

  versionQuiz(username) async {
    // userid for version questions apps
    // username = ekaa1000, jika username[3] atau char ke 4 pada string username == 'a', maka app test versi 1
    if (username[3] == 'a') {
      // version quiz 1 (w, n, d, & b quistions for user test)
      setState(() {
        userVersionQuiz = 'version_1';
      });
      print('versionQuiz : $versionQuiz');
      // username = ekab1000, jika username[3] atau char ke 4 pada string username == 'b', maka app test versi 2
    } else if (username[3] == 'b') {
      // version quiz 2 (w & d)
      setState(() {
        userVersionQuiz = 'version_2';
      });
      print('versionQuiz : $versionQuiz');
      // username = ekac1000, jika username[3] atau char ke 4 pada string username == 'c', maka app test versi 2
    } else if (username[3] == 'c') {
      // version quiz 2 (d)
      setState(() {
        userVersionQuiz = 'version_3';
      });
      print('versionQuiz : $versionQuiz');
    }

    print('version pada instruction page $userVersionQuiz');
  }

  int score1Temp, score2Temp;
  var answerDTemp, answerBTemp;

  //
  int _noOfQuestions;
  String _difficulty;
  bool processing;
  //
  String companyName;
  //
  var loginSession;
  final Category category;
  //
  // var mydata;
  final String name;
  final String noHp;
  Image foto;
  final String gender;
  final String email;
  final String tanggalLahir;
  final String pendidikan;
  final int soal;
  var user;
  final int score1st;
  final int score2nd;

  _InstructionQuizState(
    this.name,
    this.noHp,
    this.gender,
    this.email,
    this.tanggalLahir,
    this.pendidikan,
    this.foto,
    //
    this.soal,
    this.score1st,
    this.score2nd,
    this.answersdTemp,
    this.category,
    // this.user,
    this.loginSession,
    this.durationTest,
    this.username,
    this.userVersionQuiz,
  );

  //
  getDataCompany() async {
    if (username.contains(new RegExp(r'eka', caseSensitive: false)) ||
        username.contains(new RegExp(r'star', caseSensitive: false))) {
      // print('user from companyA');
      setState(() {
        userCompany = 'user1';
      });
    }
    if (username.contains(new RegExp(r'user2', caseSensitive: false))) {
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
    // ignore: deprecated_member_use
    DocumentSnapshot company = await Firestore.instance
        .collection('company')
        .doc(userCompany == 'user1'
            ? 'company_name'
            : userCompany == 'user2'
                ? 'company_name_2'
                : userCompany == 'user3'
                    ? 'company_name_3'
                    : userCompany == 'user4'
                        ? 'company_name_4'
                        : 'company_name_5')
        .get();

    setState(() {
      companyName = company['name'];
    });
    print('name = $companyName');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    print('answersdTemp: $answersdTemp');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 200,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        soal == 1
                            ? testW
                            : soal == 2
                                ? testN
                                : soal == 3
                                    ? testD
                                    : testB,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Image(
                image: AssetImage(
                  logoImgiSmart,
                ),
                width: 200,
              ),
            ),
            Container(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              noHp,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              companyName == null ? 'Loading' : companyName,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: foto == null
                        ? Icon(Icons.person, size: 80)
                        : Image(
                            image: foto.image,
                            width: 80,
                            height: 80,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavnBar(),
      backgroundColor: Colors.white,
      body: Container(
        child: LiquidPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: true,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        soal == 1
                            ? instructionTestW
                            : soal == 2
                                ? instructionTestN
                                : soal == 3
                                    ? instructionTestD
                                    : instructionTestB,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16.0,
                          height: 1.5,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: soal == 4 || soal == 2 ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                soal == 1 ? exampleTestW : exampleTestD,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0,
                                  height: 1.5,
                                  letterSpacing: 1.0,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Visibility(
                              visible: soal == 3 ? true : false,
                              child: Image(
                                image: AssetImage(
                                  imgExampleTestD,
                                ),
                                width: 600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.green,
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        child: IconButton(
                          icon: new Icon(
                            Icons.input,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            /* Your code */
                            _startQuiz();
                          },
                        ),
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

  //
  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });

    try {
      List<Question> questions = (soal == 1)
          ? await getQuestionsW(widget.category, _noOfQuestions, _difficulty)
          : (soal == 2)
              ? await getQuestionsN(
                  widget.category, _noOfQuestions, _difficulty)
              : (soal == 3)
                  ? await getQuestionsD(
                      widget.category, _noOfQuestions, _difficulty)
                  : await getQuestionsB(
                      widget.category, _noOfQuestions, _difficulty);
      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ErrorPage(
              message:
                  "There are not enough questions in the category, with the options you selected.",
            ),
          ),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizPage(
            // quistion param
            // bio params
            name: name,
            noHp: noHp,
            gender: gender,
            email: email,
            tanggalLahir: tanggalLahir,
            pendidikan: pendidikan,
            foto: foto,
            soal: soal,
            score1: score1st,
            score2: score2nd,
            answersdTemp: answersdTemp,
            user: user,
            loginSession: loginSession,
            username: username,
            questions: questions,
            category: widget.category,
            userVersionQuiz: userVersionQuiz,
          ),
        ),
      );
    } on SocketException catch (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ErrorPage(
            message:
                "Can't reach the servers, \n Please check your internet connection.",
          ),
        ),
      );
    } catch (e) {
      print(e.message);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ErrorPage(
            message: "Unexpected error trying to connect to the API",
          ),
        ),
      );
    }
    setState(() {
      processing = false;
    });
  }
}
