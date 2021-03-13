import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_psychotest/pages/dashboard/main/dashboardMain.dart';
import 'package:flutter_web_psychotest/pages/dashboard/services/userIdServices.dart';

class CreateAccountBulk extends StatefulWidget {
  const CreateAccountBulk({
    Key key,
    this.username,
  }) : super(key: key);

  @override
  _CreateAccountBulkState createState() => _CreateAccountBulkState(
        username,
      );

  final username;
}

class _CreateAccountBulkState extends State<CreateAccountBulk> {
  final username;
  // int _jumlahUserId = 0;
  final _formKey = GlobalKey<FormState>();
  final _jumlahUserId = TextEditingController();
  final _companyString = TextEditingController();
  int totalUser;
  String companyString;

  _CreateAccountBulkState(this.username);

  _bulkUser() async {
    String _jlhUser = _jumlahUserId.text;
    companyString = _companyString.text;
    totalUser = int.parse(_jlhUser);
    // create user
    for (int i = 0; i <= totalUser; i++) {
      // looping methods post sign up
      print(companyString);
      // createAccount(
      //   '${companyString}${i + 1000}',
      //   '${companyString}${i + 1000}',
      //   '${companyString}${i + 1000}@mail.com',
      // );
      addUserID({
        'username': '${companyString}${i + 1000}',
        // 'objectid': user.objectId,
        'email': '${companyString}${i + 1000}',
        'password': '${companyString}${i + 1000}',
        'usertype': username == 'superadmin' ? 'admin' : 'usertest',
      });
    }
  }

  // add user id
  Future<void> addUserID(userIdData) async {
    // ignore: deprecated_member_use
    Firestore.instance.collection('userid').add(userIdData);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Material(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Create Bulk UserId',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              // child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: screenWidth * 0.38,
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _jumlahUserId,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Userid Value';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: CommonStyle.textFieldStyle(
                          labelTextStr: "Masukkan Jumlah Userid",
                          hintTextStr: "Enter Value"),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: screenWidth * 0.38,
                    child: TextFormField(
                      controller: _companyString,
                      keyboardType: TextInputType.name,
                      decoration: CommonStyle.textFieldStyle(
                          labelTextStr: "Company String",
                          hintTextStr: "Enter Company String"),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    color: Colors.green,
                    onPressed: () async {
                      // create bulk user
                      _bulkUser();
                    },
                    child: const Text(
                      'Create Bulk User',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                    color: Colors.blue,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DashboardPage(
                            // user: user,
                            username: 'superadmin',
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
            // ),
          ],
        ),
      ),
    );
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
