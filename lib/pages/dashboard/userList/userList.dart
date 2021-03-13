import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'userListDetail.dart';
import 'request/userRequest.dart';
import 'model/userModel.dart';

class UserList extends StatefulWidget {
  final String username;

  UserList({
    Key key,
    this.username,
  }) : super(key: key);
  @override
  _UserListState createState() => _UserListState(
        username,
      );
}

class _UserListState extends State<UserList> {
  //

  final String username;

  _UserListState(this.username);
  //
  @override
  void initState() {
    username == 'admin_company_a' || username == 'admin_company_b'
        ? fetchUsers().then((value) {
            setState(() {
              _users.addAll(value);
            });
          })
        : fetchAdmin().then((value) {
            setState(() {
              _users.addAll(value);
            });
          });
    super.initState();
  }

  // ignore: deprecated_member_use
  List<User> _users = List<User>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    print(_users.length);
    // print('username: ${_users[0].username}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          username == 'admin_company_a' || username == 'admin_company_b'
              ? 'User ID User Test'
              : 'User ID Admin',
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 25,
              right: 25,
            ),
            elevation: 5,
            color: index % 2 != 0 ? Colors.blue : Colors.white,
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
                      'User Id : ${_users[index].username}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: index % 2 != 0 ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Object Id : ${_users[index].objectId}',
                      style: TextStyle(
                        color: index % 2 != 0 ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                // navigate to user list detail
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UserListDetail(
                      username: _users[index].username.toString(),
                      objectid: _users[index].objectId.toString(),
                      email: _users[index].email.toString(),
                      createdat: _users[index].createdAt,
                      updatedat: _users[index].updatedAt,
                    ),
                  ),
                );
              },
            ),
          );
        },
        itemCount: _users.length,
      ),
    );
  }
}
