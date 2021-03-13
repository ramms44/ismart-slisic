import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();
// time format
String formattedDate = DateFormat('EEE, dd MM yyy – kk:mm:ss').format(now);

class BottomNavnBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.10,
      color: Colors.blue[700],
      child: Padding(
        padding: const EdgeInsets.only(
          right: 34,
          left: 34,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.white.withOpacity(
                  1.0,
                ),
                fontSize: 12,
              ),
            ),
            Text(
              "Copyright SLISIC - Prakarsa Consulting",
              style: TextStyle(
                color: Colors.white.withOpacity(
                  1.0,
                ),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
