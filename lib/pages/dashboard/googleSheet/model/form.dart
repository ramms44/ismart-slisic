/// FeedbackForm is a data class which stores data fields of Feedback.
class FeedbackForm {
  String username;
  String name;
  String email;
  String number_phone;
  String gender;
  String pendidikan;
  String tanggal_lahir;
  String score1;
  String score2;
  //
  // loop testing
  // var answersD;
  // note belum bisa pakai looping
  // answers D
  var answersD1_1;
  var answersD1_2;
  //
  var answersD2_1;
  var answersD2_2;
  //
  var answersD3_1;
  var answersD3_2;
  //
  var answersD4_1;
  var answersD4_2;
  //
  var answersD5_1;
  var answersD5_2;
  //
  var answersD6_1;
  var answersD6_2;
  //
  var answersD7_1;
  var answersD7_2;
  //
  var answersD8_1;
  var answersD8_2;
  //
  var answersD9_1;
  var answersD9_2;
  //
  var answersD10_1;
  var answersD10_2;
  //
  var answersD11_1;
  var answersD11_2;
  //
  var answersD12_1;
  var answersD12_2;
  //
  var answersD13_1;
  var answersD13_2;
  //
  var answersD14_1;
  var answersD14_2;
  //
  var answersD15_1;
  var answersD15_2;
  //
  var answersD16_1;
  var answersD16_2;
  //
  var answersD17_1;
  var answersD17_2;
  //
  var answersD18_1;
  var answersD18_2;
  //
  var answersD19_1;
  var answersD19_2;
  //
  var answersD20_1;
  var answersD20_2;
  //
  var answersD21_1;
  var answersD21_2;
  //
  var answersD22_1;
  var answersD22_2;
  //
  var answersD23_1;
  var answersD23_2;
  //
  var answersD24_1;
  var answersD24_2;
  //
  // loop testing B
  // var answersB;
  // note belum bisa pakai looping
  // answers B
  var answersB1;
  var answersB2;
  var answersB3;
  var answersB4;
  var answersB5;
  var answersB6;
  var answersB7;
  var answersB8;
  var answersB9;
  var answersB10;
  var answersB11;
  var answersB12;
  var answersB13;
  var answersB14;
  var answersB15;
  var answersB16;
  var answersB17;
  var answersB18;
  var answersB19;
  var answersB20;
  var answersB21;
  var answersB22;
  var answersB23;
  var answersB24;
  var answersB25;
  var answersB26;
  var answersB27;
  var answersB28;
  var answersB29;
  var answersB30;
  FeedbackForm(
    this.username,
    this.name,
    this.email,
    this.number_phone,
    this.gender,
    this.pendidikan,
    this.tanggal_lahir,
    this.score1,
    this.score2,
    // this.answersD,
    // note belum bisa pakai looping
    // answers D
    this.answersD1_1,
    this.answersD1_2,
    this.answersD2_1,
    this.answersD2_2,
    this.answersD3_1,
    this.answersD3_2,
    this.answersD4_1,
    this.answersD4_2,
    this.answersD5_1,
    this.answersD5_2,
    this.answersD6_1,
    this.answersD6_2,
    this.answersD7_1,
    this.answersD7_2,
    this.answersD8_1,
    this.answersD8_2,
    this.answersD9_1,
    this.answersD9_2,
    this.answersD10_1,
    this.answersD10_2,
    this.answersD11_1,
    this.answersD11_2,
    this.answersD12_1,
    this.answersD12_2,
    this.answersD13_1,
    this.answersD13_2,
    this.answersD14_1,
    this.answersD14_2,
    this.answersD15_1,
    this.answersD15_2,
    this.answersD16_1,
    this.answersD16_2,
    this.answersD17_1,
    this.answersD17_2,
    this.answersD18_1,
    this.answersD18_2,
    this.answersD19_1,
    this.answersD19_2,
    this.answersD20_1,
    this.answersD20_2,
    this.answersD21_1,
    this.answersD21_2,
    this.answersD22_1,
    this.answersD22_2,
    this.answersD23_1,
    this.answersD23_2,
    this.answersD24_1,
    this.answersD24_2,
    //
    // this.answersB,
    // note belum bisa pakai looping
    // answers B
    this.answersB1,
    this.answersB2,
    this.answersB3,
    this.answersB4,
    this.answersB5,
    this.answersB6,
    this.answersB7,
    this.answersB8,
    this.answersB9,
    this.answersB10,
    this.answersB11,
    this.answersB12,
    this.answersB13,
    this.answersB14,
    this.answersB15,
    this.answersB16,
    this.answersB17,
    this.answersB18,
    this.answersB19,
    this.answersB20,
    this.answersB21,
    this.answersB22,
    this.answersB23,
    this.answersB24,
    this.answersB25,
    this.answersB26,
    this.answersB27,
    this.answersB28,
    this.answersB29,
    this.answersB30,
  );

  // Method to make GET parameters.
  Map toJson() => {
        'username': username,
        'name': name,
        'email': email,
        'number_phone': number_phone,
        'gender': gender,
        'pendidikan': pendidikan,
        'tanggal_lahir': tanggal_lahir,
        'score1': score1,
        'score2': score2,
        //
        // for (var i = 0; i < 24; i++) 'answer_d${i}': answersD[i],
        // for (var j = 0; j < 30; j++) 'answer_b${j}': answersB[j],
        // note belum bisa pakai looping
        // answers D
        'answer_d1_1': answersD1_1,
        'answer_d1_2': answersD1_2,
        'answer_d2_1': answersD2_1,
        'answer_d2_2': answersD2_2,
        'answer_d3_1': answersD3_1,
        'answer_d3_2': answersD3_2,
        'answer_d4_1': answersD4_1,
        'answer_d4_2': answersD4_2,
        'answer_d5_1': answersD5_1,
        'answer_d5_2': answersD5_2,
        'answer_d6_1': answersD6_1,
        'answer_d6_2': answersD6_2,
        'answer_d7_1': answersD7_1,
        'answer_d7_2': answersD7_2,
        'answer_d8_1': answersD8_1,
        'answer_d8_2': answersD8_2,
        'answer_d9_1': answersD9_1,
        'answer_d9_2': answersD9_2,
        'answer_d10_1': answersD10_1,
        'answer_d10_2': answersD10_2,
        'answer_d11_1': answersD11_1,
        'answer_d11_2': answersD11_2,
        'answer_d12_1': answersD12_1,
        'answer_d12_2': answersD12_2,
        'answer_d13_1': answersD13_1,
        'answer_d13_2': answersD13_2,
        'answer_d14_1': answersD14_1,
        'answer_d14_2': answersD14_2,
        'answer_d15_1': answersD15_1,
        'answer_d15_2': answersD15_2,
        'answer_d16_1': answersD16_1,
        'answer_d16_2': answersD16_2,
        'answer_d17_1': answersD17_1,
        'answer_d17_2': answersD17_2,
        'answer_d18_1': answersD18_1,
        'answer_d18_2': answersD18_2,
        'answer_d19_1': answersD19_1,
        'answer_d19_2': answersD19_2,
        'answer_d20_1': answersD20_1,
        'answer_d20_2': answersD20_2,
        'answer_d21_1': answersD21_1,
        'answer_d21_2': answersD21_2,
        'answer_d22_1': answersD22_1,
        'answer_d22_2': answersD22_2,
        'answer_d23_1': answersD23_1,
        'answer_d23_2': answersD23_2,
        'answer_d24_1': answersD24_1,
        'answer_d24_2': answersD24_2,
        // //
        // // note belum bisa pakai looping
        // // answers B
        'answer_b1': answersB1,
        'answer_b2': answersB2,
        'answer_b3': answersB3,
        'answer_b4': answersB4,
        'answer_b5': answersB5,
        'answer_b6': answersB6,
        'answer_b7': answersB7,
        'answer_b8': answersB8,
        'answer_b9': answersB9,
        'answer_b10': answersB10,
        'answer_b11': answersB11,
        'answer_b12': answersB12,
        'answer_b13': answersB13,
        'answer_b14': answersB14,
        'answer_b15': answersB15,
        'answer_b16': answersB16,
        'answer_b17': answersB17,
        'answer_b18': answersB18,
        'answer_b19': answersB19,
        'answer_b20': answersB20,
        'answer_b21': answersB21,
        'answer_b22': answersB22,
        'answer_b23': answersB23,
        'answer_b24': answersB24,
        'answer_b25': answersB25,
        'answer_b26': answersB26,
        'answer_b27': answersB27,
        'answer_b28': answersB28,
        'answer_b29': answersB29,
        'answer_b30': answersB30,
      };
}
