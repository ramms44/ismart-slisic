import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'userEntryModel.dart';

class UserEntriesCard extends StatefulWidget {
  final UserEntry userEntry;
  final username;
  // var diaryData;

  UserEntriesCard({
    Key key,
    this.userEntry,
    this.username,
    // this.quiz,
    // this.diaryData,
  }) : super(key: key);
  @override
  _UserEntriesCardState createState() => _UserEntriesCardState(
        userEntry,
        username,
        // diaryData,
      );

  // final Future<List> quiz;
}

class Person {
  String name, gender, email, phoneNumber, tanggalLahir, pendidikan;
  // score1,
  // score2,
  // answerD,
  // answerB;
  // final num age;

  Person(
    this.name,
    this.gender,
    this.email,
    // this.createDate,
    this.phoneNumber,
    this.tanggalLahir,
    this.pendidikan,
    // this.score1,
    // this.score2,
    // this.answerD,
    // this.answerB,
  );
}

var gender,
    email,
    // createDate,
    phoneNumber,
    tanggalLahir,
    pendidikan;
// score1,
// score2,
// answerD,
// answerB;

// var name = new List(11);
// var names;

//
List<String> name = [];

List<Offset> pointList = <Offset>[];

final nameController = TextEditingController();

//
List<Person> people = [
  // for loop this

  Person(
      'test name 1', 'Pria', 'test1@mail.com', '0815455', '1/17/2021', 'SMA'),
  Person(
      'test name 5', 'Pria', 'test1@mail.com', '0815455', '1/17/2021', 'SMA'),
  Person('yudik', 'Pria', 'yudik', '0815455', '1/17/2021', 'S1'),
  Person(
      'test name 3', 'Pria', 'test3@mail.com', '0815455', '1/17/2021', 'SMA'),
  Person(
      'test name 2', 'Pria', 'test2@mail.com', '0815455', '1/17/2021', 'SMA'),
  Person(
      'test name 5', 'Pria', 'test5@mail.com', '0815455', '1/17/2021', 'SMA'),
  Person(
      'user test 4', 'Pria', 'Test4@mail.com', '0815455', '1/17/2021', 'SMA'),
  Person(
      'test name 6', 'Pria', 'test6@mail.com', '0815455', '1/17/2021', 'SMA'),
  Person(
      'test name 6', 'Pria', 'test6@mail.com', '0815455', '1/17/2021', 'SMA'),
  Person(
      'test name 2', 'Pria', 'test2@mail.com', '08154545', '1/17/2021', 'SMA'),
];

// get user data
getUsers() async {
  Stream<QuerySnapshot> userRef =
      Firestore.instance.collection("users").snapshots();
  userRef.forEach((field) {
    field.documents.asMap().forEach((index, data) {
      name.add(field.documents[index]["name"]);
    });
  });
}

//

class _UserEntriesCardState extends State<UserEntriesCard> {
  //
  // var diaryData;
  final username;
  String userCompany;
  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    getUsers();
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

    // for loop testing for people
    // for (var i = 0; i < name.length; i++) {
    //   people[i] = Person(
    //     name[i],
    //     '',
    //     '',
    //     '',
    //     '',
    //     '',
    //   );
    // }
  }

  _launchURL() async {
    String url = userCompany == 'user1'
        ? 'https://docs.google.com/spreadsheets/d/1cUmrKV9BL-EXUFP0PruCm75nQdAGHHS2l5Pj1Ds_prE/edit?usp=sharing'
        : userCompany == 'user2'
            ? 'https://docs.google.com/spreadsheets/d/1KczUA9RRx9wNKey7Fx03azMcnXjNkIF9kzHJteQRNeI/edit?usp=sharing'
            : userCompany == 'user3'
                ? 'https://docs.google.com/spreadsheets/d/1bl1z7dOT5C4s5PqYloGLg4tbkdtmQYIZSp1KB1swpkA/edit?usp=sharing'
                : userCompany == 'user4'
                    ? 'https://docs.google.com/spreadsheets/d/1CI9d9qbPs4dL8Izv6K-t00R7elhDy0MMNjOJaDXURNY/edit?usp=sharing'
                    : 'https://docs.google.com/spreadsheets/d/1EtJpXaevj1PteiGoP4b3S5ALww-BECLuELfNWt7xTTE/edit?usp=sharing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // bool loading = true;
  // List<Widget> listArray = [];

  // _TestListState() {
  //   widget.quiz.then((List value) {
  //     // loop through the json object
  //     for (var i = 0; i < value.length; i++) {
  //       // add the ListTile to an array
  //       listArray.add(new ListTile(title: new Text(value[i].name)));
  //     }

  //     //use setState to refresh UI
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  final UserEntry userEntry;
  //
  bool sortByDate = false;
  bool sortByName = false;

  bool search = false;

  var diaryEntries;
  var diaryData;

  _UserEntriesCardState(
    this.userEntry,
    this.username,
    // this.diaryData,
  );
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'Smart Online',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    //
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 16,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 30, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              RaisedButton(
                                child: Text(
                                  'Sort by Date',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.amber,
                                onPressed: () {
                                  setState(() {
                                    //
                                    sortByDate = !sortByDate;
                                    sortByName = false;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              RaisedButton(
                                child: Text(
                                  'Sort by Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.purple,
                                onPressed: () {
                                  setState(() {
                                    //
                                    sortByName = !sortByName;
                                    sortByDate = false;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              RaisedButton(
                                child: Text(
                                  'See on Google Sheet',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.green,
                                onPressed: () {
                                  // url to google sheet
                                  _launchURL();
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              // Container(
                              //   width: 200,
                              //   height: 100,
                              //   padding: const EdgeInsets.all(20.0),
                              //   child: AutoSearchInput(
                              //       data: name,
                              //       maxElementsToDisplay: 10,
                              //       onItemTap: (int index) {
                              //         //Do something cool
                              //       }),
                              // ),
                              Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.10,
                                    // height: screenHeight * 0.15,
                                    // padding: EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      controller: nameController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Valid Name';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: CommonStyle.textFieldStyle(
                                          labelTextStr: "Searh by name",
                                          hintTextStr: "Enter Name"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  RaisedButton(
                                      child: Text(
                                        'Search',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.blue,
                                      onPressed: () => {
                                            //
                                            setState(() {
                                              search = true;
                                            }),
                                          }
                                      //  showSearch(
                                      //   context: context,
                                      //   delegate: SearchPage<Person>(
                                      //     onQueryUpdate: (s) => print(s),
                                      //     items: people,
                                      //     searchLabel: 'Search people',
                                      //     suggestion: Center(
                                      //       child:
                                      //           Text('Filter people by name, email'),
                                      //     ),
                                      //     failure: Center(
                                      //       child: Text('No person found :('),
                                      //     ),
                                      //     filter: (person) => [
                                      //       person.name,
                                      //       person.email,
                                      //       person.pendidikan,
                                      //       // person.age.toString(),
                                      //     ],
                                      //     builder: (person) => Container(
                                      //       margin: EdgeInsets.all(20),
                                      //       child: Card(
                                      //         child: Padding(
                                      //           padding: const EdgeInsets.all(20.0),
                                      //           child: Container(
                                      //             child: Column(
                                      //               children: <Widget>[
                                      //                 Text(person.name),
                                      //                 Text(person.email),
                                      //                 Text(person.phoneNumber),
                                      //                 Text(person.pendidikan),
                                      //                 Text(person.gender),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     // ListTile(
                                      //     //   title: Text(person.name),
                                      //     //   subtitle: Text(person.email),
                                      //     //   // trailing: Text('${person.age} yo'),
                                      //     // ),
                                      //   ),
                                      // ),
                                      ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //
                          // Data table
                          //
                          new StreamBuilder(
                            stream: sortByDate == true
                                ? FirebaseFirestore.instance
                                    .collection(userCompany == 'user1'
                                        ? 'users_1'
                                        : userCompany == 'user2'
                                            ? 'users_2'
                                            : userCompany == 'user3'
                                                ? 'users_3'
                                                : userCompany == 'user4'
                                                    ? 'users_4'
                                                    : 'users_5')
                                    .orderBy('create_date')
                                    .snapshots()
                                : sortByName == true
                                    ? FirebaseFirestore.instance
                                        .collection(userCompany == 'user1'
                                            ? 'users_1'
                                            : userCompany == 'user2'
                                                ? 'users_2'
                                                : userCompany == 'user3'
                                                    ? 'users_3'
                                                    : userCompany == 'user4'
                                                        ? 'users_4'
                                                        : 'users_5')
                                        .orderBy('name')
                                        .snapshots()
                                    : search ==
                                            true // function search query by name
                                        ? FirebaseFirestore.instance
                                            .collection(userCompany == 'user1'
                                                ? 'users_1'
                                                : userCompany == 'user2'
                                                    ? 'users_2'
                                                    : userCompany == 'user3'
                                                        ? 'users_3'
                                                        : userCompany == 'user4'
                                                            ? 'users_4'
                                                            : 'users_5')
                                            .where(
                                              'name',
                                              isGreaterThanOrEqualTo:
                                                  '${nameController.text}',
                                            ) // query search firestore isGreaterthanOrEqualto
                                            .snapshots()
                                        : FirebaseFirestore.instance
                                            .collection(userCompany == 'user1'
                                                ? 'users_1'
                                                : userCompany == 'user2'
                                                    ? 'users_2'
                                                    : userCompany == 'user3'
                                                        ? 'users_3'
                                                        : userCompany == 'user4'
                                                            ? 'users_4'
                                                            : 'users_5')
                                            .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return new Text('Loading...');
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new DataTable(
                                      columns: <DataColumn>[
                                        new DataColumn(
                                          label: Center(
                                              child: Text('Created Date')),
                                        ),
                                        new DataColumn(
                                          label: Center(child: Text('Name')),
                                        ),
                                        new DataColumn(
                                          label: Center(child: Text('Gender')),
                                        ),
                                        new DataColumn(
                                          label: Center(
                                              child: Text('Email Address')),
                                        ),
                                        new DataColumn(
                                          label: Center(
                                              child: Text('Phone Number')),
                                        ),
                                        new DataColumn(
                                          label: Center(
                                              child: Text('Tanggal Lahir')),
                                        ),
                                        new DataColumn(
                                          label:
                                              Center(child: Text('Pendidikan')),
                                        ),
                                        new DataColumn(
                                          label: Center(
                                              child: Text('Durasi Pengerjaan')),
                                        ),
                                        new DataColumn(
                                          label: Center(child: Text('Score 1')),
                                        ),
                                        new DataColumn(
                                          label: Center(child: Text('Score 2')),
                                        ),
                                        //
                                        for (var i = 0; i < 24; i++)
                                          DataColumn(
                                            label: Text(
                                                'Answers Test D No ${i + 1}'),
                                          ),
                                        //
                                        for (var j = 0; j < 30; j++)
                                          DataColumn(
                                            label: Text(
                                                'Answers Test B No ${j + 1}'),
                                          ),
                                      ],
                                      rows: _createRows(snapshot.data),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Spacer(),
                    // Divider(thickness: 1),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 20,
                    //     horizontal: 40,
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
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

// List createrow
List<DataRow> _createRows(QuerySnapshot snapshot) {
  List<DataRow> newList =
      snapshot.docs.map((DocumentSnapshot documentSnapshot) {
    Timestamp create_date = documentSnapshot.data()['create_date'];
    DateTime date = create_date.toDate();
    String name = documentSnapshot.data()['name'].toString();
    String gender = documentSnapshot.data()['gender'].toString();
    String email = documentSnapshot.data()['email_address'].toString();
    String numberPhone = documentSnapshot.data()['number_phone'].toString();
    String birthDate = documentSnapshot.data()['tanggal_lahir'].toString();
    String pendidikan = documentSnapshot.data()['pendidikan'].toString();
    String durasi = documentSnapshot.data()['duration_test'].toString();
    String scoreTestW = documentSnapshot.data()['score_test_w'].toString();
    String scoreTestN = documentSnapshot.data()['score_test_n'].toString();

    //
    var arrAnswersD = new List(24);
    for (var i = 0; i < 24; i++) {
      arrAnswersD[i] = documentSnapshot.data()['AnswerTestD_no_${i + 1}'][0] !=
              null
          ? documentSnapshot.data()['AnswerTestD_no_${i + 1}'][0].toString()
          : '' +
                      ' , ' +
                      documentSnapshot.data()['AnswerTestD_no_${i + 1}'][1] !=
                  null
              ? documentSnapshot.data()['AnswerTestD_no_${i + 1}'][1].toString()
              : '';
    }

    //
    var arrAnswersB = new List(30);
    for (var j = 0; j < 30; j++) {
      arrAnswersB[j] =
          documentSnapshot.data()['AnswerTestB_no_${j + 1}'].toString();
    }

    return new DataRow(cells: [
      DataCell(Text(date.toString())),
      DataCell(Text(name.toString())),
      DataCell(Text(gender.toString())),
      DataCell(Text(email.toString())),
      DataCell(Text(numberPhone.toString())),
      DataCell(Text(birthDate.toString())),
      DataCell(Text(pendidikan.toString())),
      DataCell(Text(durasi.toString())),
      DataCell(Text(scoreTestW.toString())),
      DataCell(Text(scoreTestN.toString())),
      //
      // DataCell answers d anb b
      for (var i = 0; i < 24; i++) DataCell(Text(arrAnswersD[i].toString())),
      for (var j = 0; j < 30; j++) DataCell(Text(arrAnswersB[j].toString())),
    ]);
  }).toList();
  return newList;
}
