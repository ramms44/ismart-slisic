import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_psychotest/pages/biodata/inputBiodata.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/services/auth.dart';
import 'package:flutter_web_psychotest/pages/dashboard/main/dashboardMain.dart';
import 'package:flutter_web_psychotest/pages/dashboard/services/userIdServices.dart';

class HomeScreen extends StatefulWidget {
  //
  HomeScreen({
    Key key,
    @required this.user,
    this.username,
  }) : super(key: key);
  var user;
  final username;
  @override
  _HomeScreenState createState() => _HomeScreenState(
        user,
        username,
      );
}

class _HomeScreenState extends State<HomeScreen> {
  var user;
  final username;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AuthBase authBase = AuthBase();

  @override
  void initState() {
    super.initState();
    //
    isUpdate == true
        ? _usersname = usernameController.text
        : _usersname = _usersname;
    isUpdate == true
        ? _password = passwordController.text
        : _password = _password;
  }

  gotoDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardPage(
          user: user,
          username: username,
        ),
      ),
    );
  }

  String _usersname;
  String _password;

  _HomeScreenState(
    this.user,
    this.username,
  );

  bool isTap = false;
  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    print('user username pada homescreen : ${user.username}');
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          height: screenHeight * 0.6,
          width: screenWidth * 0.4,
          // child: Container(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isTap = !isTap;
              });
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      isTap == false
                          ? 'Tap to Update User'
                          : 'Tap to View User',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    // padding: EdgeInsets.all(10.0),
                    width: screenWidth * 0.3,
                    child: isTap == true
                        ? TextFormField(
                            controller: usernameController,
                            validator: (value) {
                              if (value.trim().length <= 9) {
                                return 'Masukkan Username';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            decoration: CommonStyle.textFieldStyle(
                              labelTextStr: "Username",
                              hintTextStr: "Enter Username",
                            ),
                          )
                        : Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Username :',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  isUpdate == true ? _usersname : user.username,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: isTap == true ? true : false,
                    child: Container(
                        // padding: EdgeInsets.all(10.0),
                        width: screenWidth * 0.3,
                        child:
                            // user.username == 'superadmin'
                            //     ?
                            TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value.trim().length <= 9) {
                              return 'Masukkan Email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: CommonStyle.textFieldStyle(
                              labelTextStr: "Email",
                              hintTextStr: "Enter Email"),
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    // padding: EdgeInsets.all(10.0),
                    width: screenWidth * 0.3,
                    child: isTap == true
                        ? TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value.trim().length <= 9) {
                                return 'Masukkan Password';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: CommonStyle.textFieldStyle(
                                labelTextStr: "Password",
                                hintTextStr: "Enter Password"),
                          )
                        : Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Password :',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  isUpdate == true ? _password : user.password,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Visibility(
                    visible: isTap == true ? true : false,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: BorderSide(color: Colors.green),
                      ),
                      color: Colors.green,
                      onPressed: () async {
                        // update user
                        postRequest(
                          usernameController.text,
                          emailController.text,
                          passwordController.text,
                          user.objectId,
                          user.sessionToken,
                        );
                        isUpdate = true;
                        setState(() {
                          _usersname = usernameController.text;
                          _password = passwordController.text;
                        });
                      },
                      child: const Text(
                        'Update User',
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
                    visible: isTap == true ? true : false,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: BorderSide(color: Colors.red),
                      ),
                      color: Colors.red,
                      onPressed: () async {
                        // update user
                        deleteRequest(
                          user.objectId,
                          user.sessionToken,
                        );
                      },
                      child: const Text(
                        'Delete User',
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
          // ),
        ),
      ),
    );
  }
}
