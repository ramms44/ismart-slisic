import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionsClass {
  /// create [showSnackBar] function with params
  showSnackBar(BuildContext context, String textContent) {
    final snackbar = SnackBar(content: Text(textContent));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    return snackbar;
  }

  /// create [savePrefLogin]
  savePrefLogin(String userid, bool isLogedin) async {
    // share preference pref
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', userid);
    pref.setBool('isLogedin', isLogedin);
    print('check print saveDataLogin userid : $userid');
  }

  /// create [savePrefHome]
  savePrefHome(String username, bool isPrefBiodata) async {
    // share preference pref
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', username);
    pref.setBool('isPrefBiodata', isPrefBiodata);
    print('save data home');
  }

  /// create [savePrefBiodata]
  savePrefBiodata(
    String username,
    bool isPrefInstruction,
    String name,
    String noHp,
    String gender,
    String emails,
    String tanggalLahir,
    String pendidikan,
  ) async {
    // share preference pref
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', username);
    pref.setBool('isPrefInstruction', isPrefInstruction);
    pref.setString('nameBiodata', name);
    pref.setString('noHp', noHp);
    pref.setString('gender', gender);
    pref.setString('emails', emails);
    pref.setString('tanggalLahir', tanggalLahir);
    pref.setString('pendidikan', pendidikan);
  }

  /// create [savePrefQuiz]
  savePrefQuiz(
    int soal,
    int score1st,
    int score1,
    int score2nd,
    int score2,
    answersdTemp,
    answersD,
  ) async {
    // share preference pref
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('soal', soal);
    pref.setInt('score1st', score1st == null ? score1 : score1st);
    pref.setInt('score2nd', score2nd == null ? score2 : score2nd);
    pref.setStringList(
        'answerd', answersdTemp == null ? answersD : answersdTemp);
    //
    print('save pref quiz');
  }

  /// create [clearPref]
  clearPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    preferences.remove('isLogedin');
  }

  // format hours, minute, seconds
  String formatHHMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (seconds / 3600).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr menit $secondsStr detik";
    }
    return "$hoursStr:$minutesStr:$secondsStr";
  }
}
