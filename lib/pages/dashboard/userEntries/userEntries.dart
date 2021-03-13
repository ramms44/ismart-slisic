import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgetUserEntries/userCard.dart';
import 'widgetUserEntries/userEntryModel.dart';

class DashboardEntries extends StatefulWidget {
  final username;
  DashboardEntries({
    Key key,
    this.username,
  }) : super(key: key);
  @override
  _DashboardEntriesState createState() => _DashboardEntriesState(
        username,
      );
}

class _DashboardEntriesState extends State<DashboardEntries> {
  final username;
  // Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  _DashboardEntriesState(this.username);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp(
            username: username,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatefulWidget {
  // final String email;
  final username;
  const MyApp({
    Key key,
    this.username,
    // this.email,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(
        username,
      );
}

class _MyAppState extends State<MyApp> {
  final username;
  String userCompany;

  @override
  void initState() {
    super.initState();
    //
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
  }

  _MyAppState(this.username);

  @override
  Widget build(BuildContext context) {
    final diaryCollection =
        FirebaseFirestore.instance.collection(userCompany == 'user1'
            ? 'users_1'
            : userCompany == 'user2'
                ? 'users_2'
                : userCompany == 'user3'
                    ? 'users_3'
                    : userCompany == 'user4'
                        ? 'users_4'
                        : 'users_5');
    final diaryStream = diaryCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserEntry.fromDoc(doc)).toList();
    });
    return StreamProvider<List<UserEntry>>(
      create: (_) => diaryStream,
      child: MaterialApp(
        title: 'User Data Entries',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.purple,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(
                username: username,
                // email: email,
              ),
          // '/new-entry': (context) => UserEntryPage.add(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // UserEntry diaryData;
  final username;
  MyHomePage({
    Key key,
    this.title,
    this.username,
  }) : super(key: key);

  final String title;
  var diaryData;

  // var diaryEntries;

  @override
  _MyHomePageState createState() => _MyHomePageState(
        diaryData,
        username,
      );
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.diaryData, this.username
      // this.diaryEntries,
      );

  var diaryData;
  final username;
  // final UserEntry diaryData;
  var diaryEntries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Entries'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 4 / 5,
            child: UserEntriesCard(
              // userEntry: diaryData,
              username: username,
            ),
            //
          ),
        ),
      ),
    );
  }
}
