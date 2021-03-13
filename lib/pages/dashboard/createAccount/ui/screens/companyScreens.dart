import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_psychotest/pages/biodata/inputBiodata.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/services/auth.dart';
import 'package:flutter_web_psychotest/pages/dashboard/main/dashboardMain.dart';
import 'package:flutter_web_psychotest/styles/string.dart';

class CompanyScreen extends StatefulWidget {
  //
  CompanyScreen({
    Key key,
    this.user,
    this.username,
  }) : super(key: key);
  var user;
  final username;
  @override
  _CompanyScreenState createState() => _CompanyScreenState(
        user,
        username,
      );
}

class _CompanyScreenState extends State<CompanyScreen> {
  var user;
  final username;
  String companyName1st;
  String companyName2nd;

  final companyName1stController = TextEditingController();
  final companyName2ndController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AuthBase authBase = AuthBase();

  _CompanyScreenState(
    this.user,
    this.username,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    getDataCompany();
  }

  getDataCompany() async {
    // ignore: deprecated_member_use
    DocumentSnapshot company = await Firestore.instance
        .collection('company')
        .doc('company_name')
        .get();

    setState(() {
      companyName1st = company['name'];
    });
    print('name = $companyName1st');
    //
    DocumentSnapshot company2 = await Firestore.instance
        .collection('company')
        .doc('company_name_2')
        .get();

    setState(() {
      companyName2nd = company2['name'];
    });
  }

  createCompany1st() async {
    // create name company
    await Firestore.instance
        .collection('company')
        .document('company_name')
        .updateData({
      'name': companyName1stController.text,
    });
    setState(() {
      companyName1st = companyName1stController.text;
    });
  }

  createCompany2nd() async {
    // create name company
    await Firestore.instance
        .collection('company')
        .document('company_name_2')
        .updateData({
      'name': companyName2ndController.text,
    });
    setState(() {
      companyName2nd = companyName2ndController.text;
    });
  }

  updateCompany1st() async {
    // update company
    await Firestore.instance
        .collection('company')
        .document('company_name')
        .updateData({
      'name': companyName1stController.text,
    });
    setState(() {
      companyName1st = companyName1stController.text;
    });
  }

  updateCompany2nd() async {
    // update company
    await Firestore.instance
        .collection('company')
        .document('company_name_2')
        .updateData({
      'name': companyName2ndController.text,
    });
    setState(() {
      companyName2nd = companyName2ndController.text;
    });
  }

  bool isTap1st = false;
  bool isTap2nd = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    // print('user object id pada CompanyScreen update : ${user.objectId}');
    print('username: $username');
    // print('user password: ${user.password}');
    // print('user username: ${user.username}');
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          // height: screenHeight * 0.6,
          // width: screenWidth * 0.4,
          // child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //
                      setState(() {
                        isTap1st = !isTap1st;
                      });
                    },
                    child: Card(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 30,
                          bottom: 30,
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                tapToUpdate,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            isTap1st == true
                                ? Container(
                                    // padding: EdgeInsets.all(10.0),
                                    width: screenWidth * 0.3,
                                    child: username == 'superadmin'
                                        ? TextFormField(
                                            controller:
                                                companyName1stController,
                                            validator: (value) {
                                              if (value.trim().length <= 9) {
                                                return inputCompanyA;
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.name,
                                            decoration:
                                                CommonStyle.textFieldStyle(
                                              labelTextStr: companyNameA,
                                              hintTextStr: enterCompanyName,
                                            ),
                                          )
                                        : SizedBox(),
                                  )
                                : Container(
                                    // padding: EdgeInsets.all(10.0),
                                    width: screenWidth * 0.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          companyNameA,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Text(
                                          companyName1st == null
                                              ? 'Loading'
                                              : companyName1st,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            Visibility(
                              visible:
                                  username == 'superadmin' && isTap1st == true
                                      ? true
                                      : false,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(color: Colors.blue),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  // update company
                                  updateCompany1st();
                                },
                                child: Text(
                                  updateCompany,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Visibility(
                              visible: username == 'superadmin' ? true : false,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(color: Colors.green),
                                ),
                                color: Colors.green,
                                onPressed: () {
                                  // create company name
                                  createCompany1st();
                                },
                                child: Text(
                                  createCompanyName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      //
                      setState(() {
                        isTap2nd = !isTap2nd;
                      });
                    },
                    child: Card(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 30,
                          bottom: 30,
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                tapToUpdate,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            isTap2nd == true
                                ? Container(
                                    // padding: EdgeInsets.all(10.0),
                                    width: screenWidth * 0.3,
                                    child: username == 'superadmin'
                                        ? TextFormField(
                                            controller:
                                                companyName2ndController,
                                            validator: (value) {
                                              if (value.trim().length <= 9) {
                                                return inputCompanyB;
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.name,
                                            decoration:
                                                CommonStyle.textFieldStyle(
                                              labelTextStr: companyNameB,
                                              hintTextStr: enterCompanyName,
                                            ),
                                          )
                                        : SizedBox(),
                                  )
                                : Container(
                                    // padding: EdgeInsets.all(10.0),
                                    width: screenWidth * 0.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          companyNameB,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Text(
                                          companyName2nd == null
                                              ? 'Loading'
                                              : companyName2nd,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            Visibility(
                              visible:
                                  username == 'superadmin' && isTap2nd == true
                                      ? true
                                      : false,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(color: Colors.blue),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  // update company 2
                                  updateCompany2nd();
                                },
                                child: Text(
                                  updateCompany,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Visibility(
                              visible: username == 'superadmin' ? true : false,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(color: Colors.purple),
                                ),
                                color: Colors.purple,
                                onPressed: () {
                                  // create name company 2
                                  createCompany2nd();
                                },
                                child: Text(
                                  createCompanyName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Colors.blue),
                ),
                color: Colors.blue,
                onPressed: () async {
                  // await authBase.logout();
                  // Navigator.of(context).pushReplacementNamed('login');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DashboardPage(
                        user: user,
                        username: username,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
