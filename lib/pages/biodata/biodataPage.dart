import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_web_psychotest/pages/quiz/models/category.dart';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';
import 'package:flutter_web_psychotest/pages/quiz/pages/instruction.dart';
import 'package:flutter_web_psychotest/services/crud.dart';
import 'package:flutter_web_psychotest/widgets/bottomNavbar.dart';
import 'package:flutter_web_psychotest/widgets/functions.dart';
import 'package:flutter_web_psychotest/widgets/myAppbar.dart';
import 'package:flutter_web_psychotest/widgets/textField.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class BiodataPage extends StatefulWidget {
  BiodataPage({
    Key key,
    this.category,
    this.email,
    this.user,
    this.loginSession,
    this.username,
    this.versionQuiz,
  }) : super(key: key);

  final Category category;
  final String email;
  String versionQuiz;
  var user;
  var loginSession;
  var username;

  @override
  _BiodataPageState createState() => _BiodataPageState(
        email,
        user,
        loginSession,
        username,
        versionQuiz,
      );
}

// ignore: non_constant_identifier_names
String description =
    "Isilah dengan data diri Anda dan ijinkan aplikasi ini  menggunakan camera untuk mengambil foto Anda saat ini. Klik 'ALLOW' jika muncul notifikasi di layar Anda. Lepas masker dan topi Anda saat akan memotret lalu klik tombol AMBIL FOTO. Tekan tombol NEXT jika sudah melengkapi data diri Anda.";

class _BiodataPageState extends State<BiodataPage> {
  //

  var user;
  var loginSession;
  var username;
  String versionQuiz;
  // Webcam widget to insert into the tree
  Widget _webcamWidget;
  // VideoElement
  VideoElement _webcamVideoElement;
  //
  bool isTablet;
  bool isPhone;
  //
  var _image;

  int _noOfQuestions;
  String _difficulty;
  bool processing;

  bool isPrefInstruction;
  bool isSave = false;

  _saveData() async {
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
    //
    setState(() {
      isSave = true;
    });
  }

  final String email;
  //
  // File imageFiles;
  Image image;
  //
  final int startSoal = 1;

  _addValueBiodata() async {
    // setstate method
    setState(() {
      name = nameController.text;
      gender = dropdownGenderValue;
      emails = emailController.text;
      noHp = hpController.text;
      tanggalLahir = ageController.text;
      pendidikan = dropdownSchoolValue;
      foto = image;
    });
  }

  // user input controller var

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final _formKey = GlobalKey<FormState>();
  String dropdownGenderValue = 'Pria';
  String dropdownSchoolValue = 'SMA';
  final listOfGender = ["Pria", "Wanita"];
  final listOfSchool = ["SMA", "Kuliah S1"];
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final schoolController = TextEditingController();

  String birthDateInString;
  DateTime birthDate;

  // user data
  String name = '';
  String noHp = '';
  String gender = '';
  String emails = '';
  String tanggalLahir = '';
  String pendidikan = '';
  Image foto;

  @override
  void initState() {
    print('username pada biodata page : ${username}');
    userVersionQuiz(username);
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  FToast fToast;

  // user version with userid
  userVersionQuiz(username) async {
    // userid for version questions apps
    // username = ekaa1000, jika username[3] atau char ke 4 pada string username == 'a', maka app test versi 1
    if (username[3] == 'a') {
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

  //
  _BiodataPageState(
    this.email,
    this.user,
    this.loginSession,
    this.username,
    this.versionQuiz,
  );

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MyAppbarBio(),
      bottomNavigationBar: BottomNavnBar(),
      body: Builder(
        builder: (context) => Container(
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
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
                      description,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        // width: screenWidth * 0.8,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      margin: EdgeInsets.only(
                                        right: screenWidth * 0.04,
                                      ),
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
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: image == null
                                          ? Icon(Icons.person, size: 100)
                                          : Image(
                                              image: image.image,
                                              width: 100,
                                              height: 100,
                                            ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: screenHeight * 0.34,
                                        right: screenWidth * 0.04,
                                        top: screenHeight * 0.02,
                                      ),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          side: BorderSide(color: Colors.blue),
                                        ),
                                        color: Colors.blue,
                                        onPressed: () async {
                                          // if pc/tablet devices and ishpone devices detecting
                                          isTablet == true
                                              ? _webcamVideoElement
                                                      .srcObject.active
                                                  ? _webcamVideoElement.play()
                                                  : _webcamVideoElement.pause()
                                              : _image =
                                                  await FlutterWebImagePicker
                                                      .getImage;
                                          setState(() {
                                            image = _image;
                                          });
                                        },
                                        child: const Text(
                                          'AMBIL FOTO',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // width: screenWidth * 0.3,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Form(
                                      key: _formKey,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: screenWidth * 0.38,
                                              // padding: EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                controller: nameController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Enter Valid Name';
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration:
                                                    CommonStyle.textFieldStyle(
                                                        labelTextStr: "Nama",
                                                        hintTextStr:
                                                            "Enter Name"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(10.0),
                                              width: screenWidth * 0.38,
                                              child: TextFormField(
                                                controller: emailController,
                                                validator: (value) {
                                                  if (!value.contains("@")) {
                                                    return 'Enter Valid Email';
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration:
                                                    CommonStyle.textFieldStyle(
                                                        labelTextStr:
                                                            "Email Address",
                                                        hintTextStr:
                                                            "Enter Email Address"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(10.0),
                                              width: screenWidth * 0.38,
                                              child: TextFormField(
                                                controller: hpController,
                                                validator: (value) {
                                                  if (value.trim().length <=
                                                      9) {
                                                    return 'Masukkan 10 digit no hp kamu';
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    CommonStyle.textFieldStyle(
                                                        labelTextStr:
                                                            "Phone Number",
                                                        hintTextStr:
                                                            "Enter Phone Number"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(10.0),
                                              width: screenWidth * 0.4,
                                              child: BeautyTextfield(
                                                // width: screenWidth * 0.3,
                                                width: 200,
                                                controller: ageController,
                                                height: 60,
                                                prefixIcon:
                                                    Icon(Icons.date_range),
                                                placeholder: "Tanggal Lahir",
                                                inputType: TextInputType.number,
                                                onTap: () async {
                                                  final datePick =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        new DateTime.now(),
                                                    firstDate:
                                                        new DateTime(1900),
                                                    lastDate:
                                                        new DateTime(2100),
                                                  );
                                                  if (datePick != null &&
                                                      datePick != birthDate) {
                                                    setState(() {
                                                      birthDate = datePick;
                                                      // isDateSelected = true;

                                                      // age format exam. // 08/14/2019
                                                      ageController.text =
                                                          "${birthDate.month}/${birthDate.day}/${birthDate.year}";
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(10.0),
                                              width: screenWidth * 0.38,
                                              height: screenHeight * 0.07,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: GFDropdown(
                                                  elevation: 6,
                                                  hint: Text(
                                                      "Pilih Jenis Kelamin"),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      width: 1.3),
                                                  dropdownButtonColor:
                                                      Colors.white,
                                                  value: dropdownGenderValue,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      dropdownGenderValue =
                                                          newValue;
                                                    });
                                                  },
                                                  items: [
                                                    'Pria',
                                                    'Wanita',
                                                  ]
                                                      .map((value) =>
                                                          DropdownMenuItem(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(10.0),
                                              width: screenWidth * 0.38,
                                              height: screenHeight * 0.07,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: GFDropdown(
                                                  hint:
                                                      Text("Pilih Pendidikan"),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      width: 1.3),
                                                  dropdownButtonColor:
                                                      Colors.white,
                                                  value: dropdownSchoolValue,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      dropdownSchoolValue =
                                                          newValue;
                                                    });
                                                  },
                                                  items: [
                                                    'SMP',
                                                    'SMA',
                                                    'Diploma',
                                                    'S1',
                                                    'S2',
                                                    'S3',
                                                  ]
                                                      .map((value) =>
                                                          DropdownMenuItem(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                ),
                                              ),
                                            ),
                                          ],
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
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(color: Colors.blue),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  final FormState form = _formKey.currentState;
                                  if (_formKey.currentState.validate()) {
                                    print('Form is valid');
                                    //
                                    // add value biodata
                                    _addValueBiodata();
                                    _saveData();
                                    //
                                    // update biodata to firestore
                                    // _updateBiodata();
                                    // ignore: deprecated_member_use
                                    FunctionsClass().showToast(
                                      'Biodata berhasil disimpan', // message parameter
                                      Colors.white, // textColor parameter
                                      Colors.green, // color parameter
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ), // icon parameter
                                      Colors.green
                                          .withOpacity(0.2), // shadow color
                                      fToast, // ftoast parameter
                                    );
                                  } else {
                                    print('Form is invalid');
                                    // ignore: deprecated_member_use
                                    FunctionsClass().showToast(
                                      'Isi biodata dengan benar', // message parameter
                                      Colors.white, // textColor parameter
                                      Colors.orangeAccent, // color parameter
                                      Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.white,
                                      ), // icon parameter
                                      Colors.orangeAccent
                                          .withOpacity(0.2), // shadow color
                                      fToast, // ftoast parameter
                                    );
                                  }
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(1.0),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(color: Colors.blue),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  final FormState form = _formKey.currentState;
                                  if (_formKey.currentState.validate() &&
                                      isSave == true) {
                                    _saveData();
                                    setState(() {
                                      isPrefInstruction = true;
                                    });
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => InstructionQuiz(
                                        name: name,
                                        noHp: noHp,
                                        gender: gender,
                                        email: emails,
                                        tanggalLahir: tanggalLahir,
                                        pendidikan: pendidikan,
                                        foto: foto,
                                        soal: versionQuiz == 'version_1'
                                            ? 1
                                            : versionQuiz == 'version_2'
                                                ? 1
                                                : 3,
                                        // user: user,
                                        loginSession: loginSession,
                                        username: username,
                                        userVersionQuiz: versionQuiz,
                                      ),
                                    ));
                                  } else {
                                    print('Form is invalid');
                                    // ignore: deprecated_member_use
                                    FunctionsClass().showToast(
                                      'Isi biodata dengan benar, lalu submit', // message parameter
                                      Colors.white, // textColor parameter
                                      Colors.orangeAccent, // color parameter
                                      Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.white,
                                      ), // icon parameter
                                      Colors.orangeAccent
                                          .withOpacity(0.2), // shadow color
                                      fToast, // ftoast parameter
                                    );
                                  }
                                  //
                                },
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(
                                      1.0,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ageController.dispose();
    nameController.dispose();
  }
}

class CommonStyle {
  static InputDecoration textFieldStyle(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(12),
      labelText: labelTextStr,
      hintText: hintTextStr,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white30, width: 0.0),
      ),
    );
  }
}
