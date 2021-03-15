/// Flutter code sample for DataTable

// This sample shows how to display a [DataTable] with three columns: name, age, and
// role. The columns are defined by three [DataColumn] objects. The table
// contains three rows of data for three example users, the data for which
// is defined by three [DataRow] objects.
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/data_table.png)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'package:http/http.dart' as http;

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List jsonSample;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User ID List',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: jsonSample == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    JsonTable(
                      jsonSample,
                      tableHeaderBuilder: (String header) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 100.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.lightBlue),
                              color: Colors.lightBlue[300]),
                          child: Text(
                            header,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                          ),
                        );
                      },
                      tableCellBuilder: (value) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5,
                                  color: Colors.grey.withOpacity(0.5))),
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(
                                    fontSize: 14.0, color: Colors.grey[900]),
                          ),
                        );
                      },
                      showColumnToggle: true,
                      allowRowHighlight: true,
                      rowHighlightColor: Colors.green[500].withOpacity(0.7),
                      paginationRowCount: 20,
                      onRowSelect: (index, map) {
                        print(index);
                        print(map);

                        /// navigate
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      "User Id List Table, creates table from api json github",
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }

  void _initData() async {
    try {
      String url = "https://ramms44.github.io/users/users_slisic.json";
      final response = await http.get(url);
      print(response.body);
      final userListID = jsonDecode(response.body);
      if (mounted)
        setState(() {
          jsonSample = jsonDecode(response.body) as List;
        });
    } catch (e) {
      print(e);
    }
  }
}
