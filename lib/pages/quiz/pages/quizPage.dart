import 'dart:async';
import 'dart:math';
import 'package:flutter_web_psychotest/pages/dashboard/userEntries/widgetUserEntries/userCard.dart';

import 'instruction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_psychotest/pages/dashboard/googleSheet/controller/formController.dart';
import 'package:flutter_web_psychotest/pages/dashboard/googleSheet/model/form.dart';
import 'package:flutter_web_psychotest/pages/login/loginPage.dart';
import 'package:flutter_web_psychotest/styles/string.dart';
import 'package:flutter_web_psychotest/widgets/functions.dart';
import 'package:flutter_web_psychotest/widgets/smartSelect/src/model/modal_config.dart';
import 'package:flutter_web_psychotest/widgets/smartSelect/src/tile/tile.dart';
import 'package:flutter_web_psychotest/widgets/smartSelect/src/widget.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_web_psychotest/pages/quiz/models/category.dart';
import 'package:flutter_web_psychotest/pages/quiz/models/question.dart';
import 'package:flutter_web_psychotest/services/crud.dart';
import 'package:flutter_web_psychotest/widgets/bottomNavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'dart:html' as html;

DateTime now = DateTime.now();

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;
  final String name;
  final String noHp;
  Image foto;
  final String gender;
  final String email;
  final String tanggalLahir;
  final String pendidikan;
  final int soal;
  final bool isPrevQuiz;
  final int marks;
  final user;
  final loginSession;
  String companyName;
  int durationTest;
  var answersdTemp = new List(24);
  var username;
  final int score1;
  final int score2;
  String userVersionQuiz;

  QuizPage({
    Key key,
    this.name,
    this.noHp,
    this.gender,
    this.email,
    this.tanggalLahir,
    this.pendidikan,
    this.foto,
    this.soal,
    this.score1,
    this.score2,
    this.answersdTemp,
    this.isPrevQuiz,
    this.marks,
    this.user,
    this.loginSession,
    this.companyName,
    this.durationTest,
    this.username,
    this.questions,
    this.category,
    this.userVersionQuiz,
  }) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState(
        name,
        noHp,
        gender,
        email,
        tanggalLahir,
        pendidikan,
        foto,
        soal,
        score1,
        score2,
        answersdTemp,
        isPrevQuiz,
        marks,
        user,
        loginSession,
        companyName,
        durationTest,
        username,
        questions,
        category,
        userVersionQuiz,
      );
}

class _QuizPageState extends State<QuizPage> {
  List<String> multipleOptions = [''];
  String userVersionQuiz;
  String companyName;
  String userIsLogout;
  int durationTest;
  int indexd = 0;
  int index = 0;
  int correctAnswer = 0;
  int timer = 0;
  int soal;
  bool isPrevQuiz;
  bool isMost = true;
  bool isLeast = true;
  bool canceltimer = false;
  var loginSession;
  var user;
  var answersdTemp = new List(24);
  var username;
  final List<Question> questions;
  final String name;
  final String noHp;
  final Image foto;
  final int marks;

  // scaffold
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // short answer controller
  final shortAnswerController = TextEditingController();
  // question style
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.grey);
  //
  final TextStyle _numberQuestionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  int numberSoalD = 0;
  final Map<int, dynamic> _answers = {};
  final Map<int, dynamic> _answersIndex = {};

  Map<int, dynamic> arrAnswer;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  String categoryName;

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(Duration(seconds: 3), (x) => refreshNum);

  final formKey = new GlobalKey<FormState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

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

  _QuizPageState(
    this.name,
    this.noHp,
    this.gender,
    this.email,
    this.tanggalLahir,
    this.pendidikan,
    this.foto,
    this.soal,
    this.score1,
    this.score2,
    this.answersdTemp,
    this.isPrevQuiz,
    this.marks,
    this.user,
    this.loginSession,
    this.companyName,
    this.durationTest,
    this.username,
    this.questions,
    this.category,
    this.userVersionQuiz,
  );

  final int score1;
  final int score2;
  final Category category;
  final String gender;
  final String email;
  final String tanggalLahir;
  final String pendidikan;

  int durationQuiz = 0;
  int durationQuizTemp = 0;
  int score1Temp;
  int score2Temp;
  int score1st;
  int score2nd;

  String birthDate;
  String levelEducation;
  String userCompany;
  String answersB;

  var answerDTemp = new List(24);
  var answerBTemp;
  var answersD = new List(24);
  var arrAnswersD = new List(2);
  var answersD_key = new List(24);
  var answersD_fix_key = new List(24);
  var arrAnswersD_key = new List(2);
  var arrAnswersD_key_fix = new List(2);
  var arrAnswersD_key_fixs = new List(2);
  var numberAnswerD_key = new List(2);
  var arrAnswersB = new List(30);
  //
  int canchoice = 2;
  int mustChoice = 2;
  //
  bool isChoice1 = false;
  bool isChoice2 = false;
  bool isChoice3 = false;
  bool isChoice4 = false;
  //
  bool visibleQuizPage = true;
  bool visibleResultPage = false;
  bool isPrev = false;
  bool isPrevFromResult = false;
  bool isDisablePrev = false;
  //
  bool isDoneChoice = false;
  //
  bool isDoneChoiceMost1 = false;
  bool isDoneChoiceMost2 = false;
  bool isDoneChoiceMost3 = false;
  bool isDoneChoiceMost4 = false;
  //
  bool isDoneChoiceLeast1 = false;
  bool isDoneChoiceLeast2 = false;
  bool isDoneChoiceLeast3 = false;
  bool isDoneChoiceLeast4 = false;
  //
  bool isIncorrect = false;
  bool isCorrect = false;
  var hostname;

  @override
  void initState() {
    getHost();
    starttimer();
    var questCategory = widget.questions[_currentIndex].categoryName;

    setState(() {
      categoryName = questCategory;
    });

    // change value seconds timer setiap kategori soal
    timer = (soal == 1)
        ? 800
        : (soal == 2)
            ? 700
            : (soal == 3)
                ? 900
                : 900;

    if (soal == 2) {
      score1st = marks;
    } else if (soal == 3) {
      score2nd = marks;
    }
    //
    isPrevQuiz == true && (soal == 1 || soal == 2 || soal == 4)
        ? _currentIndex = questions.length - 1
        : isPrevQuiz == true && soal == 3
            ? _currentIndex = questions.length - 4
            : _currentIndex = _currentIndex;

    //
    isPrevQuiz == true && (soal == 1 || soal == 2 || soal == 4)
        ? numberSoalD = questions.length - 1
        : isPrevQuiz == true && soal == 3
            ? numberSoalD = 23
            : numberSoalD = numberSoalD;

    //
    if (soal == 1) {
      score1st = correctAnswer;
    } else if (soal == 2) {
      score2nd = correctAnswer;
    }

    if (username.contains(new RegExp(r'eka', caseSensitive: false)) ||
        username.contains(new RegExp(r'star', caseSensitive: false))) {
      setState(() {
        userCompany = 'user1';
      });
    }
    if (username.contains(new RegExp(r'user2', caseSensitive: false))) {
      setState(() {
        userCompany = 'user2';
      });
    }
    if (username.contains(new RegExp(r'user3', caseSensitive: false))) {
      setState(() {
        userCompany = 'user3';
      });
    }
    if (username.contains(new RegExp(r'user4', caseSensitive: false))) {
      setState(() {
        userCompany = 'user4';
      });
    }
    if (username.contains(new RegExp(r'user5', caseSensitive: false))) {
      setState(() {
        userCompany = 'user5';
      });
    }

    getDataCompany();
    print('userCompany : $userCompany');
    versionQuiz(username);

    /// add back button interceptor function
    BackButtonInterceptor.add(myInterceptor);

    super.initState();
  }

  // check hostname
  getHost() async {
    hostname = html.window.location.host;
    print('hostname : $hostname');
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

    print('version pada quiz page $userVersionQuiz');
  }

  // start timer fun
  starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          // enable visible result page
          visibleQuizPage = false;
          visibleResultPage = true;
          isDisablePrev = true;
          //
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
          durationQuiz = durationQuiz + 1;
        }
      });
    });
    print('isDisablePrev: $isDisablePrev');
  }

  //
  _clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    preferences.remove('isLogedin');
  }

  //
  _saveData() async {
    // share preference pref
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('soal', soal);
    pref.setInt('score1st', score1st == null ? score1 : score1st);
    pref.setInt('score2nd', score2nd == null ? score2 : score2nd);
    pref.setStringList(
        'answerd', answersdTemp == null ? answersD : answersdTemp);
    //
  }

  // cek validasi data user - 3
  _addDataUser() async {
    print('=========== add data user ===========');
    Firestore.instance
        .collection(userCompany == 'user1'
            ? 'users_1'
            : userCompany == 'user2'
                ? 'users_2'
                : userCompany == 'user3'
                    ? 'users_3'
                    : userCompany == 'user4'
                        ? 'users_4'
                        : 'users_5')
        .add(userVersionQuiz == 'version_2'
            ? {
                'name': name,
                'number_phone': noHp,
                'gender': gender,
                'email_address': email,
                'tanggal_lahir': tanggalLahir,
                'pendidikan': pendidikan,
                'create_date': now,
                'score_test_w': score1,
                //
                for (var i = 0; i < 24; i++)
                  'AnswerTestD_no_${i + 1}': answersD_fix_key[i],
                'duration_test': FunctionsClass()
                    .formatHHMMSS(durationQuiz * 2), // durasi pengerjaan soal
                'hostname': hostname,
              }
            : userVersionQuiz == 'version_3'
                ? {
                    'name': name,
                    'number_phone': noHp,
                    'gender': gender,
                    'email_address': email,
                    'tanggal_lahir': tanggalLahir,
                    'pendidikan': pendidikan,
                    'create_date': now,
                    // 'score_test_w': score1,
                    // 'score_test_n': score2,
                    //
                    for (var i = 0; i < 24; i++)
                      'AnswerTestD_no_${i + 1}': answersD_fix_key[i],
                    //
                    // for (var j = 0; j < 30; j++) 'AnswerTestB_no_${j + 1}': arrAnswersB[j],
                    // 'answer_test_b': arrAnswersB,
                    'duration_test': FunctionsClass()
                        .formatHHMMSS(durationQuiz), // durasi pengerjaan soal
                    'hostname': hostname,
                  }
                : {
                    'name': name,
                    'number_phone': noHp,
                    'gender': gender,
                    'email_address': email,
                    'tanggal_lahir': tanggalLahir,
                    'pendidikan': pendidikan,
                    'create_date': now,
                    'score_test_w': score1,
                    'score_test_n': score2,
                    // 'answer_test_d': answersdTemp,
                    //
                    for (var i = 0; i < 24; i++)
                      'AnswerTestD_no_${i + 1}': answersdTemp[i],
                    //
                    for (var j = 0; j < 30; j++)
                      'AnswerTestB_no_${j + 1}': arrAnswersB[j],
                    // 'answer_test_b': arrAnswersB,
                    'duration_test': FunctionsClass()
                        .formatHHMMSS(durationTest), // durasi pengerjaan soal
                    'hostname': hostname,
                  });
  }

  _isDoneQuiz() async {
    Firestore.instance.collection('user_have_quiz').add({
      // cek user data (validator 1) yang sudah test
      'userid': username,
      'create_at': now,
      'nama_host': hostname,
      'mengerjakan_quiz_sampai_bagian': soal,
      'nama_pengguna_smart_online': name,
      'email_pengguna_smart_online': email,
      'nomor_hp_pengguna_smart_online': noHp
    });
  }

  _addSession() async {
    setState(() {
      userIsLogout = username;
    });

    ///[FirestoreMethods]
    await FirestoreMethods().addSession({
      'login_time': loginSession,
      'logout_time': now,
      'username': username,
    });
    //
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
  }

  _signOut() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(
            // email: username,
            ),
      ),
    );
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
    await _clear();
  }

  // Method to Submit Feedback and save it in Google Sheets
  // cek validasi data user 2
  _submitData() async {
    //
    FunctionsClass().showSnackBar(context,
        'Tunggu Sampai Anda Keluar Otomatis Dari Halaman Smart Online');
    print('=========== submit data ==========');
    // Validate returns true if the form is valid, or false
    // otherwise.
    FeedbackForm feedbackForm = FeedbackForm(
      username.toString(), // add username gsheet
      name.toString(),
      email.toString(),
      noHp.toString(),
      gender.toString(),
      pendidikan.toString(),
      tanggalLahir.toString(),
      // score 1 & 2 with scoring 0 - 100
      userVersionQuiz != 'version_3' ? score1.toString() : 'versi app 3',
      userVersionQuiz == 'version_1' ? score2.toString() : 'versi app 2 atau 3',
      // contoh submit data ke google sheet
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[0][1]
          : answersdTemp[0][0].toString(), // most or least, soal 1
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[0][1]
          : answersdTemp[0][1].toString(), // most or least, soal 1
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[1][0]
          : answersdTemp[1][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[1][1]
          : answersdTemp[1][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[2][0]
          : answersdTemp[2][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[2][1]
          : answersdTemp[2][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[3][0]
          : answersdTemp[3][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[3][1]
          : answersdTemp[3][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[4][0]
          : answersdTemp[4][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[4][1]
          : answersdTemp[4][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[5][0]
          : answersdTemp[5][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[5][1]
          : answersdTemp[5][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[6][0]
          : answersdTemp[6][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[6][1]
          : answersdTemp[6][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[7][0]
          : answersdTemp[7][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[7][1]
          : answersdTemp[7][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[8][0]
          : answersdTemp[8][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[8][1]
          : answersdTemp[8][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[9][0]
          : answersdTemp[9][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[9][1]
          : answersdTemp[9][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[10][0]
          : answersdTemp[10][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[10][1]
          : answersdTemp[10][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[11][0]
          : answersdTemp[11][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[11][1]
          : answersdTemp[11][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[12][0]
          : answersdTemp[12][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[12][1]
          : answersdTemp[12][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[13][0]
          : answersdTemp[13][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[13][1]
          : answersdTemp[13][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[14][0]
          : answersdTemp[14][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[14][1]
          : answersdTemp[14][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[15][0]
          : answersdTemp[15][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[15][1]
          : answersdTemp[15][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[16][0]
          : answersdTemp[16][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[16][1]
          : answersdTemp[16][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[17][0]
          : answersdTemp[17][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[17][1]
          : answersdTemp[17][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[18][0]
          : answersdTemp[18][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[18][1]
          : answersdTemp[18][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[19][0]
          : answersdTemp[19][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[19][1]
          : answersdTemp[19][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[20][0]
          : answersdTemp[20][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[20][1]
          : answersdTemp[20][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[21][0]
          : answersdTemp[21][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[21][1]
          : answersdTemp[21][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[22][0]
          : answersdTemp[22][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[22][1]
          : answersdTemp[22][1].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[23][0]
          : answersdTemp[23][0].toString(),
      userVersionQuiz == 'version_2' || userVersionQuiz == 'version_3'
          ? answersD_fix_key[23][1]
          : answersdTemp[23][1].toString(),
      //
      // note belum bisa pakai looping
      // answers B

      arrAnswersB != null ? arrAnswersB[0].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[1].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[2].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[3].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[4].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[5].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[6].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[7].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[8].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[9].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[10].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[11].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[12].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[13].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[14].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[15].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[16].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[17].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[18].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[19].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[20].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[21].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[22].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[23].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[24].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[25].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[26].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[27].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[28].toString() : 'Versi App 2 atau 3',
      arrAnswersB != null ? arrAnswersB[29].toString() : 'Versi App 2 atau 3',
      //
    );

    FormController formController = FormController();
    FormController2 formController2 = FormController2();
    FormController3 formController3 = FormController3();
    FormController4 formController4 = FormController4();
    FormController5 formController5 = FormController5();

    // _showSnackbar("Submitting Feedback");

    // Submit 'feedbackForm' and save it in Google Sheets.
    userCompany == 'user1'
        ? formController.submitForm(
            feedbackForm,
            (String response) {
              print("Response: $response");
              if (response == FormController.STATUS_SUCCESS) {
                // cek validasi data user ke - 4
                print('success');
                // Feedback is saved succesfully in Google Sheets.
                FunctionsClass().showSnackBar(context, 'Submit Data Berhasil');
                // signOut user
                _signOut();
                // _showSnackbar("Feedback Submitted");
              } else {
                // Error Occurred while saving data in Google Sheets.
                // _showSnackbar("Error Occurred!");
                FunctionsClass().showSnackBar(context, 'Submit Data Error');
                print('error');
              }
            },
          )
        : userCompany == 'user2'
            ? formController2.submitForm(
                feedbackForm,
                (String response) {
                  print("Response: $response");
                  if (response == FormController.STATUS_SUCCESS) {
                    print('success');
                    // Feedback is saved succesfully in Google Sheets.
                    FunctionsClass()
                        .showSnackBar(context, 'Submit Data Berhasil');
                    // signOut user
                    _signOut();
                    // _showSnackbar("Feedback Submitted");
                  } else {
                    // Error Occurred while saving data in Google Sheets.
                    // _showSnackbar("Error Occurred!");
                    print('error');
                  }
                },
              )
            : userCompany == 'user3'
                ? formController3.submitForm(
                    feedbackForm,
                    (String response) {
                      print("Response: $response");
                      if (response == FormController.STATUS_SUCCESS) {
                        print('success');
                        // Feedback is saved succesfully in Google Sheets.
                        FunctionsClass()
                            .showSnackBar(context, 'Submit Data Berhasil');
                        // signOut user
                        _signOut();
                      } else {
                        // Error Occurred while saving data in Google Sheets.
                        // _showSnackbar("Error Occurred!");
                        print('error');
                      }
                    },
                  )
                : userCompany == 'user4'
                    ? formController4.submitForm(
                        feedbackForm,
                        (String response) {
                          print("Response: $response");
                          if (response == FormController.STATUS_SUCCESS) {
                            print('success');
                            // Feedback is saved succesfully in Google Sheets.
                            FunctionsClass()
                                .showSnackBar(context, 'Submit Data Berhasil');
                            // signOut user
                            _signOut();
                          } else {
                            // Error Occurred while saving data in Google Sheets.
                            // _showSnackbar("Error Occurred!");
                            print('error');
                          }
                        },
                      )
                    : formController5.submitForm(
                        feedbackForm,
                        (String response) {
                          print("Response: $response");
                          if (response == FormController.STATUS_SUCCESS) {
                            print('success');
                            // Feedback is saved succesfully in Google Sheets.
                            FunctionsClass()
                                .showSnackBar(context, 'Submit Data Berhasil');
                            // signOut user
                            _signOut();
                          } else {
                            // Error Occurred while saving data in Google Sheets.
                            // _showSnackbar("Error Occurred!");
                            print('error');
                          }
                        },
                      );
  }

  getDataCompany() async {
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
    // dynamic app title
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    //
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
    }

    //
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    Orientation currentOrientation = MediaQuery.of(context).orientation;
    if (currentOrientation == Orientation.portrait) {
      /* ... */
      // print('orientation portrait');
    } else {
      // print('orientation landscape');
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          toolbarHeight: currentOrientation == Orientation.portrait ? 90 : 50,
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                visible: visibleQuizPage,
                child: Container(
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                              fontSize:
                                  currentOrientation == Orientation.portrait
                                      ? 24.0
                                      : 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Soal no. ${numberSoalD + 1} dari ${soal == 3 ? widget.questions.length / 4 : widget.questions.length}",
                            style: TextStyle(
                              fontSize:
                                  currentOrientation == Orientation.portrait
                                      ? 14.0
                                      : 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Sisa Waktu anda ${FunctionsClass().formatHHMMSS(timer)}",
                            style: TextStyle(
                              fontSize:
                                  currentOrientation == Orientation.portrait
                                      ? 12.0
                                      : 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Image(
                  image: AssetImage(
                    logoImgiSmart,
                  ),
                  width: currentOrientation == Orientation.portrait ? 200 : 130,
                ),
              ),
              Visibility(
                visible: visibleQuizPage,
                child: Container(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: currentOrientation ==
                                            Orientation.portrait
                                        ? 24.0
                                        : 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
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
                                    fontSize: currentOrientation ==
                                            Orientation.portrait
                                        ? 16.0
                                        : 12.0,
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
                                    fontSize: currentOrientation ==
                                            Orientation.portrait
                                        ? 16.0
                                        : 12,
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
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: foto == null
                            ? Icon(Icons.person,
                                size: currentOrientation == Orientation.portrait
                                    ? 80
                                    : 40)
                            : Image(
                                image: foto.image,
                                width:
                                    currentOrientation == Orientation.portrait
                                        ? 80
                                        : 40,
                                height:
                                    currentOrientation == Orientation.portrait
                                        ? 80
                                        : 40,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavnBar(),
        body: soal == 1 || soal == 2 || soal == 4
            ? LiquidPullToRefresh(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                showChildOpacityTransition: true,
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: visibleQuizPage,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // soal
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Text(
                                          "${_currentIndex + 1}",
                                          style: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? _numberQuestionStyle.copyWith(
                                                  fontSize: 15.0)
                                              : _numberQuestionStyle,
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      Expanded(
                                        child: Text(
                                          HtmlUnescape().convert(widget
                                              .questions[_currentIndex]
                                              .question),
                                          softWrap: true,
                                          style: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? _questionStyle.copyWith(
                                                  fontSize: 15.0)
                                              : _questionStyle,
                                        ),
                                      ),
                                      soal == 1 && _currentIndex == 11
                                          ? Expanded(
                                              child: Container(
                                                width: 150,
                                                height: 150,
                                                child: Image.network(
                                                  imgNo12,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            )
                                          : soal == 1 && _currentIndex == 17
                                              ? Expanded(
                                                  child: Container(
                                                    width: 150,
                                                    height: 180,
                                                    child: Image.network(
                                                      imgNo18,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                )
                                              : soal == 1 && _currentIndex == 18
                                                  ? Expanded(
                                                      child: Container(
                                                        child: Container(
                                                          width: 150,
                                                          height: 180,
                                                          child: Image.network(
                                                            imgNo19,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : soal == 1 &&
                                                          _currentIndex == 25
                                                      ? Expanded(
                                                          child: Container(
                                                            width: 150,
                                                            height: 180,
                                                            child:
                                                                Image.network(
                                                              imgNo26,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        )
                                                      : soal == 1 &&
                                                              _currentIndex ==
                                                                  33
                                                          ? Expanded(
                                                              child: Container(
                                                                width: 150,
                                                                height: 180,
                                                                child: Image
                                                                    .network(
                                                                  imgNo34,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                // ),
                                                              ),
                                                            )
                                                          : soal == 2 &&
                                                                  _currentIndex ==
                                                                      11
                                                              ? Expanded(
                                                                  child:
                                                                      Container(
                                                                    width: 150,
                                                                    height: 180,
                                                                    child: Image
                                                                        .network(
                                                                      imgNo15,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  // pilihan jawaban
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: widget.questions[_currentIndex]
                                                  .type ==
                                              Type.shortanswer
                                          ? <Widget>[
                                              Container(
                                                width: screenWidth * 0.4,
                                                height: 60,
                                                child: Theme(
                                                  child: TextField(
                                                    controller:
                                                        shortAnswerController,
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.question_answer,
                                                      ),
                                                      labelText: "Jawaban",
                                                      // hintText: "Jawaban",
                                                    ),
                                                    autofocus: true,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _answers[
                                                                _currentIndex] =
                                                            shortAnswerController
                                                                .text;
                                                        //
                                                        isDoneChoice = true;
                                                      });
                                                      _choice();
                                                    },
                                                  ),
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          primaryColor: Colors
                                                              .blueAccent),
                                                ),
                                              ),
                                            ]
                                          : soal == 1 && _currentIndex == 17
                                              ? <Widget>[
                                                  SmartSelect<String>.multiple(
                                                    title:
                                                        'Tap Untuk Memilih Jawaban',
                                                    selectedValue:
                                                        multipleOptions,
                                                    onChange: (selected) {
                                                      setState(() {
                                                        multipleOptions =
                                                            selected.title;
                                                        _answers[
                                                                _currentIndex] =
                                                            selected.title;
                                                        isDoneChoice = true;
                                                      });
                                                    },
                                                    choiceItems: opsiNumber17,
                                                    modalType:
                                                        S2ModalType.popupDialog,
                                                    tileBuilder:
                                                        (context, state) {
                                                      return S2Tile.fromState(
                                                        state,
                                                        isTwoLine: true,
                                                        leading: Container(
                                                          width: 40,
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Icon(Icons
                                                              .question_answer),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ]
                                              : soal == 1 && _currentIndex == 33
                                                  ? <Widget>[
                                                      SmartSelect<
                                                          String>.multiple(
                                                        title:
                                                            'Tap Untuk Memilih Jawaban',
                                                        selectedValue:
                                                            multipleOptions,
                                                        onChange: (selected) {
                                                          setState(() {
                                                            multipleOptions =
                                                                selected.title;
                                                            _answers[
                                                                    _currentIndex] =
                                                                selected.title;
                                                            isDoneChoice = true;
                                                          });
                                                        },
                                                        choiceItems:
                                                            opsiNumber34,
                                                        modalType: S2ModalType
                                                            .popupDialog,
                                                        tileBuilder:
                                                            (context, state) {
                                                          return S2Tile
                                                              .fromState(
                                                            state,
                                                            isTwoLine: true,
                                                            leading: Container(
                                                              width: 40,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Icon(
                                                                  Icons
                                                                      .question_answer),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ]
                                                  : <Widget>[
                                                      ...options.map(
                                                        (option) =>
                                                            RadioListTile(
                                                          title: Text(
                                                            HtmlUnescape()
                                                                .convert(
                                                                    "$option"),
                                                            style: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    800
                                                                ? TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                  )
                                                                : null,
                                                          ),
                                                          groupValue: _answers[
                                                              _currentIndex],
                                                          value: option,
                                                          onChanged: (value) {
                                                            print(
                                                                'click choice');
                                                            setState(() {
                                                              _answers[
                                                                      _currentIndex] =
                                                                  option;
                                                              isDoneChoice =
                                                                  true;
                                                            });
                                                            _choice();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 80,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RaisedButton(
                                          padding: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0)
                                              : null,
                                          child: Text(
                                            "Previous",
                                            style: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    800
                                                ? TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                  )
                                                : TextStyle(
                                                    color: Colors.white,
                                                  ),
                                          ),
                                          onPressed: isDisablePrev == true
                                              ? null
                                              : _previous,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        RaisedButton(
                                          padding: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0,
                                                )
                                              : null,
                                          child: Text(
                                            _currentIndex ==
                                                    (widget.questions.length -
                                                        1)
                                                ? "Save"
                                                : "Next",
                                            style: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    800
                                                ? TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                  )
                                                : TextStyle(
                                                    color: Colors.white,
                                                  ),
                                          ),
                                          onPressed: _nextSubmit,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Result Page
                        Visibility(
                          visible: visibleResultPage,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 150,
                                right: 15,
                                left: 15,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 15.0,
                                        bottom: 15.0,
                                      ),
                                      child: Container(
                                        // child: Padding(
                                        //   padding: const EdgeInsets.all(30.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child: Text(
                                                      (soal == 1) ||
                                                              (soal == 2) ||
                                                              (soal == 4)
                                                          ? stillOnQuiz
                                                          : finalQuiz,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 60,
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  RaisedButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      side: BorderSide(
                                                          color: Colors.blue),
                                                    ),
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      //
                                                      isDisablePrev == true
                                                          ? null
                                                          : setState(() {
                                                              visibleQuizPage =
                                                                  true;
                                                              visibleResultPage =
                                                                  false;
                                                              isPrevFromResult =
                                                                  true;
                                                            });
                                                      _previous();
                                                    },
                                                    child: const Text(
                                                      'Previous',
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      side: BorderSide(
                                                          color: Colors.blue),
                                                    ),
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      // soal == 5
                                                      print('Finished Test');
                                                      if (userVersionQuiz ==
                                                              'version_1'
                                                          ? soal == 4
                                                          : userVersionQuiz ==
                                                                  'version_2'
                                                              ? soal == 3
                                                              : userVersionQuiz ==
                                                                      'version_3'
                                                                  ? soal == 3
                                                                  : soal == 4) {
                                                        // add user data to google sheet
                                                        _submitData();
                                                        // _saveDataScore();

                                                        // add data user to firestore
                                                        _addDataUser();
                                                        //
                                                        // add user session to firestore
                                                        _addSession();
                                                        //
                                                        // is done quiz data
                                                        _isDoneQuiz();
                                                        //
                                                        // await _clear();
                                                        //
                                                        // _saveScoreB();
                                                        //
                                                      } else {
                                                        //
                                                        // _updateData();
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                InstructionQuiz(
                                                              // bio params
                                                              name: name,
                                                              noHp: noHp,
                                                              gender: gender,
                                                              email: email,
                                                              tanggalLahir:
                                                                  tanggalLahir,
                                                              pendidikan:
                                                                  pendidikan,
                                                              foto: foto,
                                                              //
                                                              soal: userVersionQuiz ==
                                                                      'version_1'
                                                                  ? soal
                                                                  : userVersionQuiz ==
                                                                          'version_2'
                                                                      ? soal + 1
                                                                      : soal,
                                                              score1st:
                                                                  score1st ==
                                                                          null
                                                                      ? score1
                                                                      : score1st,
                                                              score2nd:
                                                                  score2nd ==
                                                                          null
                                                                      ? score2
                                                                      : score2nd,
                                                              // answersdTemp:
                                                              //     answersdTemp ==
                                                              //             null
                                                              //         ? answersD
                                                              //         : answersdTemp,
                                                              // user: user,
                                                              durationTest:
                                                                  durationQuiz,
                                                              username:
                                                                  username,
                                                            ),
                                                          ),
                                                        );
                                                        setState(() {
                                                          soal = soal + 1;
                                                        });
                                                        print(
                                                            'save soal pada soal .....$soal');
                                                        _saveData();
                                                      }
                                                    },
                                                    child: Text(
                                                      soal == 4
                                                          ? 'Log Out'
                                                          : 'Save',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : soal == 3
                ? LiquidPullToRefresh(
                    key: _refreshIndicatorKey,
                    onRefresh: _handleRefresh,
                    showChildOpacityTransition: true,
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Visibility(
                              visible: visibleQuizPage,
                              child: Container(
                                // height: 100,
                                // width: 150,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: currentOrientation ==
                                              Orientation.portrait
                                          ? 100
                                          : 0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.white70,
                                        ),
                                        SizedBox(width: 16.0),
                                        Container(
                                          child: Expanded(
                                            child: Text(
                                              HtmlUnescape().convert(widget
                                                  .questions[_currentIndex]
                                                  .question),
                                              softWrap: true,
                                              style: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      800
                                                  ? _questionStyle.copyWith(
                                                      fontSize: 15.0)
                                                  : _questionStyle,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? 340
                                              : 260,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? null
                                              : 60,
                                          child: Card(
                                            child: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  // edit pick just most or least only
                                                  child: RadioListTile(
                                                    title: Text(
                                                      HtmlUnescape().convert(
                                                          "${options[0]}"),
                                                      style:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  800
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      15.0)
                                                              : null,
                                                    ),
                                                    groupValue:
                                                        _answers[_currentIndex],
                                                    value: isDoneChoiceMost1 ==
                                                            true
                                                        ? options[0]
                                                        : '',
                                                    onChanged: canchoice != 0 &&
                                                            isChoice1 == false
                                                        ? (value) {
                                                            setState(() {
                                                              _answers[
                                                                      _currentIndex] =
                                                                  options[0];
                                                              canchoice--;
                                                              //
                                                              isChoice1 = true;
                                                              isChoice2 = false;
                                                              isChoice3 = false;
                                                              isChoice4 = false;
                                                              //
                                                              isMost = false;
                                                              isDoneChoiceMost1 =
                                                                  true;
                                                              // arrAnswersD[0] =
                                                              //     '${widget.questions[_currentIndex].question} : ${options[0]}';
                                                              isDoneChoiceMost2 =
                                                                  false;
                                                              isDoneChoiceMost3 =
                                                                  false;
                                                              isDoneChoiceMost4 =
                                                                  false;
                                                            });
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  // edit pick just most or least only
                                                  child: RadioListTile(
                                                    title: Text(
                                                      HtmlUnescape().convert(
                                                          "${options[1]}"),
                                                      style:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  800
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      15.0)
                                                              : null,
                                                    ),
                                                    groupValue:
                                                        _answers[_currentIndex],
                                                    value: isDoneChoiceLeast1 ==
                                                            true
                                                        ? options[1]
                                                        : '',
                                                    onChanged: canchoice != 0 &&
                                                            isChoice1 == false
                                                        ? (value) {
                                                            setState(() {
                                                              _answers[
                                                                      _currentIndex] =
                                                                  options[1];
                                                              // canchoice--;
                                                              //
                                                              isChoice1 = true;
                                                              isChoice2 = false;
                                                              isChoice3 = false;
                                                              isChoice4 = false;
                                                              //
                                                              isLeast = false;
                                                              isDoneChoiceLeast1 =
                                                                  true;
                                                              // arrAnswersD[1] =
                                                              //     '${widget.questions[_currentIndex].question} : ${options[1]}';
                                                              isDoneChoiceLeast2 =
                                                                  false;
                                                              isDoneChoiceLeast3 =
                                                                  false;
                                                              isDoneChoiceLeast4 =
                                                                  false;
                                                            });
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.white70,
                                        ),
                                        SizedBox(width: 16.0),
                                        Container(
                                          child: Expanded(
                                            child: Text(
                                              HtmlUnescape().convert(widget
                                                  .questions[_currentIndex + 1]
                                                  .question),
                                              softWrap: true,
                                              style: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      800
                                                  ? _questionStyle.copyWith(
                                                      fontSize: 15.0)
                                                  : _questionStyle,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? 340
                                              : 260,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? null
                                              : 60,
                                          child: Card(
                                            child: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  // edit pick just most or least only
                                                  child: RadioListTile(
                                                    title: Text(
                                                      HtmlUnescape().convert(
                                                          "${options[0]}"),
                                                      style:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  800
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      15.0)
                                                              : null,
                                                    ),
                                                    groupValue: _answers[
                                                        _currentIndex + 1],
                                                    value: isDoneChoiceMost2 ==
                                                            true
                                                        ? options[0]
                                                        : '',
                                                    onChanged: canchoice != 0 &&
                                                            isChoice2 == false
                                                        ? (value) {
                                                            setState(() {
                                                              _answers[
                                                                  _currentIndex +
                                                                      1] = options[
                                                                  0];
                                                              // canchoice--;
                                                              //
                                                              isChoice1 = false;
                                                              isChoice2 = true;
                                                              isChoice3 = false;
                                                              isChoice4 = false;
                                                              //
                                                              isMost = false;
                                                              isDoneChoiceMost1 =
                                                                  false;
                                                              isDoneChoiceMost2 =
                                                                  true;
                                                              // arrAnswersD[0] =
                                                              //     '${widget.questions[_currentIndex].question} : ${options[0]}';
                                                              isDoneChoiceMost3 =
                                                                  false;
                                                              isDoneChoiceMost4 =
                                                                  false;
                                                            });
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  // edit pick just most or least only
                                                  child: RadioListTile(
                                                    title: Text(
                                                      HtmlUnescape().convert(
                                                          "${options[1]}"),
                                                      style:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  800
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      15.0)
                                                              : null,
                                                    ),
                                                    groupValue: _answers[
                                                        _currentIndex + 1],
                                                    value: isDoneChoiceLeast2 ==
                                                            true
                                                        ? options[1]
                                                        : '',
                                                    onChanged: canchoice != 0 &&
                                                            isChoice2 == false
                                                        ? (value) {
                                                            setState(() {
                                                              _answers[
                                                                  _currentIndex +
                                                                      1] = options[
                                                                  1];
                                                              //
                                                              isChoice1 = false;
                                                              isChoice2 = true;
                                                              isChoice3 = false;
                                                              isChoice4 = false;
                                                              //
                                                              // canchoice--;
                                                              isLeast = false;
                                                              isChoice2 = true;
                                                              isMost = false;
                                                              isDoneChoiceLeast1 =
                                                                  false;
                                                              isDoneChoiceLeast2 =
                                                                  true;
                                                              // arrAnswersD[0] =
                                                              //     '${widget.questions[_currentIndex].question} : ${options[1]}';
                                                              isDoneChoiceLeast3 =
                                                                  false;
                                                              isDoneChoiceLeast4 =
                                                                  false;
                                                            });
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.white70,
                                          // child: Text("${_currentIndex + 1}"),
                                        ),
                                        SizedBox(width: 16.0),
                                        Container(
                                          child: Expanded(
                                            child: Text(
                                              HtmlUnescape().convert(widget
                                                  .questions[_currentIndex + 2]
                                                  .question),
                                              softWrap: true,
                                              style: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      800
                                                  ? _questionStyle.copyWith(
                                                      fontSize: 15.0)
                                                  : _questionStyle,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? 340
                                              : 260,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? null
                                              : 60,
                                          child: Card(
                                            child: Row(
                                              // mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  // edit pick just most or least only
                                                  child: RadioListTile(
                                                    title: Text(
                                                      HtmlUnescape().convert(
                                                          "${options[0]}"),
                                                      style:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  800
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      15.0)
                                                              : null,
                                                    ),
                                                    groupValue: _answers[
                                                        _currentIndex + 2],
                                                    value: isDoneChoiceMost3 ==
                                                            true
                                                        ? options[0]
                                                        : '',
                                                    onChanged: canchoice != 0 &&
                                                            isChoice3 == false
                                                        ? (value) {
                                                            setState(() {
                                                              _answers[
                                                                  _currentIndex +
                                                                      2] = options[
                                                                  0];
                                                              //
                                                              isChoice1 = false;
                                                              isChoice2 = false;
                                                              isChoice3 = true;
                                                              isChoice4 = false;
                                                              //
                                                              // canchoice--;
                                                              isMost = false;
                                                              isDoneChoiceMost1 =
                                                                  false;
                                                              isDoneChoiceMost2 =
                                                                  false;
                                                              isDoneChoiceMost3 =
                                                                  true;
                                                              // arrAnswersD[0] =
                                                              //     '${widget.questions[_currentIndex].question} : ${options[0]}';
                                                              isDoneChoiceMost4 =
                                                                  false;
                                                            });
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  // edit pick just most or least only
                                                  child: RadioListTile(
                                                    title: Text(
                                                      HtmlUnescape().convert(
                                                          "${options[1]}"),
                                                      style:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  800
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      15.0)
                                                              : null,
                                                    ),
                                                    groupValue: _answers[
                                                        _currentIndex + 2],
                                                    value: isDoneChoiceLeast3 ==
                                                            true
                                                        ? options[1]
                                                        : '',
                                                    onChanged: canchoice != 0 &&
                                                            isChoice3 == false
                                                        ? (value) {
                                                            setState(() {
                                                              _answers[
                                                                  _currentIndex +
                                                                      2] = options[
                                                                  1];
                                                              // canchoice--;
                                                              //
                                                              isChoice1 = false;
                                                              isChoice2 = false;
                                                              isChoice3 = true;
                                                              isChoice4 = false;
                                                              //
                                                              isLeast = false;
                                                              isDoneChoiceLeast1 =
                                                                  false;
                                                              isDoneChoiceLeast2 =
                                                                  false;
                                                              isDoneChoiceLeast3 =
                                                                  true;
                                                              // arrAnswersD[0] =
                                                              //     '${widget.questions[_currentIndex].question} : ${options[1]}';
                                                              isDoneChoiceLeast4 =
                                                                  false;
                                                            });
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.white70,
                                        ),
                                        SizedBox(width: 16.0),
                                        Container(
                                          child: Expanded(
                                            child: Text(
                                              HtmlUnescape().convert(widget
                                                  .questions[_currentIndex + 3]
                                                  .question),
                                              softWrap: true,
                                              style: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      800
                                                  ? _questionStyle.copyWith(
                                                      fontSize: 15.0)
                                                  : _questionStyle,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? 340
                                              : 260,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? null
                                              : 60,
                                          child: Card(
                                            child: Row(
                                              // mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  // edit pick just most or least only
                                                  child: RadioListTile(
                                                    title: Text(
                                                      HtmlUnescape().convert(
                                                          "${options[0]}"),
                                                      style:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  800
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      15.0)
                                                              : null,
                                                    ),
                                                    groupValue: _answers[
                                                        _currentIndex + 3],
                                                    value: isDoneChoiceMost4 ==
                                                            true
                                                        ? options[0]
                                                        : '',
                                                    onChanged: canchoice != 0 &&
                                                            isChoice4 == false
                                                        ? (value) {
                                                            setState(() {
                                                              _answers[
                                                                  _currentIndex +
                                                                      3] = options[
                                                                  0];
                                                              // canchoice--;
                                                              //
                                                              isChoice1 = false;
                                                              isChoice2 = false;
                                                              isChoice3 = false;
                                                              isChoice4 = true;
                                                              //
                                                              isChoice4 = true;
                                                              isMost = false;
                                                              isDoneChoiceMost1 =
                                                                  false;
                                                              isDoneChoiceMost2 =
                                                                  false;
                                                              isDoneChoiceMost3 =
                                                                  false;
                                                              isDoneChoiceMost4 =
                                                                  true;
                                                              // arrAnswersD[0] =
                                                              //     '${widget.questions[_currentIndex].question} : ${options[0]}';
                                                            });
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  // edit pick just most or least only
                                                  child: RadioListTile(
                                                    title: Text(
                                                      HtmlUnescape().convert(
                                                          "${options[1]}"),
                                                      style:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  800
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      15.0)
                                                              : null,
                                                    ),
                                                    groupValue: _answers[
                                                        _currentIndex + 3],
                                                    value: isDoneChoiceLeast4 ==
                                                            true
                                                        ? options[1]
                                                        : '',
                                                    onChanged: canchoice != 0 &&
                                                            isChoice4 == false
                                                        ? (value) {
                                                            setState(() {
                                                              _answers[
                                                                  _currentIndex +
                                                                      3] = options[
                                                                  1];
                                                              // canchoice--;
                                                              //
                                                              isChoice1 = false;
                                                              isChoice2 = false;
                                                              isChoice3 = false;
                                                              isChoice4 = true;
                                                              //
                                                              isLeast = false;
                                                              //
                                                              isDoneChoiceLeast1 =
                                                                  false;
                                                              isDoneChoiceLeast2 =
                                                                  false;
                                                              isDoneChoiceLeast3 =
                                                                  false;
                                                              isDoneChoiceLeast4 =
                                                                  true;
                                                              // arrAnswersD[0] =
                                                              // '${widget.questions[_currentIndex].question} : ${options[1]}';
                                                            });
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Expanded(
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              side: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                            color: Colors.blue,
                                            onPressed: () {
                                              isDisablePrev == true
                                                  ? null
                                                  : setState(() {
                                                      visibleQuizPage = true;
                                                      visibleResultPage = false;
                                                      isPrevFromResult = true;
                                                      // _currentIndex++;
                                                    });
                                              _previous();
                                            },
                                            child: const Text(
                                              'Previous',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          RaisedButton(
                                            padding: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    800
                                                ? const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0)
                                                : null,
                                            child: Text(
                                              _currentIndex ==
                                                      (widget.questions.length -
                                                          1)
                                                  ? "Save"
                                                  : "Next",
                                              style: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      800
                                                  ? TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white,
                                                    )
                                                  : TextStyle(
                                                      color: Colors.white,
                                                    ),
                                            ),
                                            onPressed: () {
                                              if (_currentIndex ==
                                                  (widget.questions.length -
                                                      1)) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        InstructionQuiz(
                                                      // bio params
                                                      name: name,
                                                      noHp: noHp,
                                                      gender: gender,
                                                      email: email,
                                                      tanggalLahir:
                                                          tanggalLahir,
                                                      pendidikan: pendidikan,
                                                      foto: foto,
                                                      //

                                                      soal: userVersionQuiz ==
                                                              'version_1'
                                                          ? soal
                                                          : userVersionQuiz ==
                                                                  'version_2'
                                                              ? soal + 1
                                                              : soal,
                                                      score1st: score1st == null
                                                          ? score1
                                                          : score1st,
                                                      score2nd: score2nd == null
                                                          ? score2
                                                          : score2nd,
                                                      // answersdTemp:
                                                      //     answersdTemp ==
                                                      //             null
                                                      //         ? answersD
                                                      //         : answersdTemp,
                                                      // user: user,
                                                      durationTest:
                                                          durationQuiz,
                                                      username: username,
                                                    ),
                                                  ),
                                                );
                                                setState(() {
                                                  soal = soal + 1;
                                                });
                                                print(
                                                    'save soal pada soal ...');
                                                _saveData();
                                              } else {
                                                _nextSubmit();
                                              }
                                            },
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: visibleResultPage,
                              child: Container(
                                // Result Page
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 150,
                                    right: 15,
                                    left: 15,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            top: 15.0,
                                            bottom: 15.0,
                                          ),
                                          // width: cWidth,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(30.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          (soal == 2) ||
                                                                  (soal == 3) ||
                                                                  (soal == 4)
                                                              ? stillOnQuiz
                                                              : finalQuiz,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 60,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        RaisedButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          color: Colors.blue,
                                                          onPressed: () {
                                                            setState(() {
                                                              visibleQuizPage =
                                                                  true;
                                                              visibleResultPage =
                                                                  false;
                                                            });
                                                          },
                                                          child: const Text(
                                                            'Previous',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        RaisedButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          color: Colors.blue,
                                                          onPressed: () {
                                                            // soal == 5
                                                            print(
                                                                'Finished Test');
                                                            if (userVersionQuiz ==
                                                                    'version_1'
                                                                ? soal == 4
                                                                : userVersionQuiz ==
                                                                        'version_2'
                                                                    ? soal == 3
                                                                    : userVersionQuiz ==
                                                                            'version_3'
                                                                        ? soal ==
                                                                            3
                                                                        : soal ==
                                                                            4) {
                                                              // add user data to google sheet
                                                              _submitData();
                                                              // _saveDataScore();
                                                              // add data user to firestore
                                                              _addDataUser();
                                                              //
                                                              // add user session to firestore
                                                              _addSession();
                                                              //
                                                              // is done quiz data
                                                              _isDoneQuiz();
                                                              //
                                                              // await _clear();
                                                              //
                                                              //
                                                            } else {
                                                              //
                                                              // _updateData();
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      InstructionQuiz(
                                                                    // bio params
                                                                    name: name,
                                                                    noHp: noHp,
                                                                    gender:
                                                                        gender,
                                                                    email:
                                                                        email,
                                                                    tanggalLahir:
                                                                        tanggalLahir,
                                                                    pendidikan:
                                                                        pendidikan,
                                                                    foto: foto,
                                                                    //

                                                                    soal: userVersionQuiz ==
                                                                            'version_1'
                                                                        ? soal
                                                                        : userVersionQuiz ==
                                                                                'version_2'
                                                                            ? soal +
                                                                                1
                                                                            : soal,
                                                                    score1st: score1st ==
                                                                            null
                                                                        ? score1
                                                                        : score1st,
                                                                    score2nd: score2nd ==
                                                                            null
                                                                        ? score2
                                                                        : score2nd,
                                                                    answersdTemp: answersdTemp ==
                                                                            null
                                                                        ? answersD_fix_key
                                                                        : answersdTemp,
                                                                    // user: user,
                                                                    durationTest:
                                                                        durationQuiz,
                                                                    username:
                                                                        username,
                                                                  ),
                                                                ),
                                                              );
                                                              setState(() {
                                                                soal = soal + 1;
                                                              });
                                                              print(
                                                                  'save soal pada soal ...');
                                                              _saveData();
                                                            }
                                                          },
                                                          child: Text(
                                                            soal == 4
                                                                ? 'Log Out'
                                                                : 'Save',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
      ),
    );
  }

  void _choice() {
    //
    Question question = questions[_currentIndex];
    print('question.correctAnswer : ${question.correctAnswer}');
    //
    if (_answers[_currentIndex] != question.correctAnswer &&
        isDoneChoice == true) {
      //
      print('jawaban salah');

      setState(() {
        correctAnswer = correctAnswer - 0;
        isCorrect = false;
        isIncorrect = true;
      });
    }

    if (_answers[_currentIndex] == question.correctAnswer &&
        isDoneChoice == true) {
      //
      print('jawaban salah');

      setState(() {
        correctAnswer = correctAnswer + 1;
        isCorrect = true;
        isIncorrect = false;
      });
    }
    //
    print('correct answer : $correctAnswer');
    if (soal == 1) {
      setState(() {
        score1st = correctAnswer;
      });
    } else if (soal == 2) {
      setState(() {
        score2nd = correctAnswer;
      });
    }
  }

  void _nextSubmit() {
    //
    setState(() {
      isPrev = false;
      multipleOptions = [''];
    });

    if (soal == 1 || soal == 2) {
      if (_currentIndex < (widget.questions.length - 1)) {
        //
        setState(() {
          _currentIndex = _currentIndex + 1;
          numberSoalD++;
          shortAnswerController.text = "";
        });
      } else if (_currentIndex == (widget.questions.length - 1)) {
        //
        setState(() {
          numberSoalD++;
          visibleResultPage = true;
          visibleQuizPage = false;
          //
        });
      }
    }
    if (soal == 3) {
      if ((_answers[_currentIndex] == null &&
              _answers[_currentIndex + 1] == null &&
              _answers[_currentIndex + 2] == null &&
              _answers[_currentIndex + 3] == null) ||
          (_answers[_currentIndex] == null &&
              _answers[_currentIndex + 1] == null &&
              _answers[_currentIndex + 2] == null &&
              _answers[_currentIndex + 3] != null) ||
          (_answers[_currentIndex] == null &&
              _answers[_currentIndex + 1] == null &&
              _answers[_currentIndex + 2] != null &&
              _answers[_currentIndex + 3] == null) ||
          (_answers[_currentIndex] == null &&
              _answers[_currentIndex + 1] != null &&
              _answers[_currentIndex + 2] == null &&
              _answers[_currentIndex + 3] == null) ||
          (_answers[_currentIndex] != null &&
              _answers[_currentIndex + 1] == null &&
              _answers[_currentIndex + 2] == null &&
              _answers[_currentIndex + 3] == null)) {
        // ignore: deprecated_member_use
        _key.currentState.showSnackBar(SnackBar(
          content: Text("Anda harus memilih jawaban untuk melanjutkan"),
        ));
        return;
      }
      if (_currentIndex < (widget.questions.length - 4)) {
        setState(() {
          _currentIndex = _currentIndex + 4;

          indexd = _currentIndex;
          numberSoalD++;
          canchoice = 2;
          //
          isMost = true;
          isLeast = true;
          isChoice1 = false;
          isChoice2 = false;
          isChoice3 = false;
          isChoice4 = false;
        });
        // save answers d value
        _saveAnswersD();
      } else if (_currentIndex == (widget.questions.length - 4)) {
        // print('condition if ke 2 answers d');
        // print('indexd: $indexd');
        setState(() {
          indexd = _currentIndex + 4;
          numberSoalD++;
          canchoice = 2;
          //
          isMost = true;
          isLeast = true;
          isChoice1 = false;
          isChoice2 = false;
          isChoice3 = false;
          isChoice4 = false;
          //
          visibleQuizPage = false;
          visibleResultPage = true;
        });
        _saveAnswersD();
      }
    }
    //
    if (soal == 4) {
      if (_answers[_currentIndex] == null) {
        _key.currentState.showSnackBar(SnackBar(
          content: Text("Anda harus memilih jawaban untuk melanjutkan"),
        ));
        return;
      } else if (_currentIndex < (widget.questions.length - 1)) {
        //
        setState(() {
          _currentIndex = _currentIndex + 1;
          numberSoalD++;
        });
        //
        _saveAnswersB();
        //
      } else if (_currentIndex == (widget.questions.length - 1)) {
        //
        setState(() {
          numberSoalD++;
          visibleResultPage = true;
          visibleQuizPage = false;
          //
          durationQuizTemp = durationQuiz + durationQuizTemp;
          durationTest = (durationTest == null ? 0 : durationTest) +
              durationQuizTemp; // save value duration quiz
        });
        _saveAnswersB();
      }
    }
  }

  // setState answers d
  _saveAnswersD() {
    setState(() {
      if (_answers[indexd - 4] == 'Most') {
        arrAnswersD[0] =
            (indexd % 4 + 1).toString() + ' : ' + _answers[indexd - 4];
        //
        numberAnswerD_key[0] = indexd % 4 + 1;
        arrAnswersD_key[0] = 'Most';
      }
      if (_answers[indexd - 4] == 'Least') {
        arrAnswersD[1] =
            (indexd % 4 + 1).toString() + ' : ' + _answers[indexd - 4];
        //
        numberAnswerD_key[1] = indexd % 4 + 1;
        arrAnswersD_key[1] = 'Least';
      }

      if (_answers[indexd - 3] == 'Most') {
        arrAnswersD[0] =
            (indexd % 4 + 2).toString() + ' : ' + _answers[indexd - 3];
        //
        numberAnswerD_key[0] = indexd % 4 + 2;
        arrAnswersD_key[0] = 'Most';
      }
      if (_answers[indexd - 3] == 'Least') {
        arrAnswersD[1] =
            (indexd % 4 + 2).toString() + ' : ' + _answers[indexd - 3];
        //
        numberAnswerD_key[1] = indexd % 4 + 2;
        arrAnswersD_key[1] = 'Least';
      }

      if (_answers[indexd - 2] == 'Most') {
        arrAnswersD[0] =
            (indexd % 4 + 3).toString() + ' : ' + _answers[indexd - 2];
        //
        numberAnswerD_key[0] = indexd % 4 + 3;
        arrAnswersD_key[0] = 'Most';
      }
      if (_answers[indexd - 2] == 'Least') {
        arrAnswersD[1] =
            (indexd % 4 + 3).toString() + ' : ' + _answers[indexd - 2];
        //
        numberAnswerD_key[1] = indexd % 4 + 3;
        arrAnswersD_key[1] = 'Least';
      }

      if (_answers[indexd - 1] == 'Most') {
        arrAnswersD[0] =
            (indexd % 4 + 4).toString() + ' : ' + _answers[indexd - 1];
        //
        numberAnswerD_key[0] = indexd % 4 + 4;
        arrAnswersD_key[0] = 'Most';
      }
      if (_answers[indexd - 1] == 'Least') {
        arrAnswersD[1] =
            (indexd % 4 + 4).toString() + ' : ' + _answers[indexd - 1];
        //
        numberAnswerD_key[1] = indexd % 4 + 4;
        arrAnswersD_key[1] = 'Least';
      }
      //
      //
      answersD_key[numberSoalD - 1] = [
        arrAnswersD_key[0].toString(),
        arrAnswersD_key[1].toString()
      ];
      //
      // check log jawaban d, Most dan Least setiap index soal jawaban pada 1 nomor test
      print('numberAnswerD_key[0] : ${numberAnswerD_key[0]}');
      print('numberAnswerD_key[1] : ${numberAnswerD_key[1]}');
      //
      //
      print('numberSoalD: $numberSoalD');
      // key pada soal D no 1
      if (numberSoalD == 1) {
        print('numberSoalD == 1');
        if (answersD_key[0][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[0][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[0][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[0][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[0][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[0][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[0][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[0][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'C';
        }

        answersD_fix_key[0] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      //
      // key pada soal D no 2
      if (numberSoalD == 2) {
        if (answersD_key[1][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[1][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[1][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[1][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        //
        if (answersD_key[1][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[1][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[1][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[1][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'S';
        }

        answersD_fix_key[1] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      //
      // key pada soal D no 3
      if (numberSoalD == 3) {
        if (answersD_key[2][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[2][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        //
        if (answersD_key[2][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[2][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[2][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[2][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[2][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[2][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'Z';
        }

        answersD_fix_key[2] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      //
      // key pada soal D no 4
      //
      if (numberSoalD == 4) {
        if (answersD_key[3][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[3][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[3][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[3][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[3][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[3][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[3][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[3][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        answersD_fix_key[3] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      //
      //
      // key pada soal D no 5
      if (numberSoalD == 5) {
        if (answersD_key[4][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[4][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        //
        if (answersD_key[4][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[4][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[4][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[4][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[4][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[4][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        answersD_fix_key[4] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 6
      // //
      if (numberSoalD == 6) {
        if (answersD_key[5][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[5][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[5][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[5][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[5][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[5][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[5][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[5][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        answersD_fix_key[5] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 7
      // //
      if (numberSoalD == 7) {
        if (answersD_key[6][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[6][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[6][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[6][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        //
        if (answersD_key[6][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[6][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[6][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[6][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        answersD_fix_key[6] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 8
      // //
      if (numberSoalD == 8) {
        if (answersD_key[7][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[7][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[7][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[7][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[7][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[7][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[7][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[7][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        answersD_fix_key[7] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 9
      // //
      if (numberSoalD == 9) {
        if (answersD_key[8][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[8][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[8][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[8][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[8][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[8][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[8][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[8][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        answersD_fix_key[8] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 10
      // //
      if (numberSoalD == 10) {
        if (answersD_key[9][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[9][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        //
        if (answersD_key[9][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[9][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[9][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[9][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[9][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[9][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        answersD_fix_key[9] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 11
      // //
      if (numberSoalD == 11) {
        if (answersD_key[10][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[10][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[10][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[10][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[10][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[10][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[10][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[10][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        answersD_fix_key[10] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 12
      // //
      if (numberSoalD == 12) {
        if (answersD_key[11][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[11][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[11][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[11][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[11][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[11][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[11][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[11][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        answersD_fix_key[11] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 13
      if (numberSoalD == 13) {
        if (answersD_key[12][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[12][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[12][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[12][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[12][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[12][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[12][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[12][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        answersD_fix_key[12] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 14
      // //
      if (numberSoalD == 14) {
        if (answersD_key[13][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[13][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[13][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[13][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[13][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[13][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[13][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[13][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        answersD_fix_key[13] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 15
      // //
      if (numberSoalD == 15) {
        if (answersD_key[14][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[14][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[14][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[14][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[14][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[14][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[14][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[14][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        answersD_fix_key[14] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 16
      // //
      if (numberSoalD == 16) {
        if (answersD_key[15][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[15][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[15][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[15][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[15][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[15][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[15][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[15][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        answersD_fix_key[15] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 17
      // //
      if (numberSoalD == 17) {
        if (answersD_key[16][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[16][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        //
        if (answersD_key[16][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[16][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[16][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[16][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[16][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[16][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        answersD_fix_key[16] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 18
      // //
      if (numberSoalD == 18) {
        if (answersD_key[17][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[17][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[17][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[17][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[17][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[17][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[17][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[17][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        answersD_fix_key[17] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 19
      // //
      if (numberSoalD == 19) {
        if (answersD_key[18][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[18][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[18][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[18][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[18][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[18][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        //
        if (answersD_key[18][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[18][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        answersD_fix_key[18] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 20
      if (numberSoalD == 20) {
        if (answersD_key[19][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[19][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[19][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[19][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[19][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[19][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[19][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[19][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        answersD_fix_key[19] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 21
      // //
      if (numberSoalD == 21) {
        if (answersD_key[20][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[20][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[20][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[20][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[20][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[20][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[20][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[20][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        answersD_fix_key[20] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      //
      // key pada soal D no 22
      if (numberSoalD == 22) {
        if (answersD_key[21][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[21][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[21][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[21][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[21][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[21][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'C';
        }
        //
        if (answersD_key[21][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[21][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        answersD_fix_key[21] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // key pada soal D no 23
      if (numberSoalD == 23) {
        if (answersD_key[22][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[22][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'D';
        }
        //
        if (answersD_key[22][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'C';
        }
        if (answersD_key[22][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[22][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[22][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[22][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[22][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        answersD_fix_key[22] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      // //
      // // key pada soal D no 24
      if (numberSoalD == 24) {
        if (answersD_key[23][0] == 'Most' && numberAnswerD_key[0] == 1) {
          print('Key Most = S'); //
          arrAnswersD_key_fix[0] = 'Z';
        }
        if (answersD_key[23][1] == 'Least' && numberAnswerD_key[1] == 1) {
          print('Key Least = S'); //
          arrAnswersD_key_fix[1] = 'S';
        }
        //
        if (answersD_key[23][0] == 'Most' && numberAnswerD_key[0] == 2) {
          print('Key Most = I'); //
          arrAnswersD_key_fix[0] = 'I';
        }
        if (answersD_key[23][1] == 'Least' && numberAnswerD_key[1] == 2) {
          print('Key Least = I'); //
          arrAnswersD_key_fix[1] = 'I';
        }
        //
        if (answersD_key[23][0] == 'Most' && numberAnswerD_key[0] == 3) {
          print('Key Most = Z'); //
          arrAnswersD_key_fix[0] = 'D';
        }
        if (answersD_key[23][1] == 'Least' && numberAnswerD_key[1] == 3) {
          print('Key Least = D'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        //
        if (answersD_key[23][0] == 'Most' && numberAnswerD_key[0] == 4) {
          print('Key Most = C'); //
          arrAnswersD_key_fix[0] = 'S';
        }
        if (answersD_key[23][1] == 'Least' && numberAnswerD_key[1] == 4) {
          print('Key Least = C'); //
          arrAnswersD_key_fix[1] = 'Z';
        }
        answersD_fix_key[23] = [
          arrAnswersD_key_fix[0].toString(),
          arrAnswersD_key_fix[1].toString()
        ];
        //
      }
      //
      print('answersD_fix_key : $answersD_fix_key');
      //
      // ...
      // setState answersD
      answersD[numberSoalD - 1] = [
        arrAnswersD[0].toString(),
        arrAnswersD[1].toString()
      ];
      //
      answerDTemp[numberSoalD - 1] = arrAnswersD;
      // answersD[numberSoalD - 1][0]
      // answersD[numberSoalD - 1][1]
      //
      // print log jawaban soal D
      // print(
      //     'answersD[${numberSoalD}][0] : ${answersD[numberSoalD - 1][0]}'); // print log jawaban soal D jawaban pertama, choose 1 most
      // print(
      //     'answersD[${numberSoalD}][1] : ${answersD[numberSoalD - 1][1]}'); // print log jawaban soal D jawaban kedua, choose 2 least
    });
  }

  // setstate answers b
  _saveAnswersB() {
    setState(() {
      index = _currentIndex;
      answersB = numberSoalD.toString() + ' : ' + _answers[numberSoalD - 1];
      // Fix answes test B with number
      arrAnswersB[numberSoalD - 1] =
          _answers[numberSoalD - 1] == 'Sangat Tidak Sesuai'
              ? '1'
              : _answers[numberSoalD - 1] == 'Tidak Sesuai'
                  ? '2'
                  : _answers[numberSoalD - 1] == 'Netral'
                      ? '3'
                      : _answers[numberSoalD - 1] == 'Sesuai'
                          ? '4'
                          : '5';
    });
  }

  void _previous() {
    //
    setState(() {
      isPrev = true;
    });
    //
    Question question = questions[_currentIndex];
    //
    if ((_answers[_currentIndex] == question.correctAnswer) &&
        isPrev == true &&
        _currentIndex > 1) {
      //
      setState(() {
        correctAnswer--;
      });
    }

    setState(() {
      isMost = true;
      isLeast = true;
      isChoice1 = false;
      isChoice2 = false;
      isChoice3 = false;
      isChoice4 = false;
    });

    if (soal == 3) {
      if (_currentIndex <= (widget.questions.length - 4) &&
          (_currentIndex != 0)) {
        setState(() {
          _currentIndex = _currentIndex - 4;
          numberSoalD--;
          canchoice = 2;
        });
      }
    } else {
      if (_currentIndex <= (widget.questions.length - 1) &&
          _currentIndex != 0 &&
          isPrevFromResult == false) {
        setState(() {
          _currentIndex = _currentIndex - 1;
          numberSoalD--;
          // fix bugs jika kembali kesoal essay yang sebelumnya, maka jawaban tidak hilang
          shortAnswerController.text = _answers[_currentIndex];
        });
      } else if (_currentIndex <= (widget.questions.length - 1) &&
          (_currentIndex != 0) &&
          (isPrevFromResult == true)) {
        setState(() {
          _currentIndex = _currentIndex - 0;
          isPrevFromResult = false;
          // numberSoalD--;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(
              "Are you sure you want to quit the quiz? All your progress will be lost."),
          title: Text("Warning!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
