import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntry {
  final String name;
  final String email;
  final String nohp;
  final String gender;
  final String pendidikan;
  final String tanggal_lahir;
  final String score1;
  final String score2;
  final String score3;
  final String score4;
  // final Timestamp create;
  final String id;

  UserEntry({
    this.name,
    this.email,
    this.nohp,
    this.gender,
    this.pendidikan,
    this.tanggal_lahir,
    this.score1,
    this.score2,
    this.score3,
    this.score4,
    // this.create,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'emoji': emoji,
      // 'title': title,
      // 'body': body,
      'name': name,
      'email_address': email,
      'number_phone': nohp,
      'gender': gender,
      'pendidikan': pendidikan,
      'tanggal_lahir': tanggal_lahir,
      'score1': score1,
      'score2': score2,
      'score3': score3,
      'score4': score4,
      // 'create_date': create,
    };
  }

  factory UserEntry.fromDoc(QueryDocumentSnapshot doc) {
    return UserEntry(
      name: doc.data()['name'],
      email: doc.data()['email_address'],
      nohp: doc.data()['number_phone'],
      gender: doc.data()['gender'],
      pendidikan: doc.data()['pendidikan'],
      tanggal_lahir: doc.data()['tanggal_lahir'],
      score1: doc.data()['score1'],
      score2: doc.data()['score2'],
      score3: doc.data()['answer_test_d'],
      score4: doc.data()['answer_test_b'],
      // create: doc.data()['create_date'],
      id: doc.id,
    );
  }
}
