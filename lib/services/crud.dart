import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMethods {
  Future<void> addSession(sessionData) async {
    // ignore: deprecated_member_use
    Firestore.instance.collection('session').add(sessionData);
  }

  Future<void> addDataCompany2(userData) async {
    // ignore: deprecated_member_use
    Firestore.instance.collection('users2').add(userData);
  }

  getData() async {
    // ignore: deprecated_member_use
    return await Firestore.instance.collection('users').snapshots();
  }

  updateData(selectedDoc, newValues) {
    // ignore: deprecated_member_use
    Firestore.instance
        .collection('users')
        // ignore: deprecated_member_use
        .document(selectedDoc)
        // ignore: deprecated_member_use
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    // ignore: deprecated_member_use
    Firestore.instance
        .collection('Users')
        // ignore: deprecated_member_use
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
