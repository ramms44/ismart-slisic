import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_web_psychotest/pages/dashboard/charts/chartsDataPage.dart';
import 'package:flutter_web_psychotest/pages/dashboard/userSession/userSession.dart';
import 'package:flutter_web_psychotest/pages/dashboard/createAccount/createAccount.dart';
import 'package:flutter_web_psychotest/pages/dashboard/emailSender/emailSender.dart';
import 'package:flutter_web_psychotest/pages/dashboard/userEntries/userEntries.dart';
import 'package:flutter_web_psychotest/pages/dashboard/userList/userList.dart';
import 'package:flutter_web_psychotest/pages/login/loginPage.dart';
import 'package:flutter_web_psychotest/styles/string.dart';
import 'package:url_launcher/url_launcher.dart';

// date time
DateTime now = DateTime.now();

// ignore: must_be_immutable
class DashboardPage extends StatefulWidget {
  DashboardPage({
    Key key,
    @required this.user,
    @required this.username,
    this.loginSession,
  }) : super(key: key);
  var user;
  var username;
  var loginSession;
  @override
  _DashboardPageState createState() => _DashboardPageState(
        user,
        username,
        loginSession,
      );
}

class _DashboardPageState extends State<DashboardPage> {
  var user;
  var username;
  var loginSession;
  String userCompany;
  //
  final List<List<double>> charts = [
    // data score dummy, later with real data scoring user from firestore
    [70, 60, 100, 50, 30, 40],
    [80, 50, 60, 70, 50, 80],
    [40, 60, 80, 40, 60, 70]
  ];
  //

  static final List<String> chartDropdownItems = [
    'Last 1 days',
    'Last 7 days',
    'Last a month'
  ];
  //
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  int userLength = 0;
  // ignore: non_constant_identifier_names
  int total_user = 0;
  // ignore: non_constant_identifier_names
  int total_score = 0;

  Future totalUser() async {
    // ignore: deprecated_member_use
    var respectsQuery = Firestore.instance.collection('users');
    // ignore: deprecated_member_use
    var querySnapshot = await respectsQuery.getDocuments();
    // ignore: deprecated_member_use
    var totalUsers = querySnapshot.documents.length;
    // print("user : ${user.className}");
    setState(() {
      // total user length - 2 (2 data is biodata_temp & save_score, not user data)
      total_user = totalUsers;
    });
    return totalUsers;
  }

  //
  _DashboardPageState(
    this.user,
    this.username,
    this.loginSession,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); //
    if (user != null) {
      if (username.contains(new RegExp(r'admin1', caseSensitive: false))) {
        // print('user from companyA');
        setState(() {
          userCompany = 'user1';
        });
      }
      if (username.contains(new RegExp(r'admin2', caseSensitive: false))) {
        // print('user from companyB');
        setState(() {
          userCompany = 'user2';
        });
      }
      if (username.contains(new RegExp(r'admin3', caseSensitive: false))) {
        // print('user from companyB');
        setState(() {
          userCompany = 'user3';
        });
      }
      if (username.contains(new RegExp(r'admin4', caseSensitive: false))) {
        // print('user from companyB');
        setState(() {
          userCompany = 'user4';
        });
      }
      if (username.contains(new RegExp(r'admin5', caseSensitive: false))) {
        // print('user from companyB');
        setState(() {
          userCompany = 'user5';
        });
      }
    } else {
      null;
    }
    totalUser();
  }

  // sign out
  signOut() async {
    /* Your code */
    // AuthService().signOut();
    Firestore.instance.collection('session').add({
      'logout_time': now,
      'login_time': loginSession,
      'username': username,
    });
    // var user = _parseUser;
    // var response = await user.logout();

    // print(user.objectId);
    // if (response.success) {
    // _parseUser = null;
    print("LOGOFF SUCCESS");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(
            // email: username,
            ),
      ),
    );
    // } else {
    //   print("log off");
    // }
  }

  _launchURL() async {
    const url =
        'https://parse-dashboard.back4app.com/apps/7b0310d2-0186-4b24-bc71-19f5840c2e04/browser/_User';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    // print("total user : $total_user");
    // print('user object id dashboard main : ${user.objectId}');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 2.0,
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 27.0),
                child: Material(
                  color: Colors.red,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: IconButton(
                        icon: new Icon(
                          Icons.power_settings_new,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // sign out
                          signOut();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          child: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: <Widget>[
              _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 70,
                        child: Material(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(180.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.book_rounded,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dmTitle,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0),
                          ),
                          Text(
                            dmSubTitle,
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () => {
                  username == 'superadmin'
                      ? Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Anda tidak bisa mengakses halaman ini'),
                        ))
                      : Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DashboardEntries(
                              username: username,
                            ),
                          ),
                        ),
                  // _onPressed(),
                },
              ),
              // _buildTile(
              //   Padding(
              //     padding: const EdgeInsets.all(24.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: <Widget>[
              //         Material(
              //           color: Colors.teal,
              //           shape: CircleBorder(),
              //           child: Padding(
              //             padding: const EdgeInsets.all(16.0),
              //             child: Icon(Icons.supervised_user_circle,
              //                 color: Colors.white, size: 30.0),
              //           ),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(bottom: 16.0),
              //         ),
              //         Text(
              //           umTitle,
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w700,
              //               fontSize: 24.0),
              //         ),
              //         Text(
              //           umSubTitle,
              //           style: TextStyle(color: Colors.black45),
              //         ),
              //       ],
              //     ),
              //   ),
              //   onTap: () => {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (_) => CreateAccount(
              //           user: user,
              //           username: username,
              //         ),
              //       ),
              //     ),
              //     // _onPressed(),
              //   },
              // ),
              _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          color: Colors.purple,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.person_outline,
                                color: Colors.white, size: 30.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                        ),
                        Text(
                          amTitle,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0),
                        ),
                        Text(
                          amSubTitle,
                          style: TextStyle(color: Colors.black45),
                        ),
                      ]),
                ),
                onTap: () => {
                  username == 'superadmin'
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UserSession(
                              username: username,
                            ),
                          ),
                        )
                      : // ignore: deprecated_member_use
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Anda tidak bisa mengakses halaman ini'),
                        )),
                },
              ),
              _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: Colors.amber,
                        shape: CircleBorder(),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.supervised_user_circle_outlined,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                      ),
                      Text(
                        'List Users',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0),
                      ),
                      Text(
                        'List of all Users',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserList(
                        username: username,
                      ),
                    ),
                  );
                },
              ),
              //
              _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 70,
                        child: Material(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(180.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.supervised_user_circle,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            umTitle,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0),
                          ),
                          Text(
                            umSubTitle,
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CreateAccount(
                        user: user,
                        username: username,
                      ),
                    ),
                  ),
                  // _onPressed(),
                },
              ),
              //
              _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 70,
                        child: Material(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(180.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.bar_chart,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Chart Data',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0),
                          ),
                          Text(
                            'User Score Test Data with Chart',
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChartPage(
                        user: user,
                        username: username,
                      ),
                    ),
                  ),
                  // _onPressed(),
                },
              ),
              // _buildTile(
              //   Padding(
              //     padding: const EdgeInsets.all(24.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: <Widget>[
              //         Material(
              //           color: Colors.amber,
              //           shape: CircleBorder(),
              //           child: Padding(
              //             padding: EdgeInsets.all(16.0),
              //             child: Icon(
              //               Icons.email_rounded,
              //               color: Colors.white,
              //               size: 30.0,
              //             ),
              //           ),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(bottom: 16.0),
              //         ),
              //         Text(
              //           iaTitle,
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w700,
              //               fontSize: 24.0),
              //         ),
              //         Text(
              //           iaSubTitle,
              //           style: TextStyle(color: Colors.black45),
              //         ),
              //       ],
              //     ),
              //   ),
              //   onTap: () {
              //     // email sender
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (_) => MailTo(),
              //       ),
              //     );
              //   },
              // ),
              // _buildTile(
              //   Padding(
              //     padding: const EdgeInsets.all(24.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: <Widget>[
              //                 Text('Score Average',
              //                     style: TextStyle(color: Colors.green)),
              //                 Text('80',
              //                     style: TextStyle(
              //                         color: Colors.black,
              //                         fontWeight: FontWeight.w700,
              //                         fontSize: 34.0)),
              //               ],
              //             ),
              //             DropdownButton(
              //               isDense: true,
              //               value: actualDropdown,
              //               onChanged: (String value) => setState(() {
              //                 actualDropdown = value;
              //                 actualChart = chartDropdownItems
              //                     .indexOf(value); // Refresh the chart
              //               }),
              //               items: chartDropdownItems.map((String title) {
              //                 return DropdownMenuItem(
              //                   value: title,
              //                   child: Text(title,
              //                       style: TextStyle(
              //                           color: Colors.blue,
              //                           fontWeight: FontWeight.w400,
              //                           fontSize: 14.0)),
              //                 );
              //               }).toList(),
              //             )
              //           ],
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(bottom: 4.0),
              //         ),
              //         Sparkline(
              //           data: charts[actualChart],
              //           lineWidth: 5.0,
              //           lineColor: Colors.greenAccent,
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              //
              //

              // _buildTile(
              //   Padding(
              //     padding: const EdgeInsets.all(24.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: <Widget>[
              //         Material(
              //           color: Colors.purple,
              //           borderRadius: BorderRadius.circular(24.0),
              //           child: Center(
              //             child: Padding(
              //               padding: EdgeInsets.all(16.0),
              //               child: Icon(Icons.person_outline,
              //                   color: Colors.white, size: 30.0),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           width: 30,
              //         ),
              //         Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             Text(
              //               amTitle,
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.w700,
              //                 fontSize: 24.0,
              //               ),
              //             ),
              //             Text(
              //               amSubTitle,
              //               style: TextStyle(
              //                 color: Colors.grey,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              //   onTap: () => {
              //     username == 'superadmin'
              //         ? Navigator.of(context).push(
              //             MaterialPageRoute(
              //               builder: (_) => SessionEntries(
              //                 username: username,
              //               ),
              //             ),
              //           )
              //         : // ignore: deprecated_member_use
              //         Scaffold.of(context).showSnackBar(SnackBar(
              //             content: Text('Anda tidak bisa mengakses halaman ini'),
              //           )),
              //   },
              // ),
            ],
            staggeredTiles: [
              StaggeredTile.extent(2, 180.0),
              //
              StaggeredTile.extent(1, 180.0),
              StaggeredTile.extent(1, 180.0),
              //
              StaggeredTile.extent(1, 180.0),
              StaggeredTile.extent(1, 180.0),
              //
              // StaggeredTile.extent(2, 180.0),
              // StaggeredTile.extent(2, 220.0),
              //
              // StaggeredTile.extent(1, 180.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}
