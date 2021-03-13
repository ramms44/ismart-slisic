import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'model/user_model.dart';

class UserListDetail extends StatefulWidget {
  UserListDetail({
    Key key,
    this.username,
    this.objectid,
    this.email,
    this.createdat,
    this.updatedat,
  }) : super(key: key);
  //
  String username;
  String objectid;
  String email;
  DateTime createdat;
  DateTime updatedat;
  //
  @override
  _UserListDetailState createState() => _UserListDetailState(
        username,
        objectid,
        email,
        createdat,
        updatedat,
      );
}

class _UserListDetailState extends State<UserListDetail> {
  String username;
  String objectid;
  String email;
  DateTime createdat;
  DateTime updatedat;

  _UserListDetailState(
    this.username,
    this.objectid,
    this.email,
    this.createdat,
    this.updatedat,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    // print('username: $username');
    return Scaffold(
      appBar: AppBar(
        title: Text('User Id Detail'),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          // child: Center(
          child: Card(
            color: Colors.blue,
            semanticContainer: true,
            elevation: 5,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 32,
                bottom: 32,
                right: 16,
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'User Id : $username',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.yellow),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Object Id : $objectid',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Email : ${email}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Created at : $createdat',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Updated at : $updatedat',
                    style: TextStyle(
                      color: Colors.white,
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
