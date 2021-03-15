import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_web_psychotest/pages/quiz/models/category.dart';
import 'package:flutter_web_psychotest/pages/quiz/pages/instruction.dart';
import 'package:flutter_web_psychotest/services/crud.dart';
import 'package:flutter_web_psychotest/widgets/textField.dart';
import 'dart:io';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class InputBiodata extends StatefulWidget {
  final Category category;
  final String email;
  var user;
  var loginSession;
  var username;

  InputBiodata({
    Key key,
    this.category,
    this.email,
    this.user,
    this.loginSession,
    this.username,
  }) : super(key: key);

  @override
  _InputBiodataState createState() => _InputBiodataState(
        email,
        user,
        loginSession,
        username,
      );
}

class _InputBiodataState extends State<InputBiodata> {
  var user;
  var loginSession;
  var username;
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

  _InputBiodataState(
    this.email,
    this.user,
    this.loginSession,
    this.username,
  );

  @override
  void initState() {
    //

    // getValidationData().whenComplete(() async {
    //   // print('username initstate getvalidation whencomplete : $username');
    //   print('username pada biodata page: $username');
    //   setState(() {
    //     username = username;
    //   });
    // });
    print('username $username');

    // Get data biodata with shared preference
    getValidationData().whenComplete(() async {
      //
      print('name : $name');
      print('email : $emails');
      print('gender : $gender');
      print('noHp : $noHp');
      print('levelEducation : $pendidikan');
      print('birthDate : $tanggalLahir');
      print('get data biodata complete');
      setState(() {
        username = username;
      });
      //
    });
    //
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;

    // Create a video element which will be provided with stream source
    _webcamVideoElement = VideoElement();
    // Register an webcam
    // ui.platformViewRegistry.registerViewFactory(
    //     'webcamVideoElement', (int viewId) => _webcamVideoElement);
    // Create video widget
    _webcamWidget =
        HtmlElementView(key: UniqueKey(), viewType: 'webcamVideoElement');
    // Access the webcam stream
    window.navigator.getUserMedia(video: true).then((MediaStream stream) {
      _webcamVideoElement.srcObject = stream;
    });

    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
    } else {
      isTablet = false;
      isPhone = true;
    }
    print('devices tablet : $isTablet');
    print('devices phone : $isPhone');
  }

  Future getValidationData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    var obtainUsername = pref.getString('username');
    setState(() {
      username = obtainUsername;
    });
    print('username getValidationData : $username');
    // biodata param
    var obtainName = pref.getString('nameBiodata');
    var obtainPhoneNumber = pref.getString('noHp');
    var obtainGender = pref.getString('gender');
    var obtainEmail = pref.getString('emails');
    var obtainBirthDate = pref.getString('tanggalLahir');
    var obtainSchool = pref.getString('pendidikan');
    //
    setState(() {
      //
      name = obtainName;
      emails = obtainEmail;
      gender = obtainGender;
      noHp = obtainPhoneNumber;
      pendidikan = obtainSchool;
      tanggalLahir = obtainBirthDate;
      //
    });
  }

  bool isPrefInstruction;

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
  }

  final String email;
  //
  // File imageFiles;
  Image image;
  //
  final int startSoal = 1;
  //
  bool isSubmit = false;

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
  Widget build(BuildContext context) {
    // screen percentage width & height with MediaQuery
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
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
                              borderRadius: BorderRadius.circular(6.0),
                              side: BorderSide(color: Colors.blue),
                            ),
                            color: Colors.blue,
                            onPressed: () async {
                              // if pc/tablet devices and ishpone devices detecting
                              isTablet == true
                                  ? _webcamVideoElement.srcObject.active
                                      ? _webcamVideoElement.play()
                                      : _webcamVideoElement.pause()
                                  : _image =
                                      await FlutterWebImagePicker.getImage;
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
                                    keyboardType: TextInputType.name,
                                    decoration: CommonStyle.textFieldStyle(
                                        labelTextStr: "Nama",
                                        hintTextStr: "Enter Name"),
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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: CommonStyle.textFieldStyle(
                                        labelTextStr: "Email Address",
                                        hintTextStr: "Enter Email Address"),
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
                                      if (value.trim().length <= 9) {
                                        return 'Masukkan 10 digit no hp kamu';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: CommonStyle.textFieldStyle(
                                        labelTextStr: "Phone Number",
                                        hintTextStr: "Enter Phone Number"),
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
                                    prefixIcon: Icon(Icons.date_range),
                                    placeholder: "Tanggal Lahir",
                                    inputType: TextInputType.number,
                                    onTap: () async {
                                      final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: new DateTime.now(),
                                        firstDate: new DateTime(1900),
                                        lastDate: new DateTime(2100),
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
                                  child: DropdownButtonHideUnderline(
                                    child: GFDropdown(
                                      elevation: 6,
                                      hint: Text("Pilih Jenis Kelamin"),
                                      padding: const EdgeInsets.all(15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: BorderSide(
                                          color: Colors.grey.withOpacity(0.8),
                                          width: 1.3),
                                      dropdownButtonColor: Colors.white,
                                      value: dropdownGenderValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          dropdownGenderValue = newValue;
                                        });
                                      },
                                      items: [
                                        'Pria',
                                        'Wanita',
                                      ]
                                          .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
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
                                  child: DropdownButtonHideUnderline(
                                    child: GFDropdown(
                                      hint: Text("Pilih Pendidikan"),
                                      padding: const EdgeInsets.all(15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: BorderSide(
                                          color: Colors.grey.withOpacity(0.8),
                                          width: 1.3),
                                      dropdownButtonColor: Colors.white,
                                      value: dropdownSchoolValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          dropdownSchoolValue = newValue;
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
                                          .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
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
                        setState(() {
                          isSubmit = true;
                        });
                        //
                        // update biodata to firestore
                        // _updateBiodata();
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Biodata berhasil disimpan'),
                        ));
                      } else {
                        print('Form is invalid');
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Isi biodata dengan benar'),
                        ));
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
                          isSubmit == true) {
                        setState(() {
                          isPrefInstruction = true;
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => InstructionQuiz(
                            name: name,
                            noHp: noHp,
                            gender: gender,
                            email: emails,
                            tanggalLahir: tanggalLahir,
                            pendidikan: pendidikan,
                            foto: foto,
                            soal: 1,
                            // user: user,
                            loginSession: loginSession,
                            username: username,
                          ),
                        ));
                      } else {
                        print('Form is invalid');
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Isi biodata dengan benar'),
                        ));
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
