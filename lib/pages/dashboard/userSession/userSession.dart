import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserSession extends StatefulWidget {
  final username;

  const UserSession({
    Key key,
    this.username,
  }) : super(key: key);
  @override
  _UserSessionState createState() => _UserSessionState(
        username,
      );
}

class _UserSessionState extends State<UserSession> {
  final username;

  _UserSessionState(
    this.username,
  );
  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    CollectionReference users =
        FirebaseFirestore.instance.collection('session');
    return Scaffold(
      appBar: AppBar(
        title: Text('Seesion User Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // snapshot has error
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          // connection waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              // timestamp variable
              Timestamp login_time = document.data()['login_time'];
              Timestamp logout_time = document.data()['logout_time'];
              // date time variable
              DateTime loginTime =
                  login_time == null ? null : login_time.toDate();
              DateTime logoutTime =
                  logout_time == null ? null : logout_time.toDate();

              return Card(
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                elevation: 5,
                // color: index % 2 != 0 ? Colors.blue : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 64,
                      bottom: 64,
                      right: 32,
                      left: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Username : ${document.data()['username'] ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Login Time : ${loginTime.toString() ?? ''}',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Logout Time : ${logoutTime.toString() ?? ''}',
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // navigate to user list detail
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => UserListDetail(
                    //       username: _users[index].username.toString(),
                    //       objectid: _users[index].objectId.toString(),
                    //       email: _users[index].email.toString(),
                    //       createdat: _users[index].createdAt,
                    //       updatedat: _users[index].updatedAt,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
