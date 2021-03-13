import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = 80.0;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(
                    'assets/images/Smart-white.png',
                  ),
                  width: 200,
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white,
            blurRadius: 15.0,
            offset: Offset(
              0.0,
              0.75,
            ),
          ),
        ],
        color: Colors.blue,
      ),
    );
  }
}

class MyAppbarBio extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = 80.0;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(
                  image: AssetImage(
                    'assets/images/Smart-white.png',
                  ),
                  width: 200,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                ),
                Text(
                  "DATA PESERTA",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white,
            blurRadius: 15.0,
            offset: Offset(
              0.0,
              0.75,
            ),
          ),
        ],
        color: Colors.blue,
      ),
    );
  }
}
