// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:web_psytest/pages/dashboard/google_sheet/controller/form_controller.dart';
// import 'package:web_psytest/pages/dashboard/google_sheet/model/form.dart';
// import 'package:web_psytest/pages/home/home_page.dart';
// import 'package:web_psytest/pages/quiz_pages/models/category.dart';
// import 'package:web_psytest/pages/quiz_pages/models/question.dart';
// import 'package:web_psytest/pages/quiz_pages/pages/instruction.dart';
// import 'package:web_psytest/resources/api_provider.dart';
// import 'package:web_psytest/services/auth_services.dart';
// import 'package:web_psytest/services/crud.dart';
// import 'package:web_psytest/widgets/bottom_navbar.dart';
// import 'package:web_psytest/widgets/my_appbar.dart';
// import 'error.dart';
// import 'quiz_page.dart';

// // date time
// DateTime now = DateTime.now();
// // time format
// var formattedDate = DateFormat('EEE, dd MM yyy – kk:mm:ss').format(now);
// // // clear tags symbol with regex
// // final myString = 'abc=';
// // final withoutEquals = myString.replaceAll(RegExp('{}'), ''); // abc

// class Resultpage extends StatefulWidget {
//   // answer & question parameters
//   final List<Question> questions;
//   final Map<int, dynamic> answers;

//   final Category category;
//   //
//   final int marks;
//   final int soal;
//   final Image foto;
//   var list_marks;

//   Resultpage({
//     // parameters
//     Key key,
//     @required this.soal,
//     @required this.marks,
//     @required this.foto,
//     this.list_marks,
//     this.category,
//     this.questions,
//     this.answers,
//   }) : super(key: key);
//   @override
//   _ResultpageState createState() => _ResultpageState(
//         soal,
//         marks,
//         foto,
//         list_marks,
//         questions,
//         answers,
//       );
// }

// class _ResultpageState extends State<Resultpage> {
//   //
//   int _noOfQuestions;
//   String _difficulty;
//   bool processing;

//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   String message;
//   // score test w & n variables
//   int score1;
//   int score2;
//   // answer test d & b variables
//   String answer_d;
//   String answer_b;

//   // biodata var
//   String nama;
//   String noHp;
//   String gender;
//   String email;
//   String tanggal_lahir;
//   String pendidikan;

//   // is prev boolean
//   bool isPrevious;

//   final List<Question> questions;
//   final Map<int, dynamic> answers;

//   @override
//   void initState() {
//     //
//     _noOfQuestions = 10;
//     _difficulty = "easy";
//     processing = false;

//     _getDataBiodata();
//     if (soal == 2) {
//       score1 = marks;
//       print('score 1');
//     } else if (soal == 3) {
//       score2 = marks;
//       print('score 2');
//     } else {
//       // _getDataScoreDB();
//       _updateData();
//       _getDataScore();
//     }

//     super.initState();
//   }

// _updateData() async {
//   // ignore: deprecated_member_use
//   await Firestore.instance
//       .collection('score_pertest')
//       // ignore: deprecated_member_use
//       .document('save_score_pertest')
//       // ignore: deprecated_member_use
//       .updateData((soal == 2)
//           ? {'score1': score1}
//           : (soal == 3)
//               ? {'score2': score2}
//               : null);
// }

// _getDataScore() async {
//   // ignore: deprecated_member_use
//   DocumentSnapshot score = await Firestore.instance
//       .collection('score_pertest')
//       .doc('save_score_pertest')
//       .get();

//   setState(() {
//     //
//     score1 = score['score1'];
//     score2 = score['score2'];
//     answer_d = score['AnswerTestD'];
//     answer_b = score['AnswerTestB'];
//   });
// }

//   _getDataScoreDB() async {
//     // ignore: deprecated_member_use
//     DocumentSnapshot answersD_B = await Firestore.instance
//         .collection('score_pertest')
//         .doc('save_score_pertest')
//         .get();
//   }

// _getDataBiodata() async {
//   // ignore: deprecated_member_use
//   DocumentSnapshot biodata = await Firestore.instance
//       .collection('biodata')
//       .doc('biodata_temp')
//       .get();

//   setState(() {
//     nama = biodata['name'];
//     email = biodata['email_address'];
//     gender = biodata['gender'];
//     noHp = biodata['number_phone'];
//     pendidikan = biodata['pendidikan'];
//     tanggal_lahir = biodata['tanggal_lahir'];
//   });
//   print('name = ${nama}');
// }

// // Method to Submit Feedback and save it in Google Sheets
//   void _submitData() {
//     // Validate returns true if the form is valid, or false
//     // otherwise.
//     FeedbackForm feedbackForm = FeedbackForm(
//       nama,
//       email,
//       noHp,
//       gender,
//       pendidikan,
//       tanggal_lahir,
//       score1.toString(),
//       score2.toString(),
//       answer_d.replaceAll(RegExp(r"[^\s\w]"), ''),
//       answer_b.replaceAll(RegExp(r"[^\s\w]"), ''),
//     );

//     FormController formController = FormController();

//     _showSnackbar("Submitting Feedback");

//     // Submit 'feedbackForm' and save it in Google Sheets.
//     formController.submitForm(
//       feedbackForm,
//       (String response) {
//         print("Response: $response");
//         if (response == FormController.STATUS_SUCCESS) {
//           print('success');
//           // Feedback is saved succesfully in Google Sheets.
//           _showSnackbar("Feedback Submitted");
//         } else {
//           // Error Occurred while saving data in Google Sheets.
//           _showSnackbar("Error Occurred!");
//           print('error');
//         }
//       },
//     );
//   }

//   // Method to show snackbar with 'message'.
//   _showSnackbar(String message) {
//     final snackBar = SnackBar(content: Text(message));
//     // ignore: deprecated_member_use
//     _scaffoldKey.currentState.showSnackBar(snackBar);
//   }

//   final int marks;
//   int soal;
//   final Image foto;
//   // final bool isPrevious;
//   var list_marks;

//   _ResultpageState(
//     this.soal,
//     this.marks,
//     this.foto,
//     this.list_marks,
//     this.questions,
//     this.answers,
//     // this.isPrevious,
//   );

//   @override
//   Widget build(BuildContext context) {
//     print("soal : $soal");
//     print("marks on result : $marks");
//     // declaration variables with values
//     final String finalQuiz =
//         "Anda sudah mengerjakan semua soal \nTekan tombol Home Page untuk menyimpan score anda dan kembali ke home page, \ndan tombol Previous di bawah kembali ke halaman quiz sebelumnya";
//     final String stillOnQuiz =
//         "Klik tombol Submit untuk menyimpan jawaban, \ndan pindah ke Tes berikutnya, \n\nAnda tidak bisa mengganti jawaban setelah klik Submit, \nperiksa kembali jawaban jika masih ada waktu.";
//     final String success = 'Successfully Save Score';

//     CrudMethods crudobj = CrudMethods();
//     double cWidth = MediaQuery.of(context).size.width * 0.8;
//     //
//     return Scaffold(
//       appBar: MyAppBar(),
//       bottomNavigationBar: BottomNavnBar(),
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.only(
//                 top: 15.0,
//                 bottom: 15.0,
//               ),
//               width: cWidth,
//               child: Center(
//                 child: StreamBuilder<Object>(
//                   stream: null,
//                   builder: (context, snapshot) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 (soal == 2) || (soal == 3) || (soal == 4)
//                                     ? stillOnQuiz
//                                     : finalQuiz,
//                                 style: TextStyle(fontSize: 16),
//                                 textAlign: TextAlign.start,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 60,
//                         ),
//                         Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               RaisedButton(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(6.0),
//                                   side: BorderSide(color: Colors.blue),
//                                 ),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   setState(() {
//                                     soal = soal - 1;
//                                   });
//                                   _prevQuiz();
//                                 },
//                                 child: const Text(
//                                   'Previous',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 15,
//                               ),
//                               SizedBox(
//                                 width: 15,
//                               ),
//                               RaisedButton(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(6.0),
//                                   side: BorderSide(color: Colors.blue),
//                                 ),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   // soal == 5
//                                   if (soal == 5) {
//                                     _submitData();
//                                     crudobj.addData({
//                                       'name': nama,
//                                       'number_phone': noHp,
//                                       'gender': gender,
//                                       'email_address': email,
//                                       'tanggal_lahir': tanggal_lahir,
//                                       'pendidikan': pendidikan,
//                                       'create_date': now,
//                                       'score_test_w': score1.toString(),
//                                       'score_test_n': score2.toString(),
//                                       'answer_test_d': answer_d.replaceAll(
//                                           RegExp(r"[^\s\w]"), ''),
//                                       'answer_test_b': answer_b.replaceAll(
//                                           RegExp(r"[^\s\w]"), ''),
//                                     });
//                                     AuthService().signOut();
//                                   } else {
//                                     //
//                                     _updateData();
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InstructionQuiz(
//                                           // quistion param
//                                           // questions: questions,
//                                           // category: widget.category,
//                                           // bio params
//                                           name: nama,
//                                           noHp: noHp,
//                                           foto: foto,
//                                           soal: soal,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: Text(
//                                   soal == 5 ? 'Log Out' : 'Submit',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _prevQuiz() async {
//     setState(() {
//       processing = true;
//     });

//     try {
//       List<Question> questions = (soal == 1)
//           ? await getQuestionsW(
//               widget.category,
//               _noOfQuestions,
//               _difficulty,
//             )
//           : (soal == 2)
//               ? await getQuestionsN(
//                   widget.category,
//                   _noOfQuestions,
//                   _difficulty,
//                 )
//               : (soal == 3)
//                   ? await getQuestionsD(
//                       widget.category,
//                       _noOfQuestions,
//                       _difficulty,
//                     )
//                   : await getQuestionsB(
//                       widget.category,
//                       _noOfQuestions,
//                       _difficulty,
//                     );
//       Navigator.pop(context);
//       if (questions.length < 1) {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => ErrorPage(
//               message:
//                   "There are not enough questions in the category, with the options you selected.",
//             ),
//           ),
//         );
//         return;
//       }
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => QuizPage(
//             // quistion param
//             questions: questions,
//             category: widget.category,
//             isPrevQuiz: true,
//             // bio params
//             name: nama,
//             noHp: noHp,
//             foto: foto,
//             soal: soal,
//             //
//             marks: marks,
//           ),
//         ),
//       );
//     } on SocketException catch (_) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ErrorPage(
//             message:
//                 "Can't reach the servers, \n Please check your internet connection.",
//           ),
//         ),
//       );
//     } catch (e) {
//       print(e.message);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ErrorPage(
//             message: "Unexpected error trying to connect to the API",
//           ),
//         ),
//       );
//     }
//     setState(() {
//       processing = false;
//     });
//   }
// }
