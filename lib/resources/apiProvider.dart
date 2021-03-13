import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web_psychotest/pages/quiz/models/category.dart';
import 'package:flutter_web_psychotest/pages/quiz/models/question.dart';

// const String baseUrl = "https://opentdb.com/api.php";

//
Future<List<Question>> getQuestionsW(
  Category category,
  int total,
  String difficulty,
) async {
  String url = "https://ramms44.github.io/quizw.json";
  if (difficulty != null) {
    url = "https://ramms44.github.io/quizw.json";
    print('fetch quiz w');
  }
  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return Question.fromData(questions);
}

//
Future<List<Question>> getQuestionsN(
  Category category,
  int total,
  String difficulty,
) async {
  String url = "https://ramms44.github.io/quizn.json";
  if (difficulty != null) {
    url = "https://ramms44.github.io/quizn.json";
    print('fetch quiz n');
  }
  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return Question.fromData(questions);
}

//
Future<List<Question>> getQuestionsD(
  Category category,
  int total,
  String difficulty,
) async {
  String url = "https://ramms44.github.io/quizd.json";
  if (difficulty != null) {
    url = "https://ramms44.github.io/quizd.json";
  }
  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return Question.fromData(questions);
}

//
Future<List<Question>> getQuestionsB(
  Category category,
  int total,
  String difficulty,
) async {
  String url = "https://ramms44.github.io/quizb.json";
  if (difficulty != null) {
    url = "https://ramms44.github.io/quizb.json";
  }
  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return Question.fromData(questions);
}
