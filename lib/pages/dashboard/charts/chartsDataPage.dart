import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  final user;
  final username;
  const ChartPage({
    Key key,
    this.user,
    this.username,
  }) : super(key: key);
  @override
  _ChartPageState createState() => _ChartPageState(user, username);
}

class _ChartPageState extends State<ChartPage> {
  final user;
  final username;

  _ChartPageState(this.user, this.username);
  //
  @override
  Widget build(BuildContext context) {
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
              Container(
                margin: const EdgeInsets.only(right: 27.0),
                child: Material(
                  color: Colors.green,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: IconButton(
                        icon: new Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // sign out
                          // signOut();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Chart Page',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          //
          child: Center(
            child: Text('Chart Page Body'),
          ),
        ),
      ),
    );
  }
}
