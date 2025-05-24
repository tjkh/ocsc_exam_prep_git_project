class Exam {
  String _qNum,
      _question,
      _choice_A,
      _choice_B,
      _choice_C,
      _choice_D,
      _choice_E,
      _explanation,
      _isExplain;
  int _correctAns;

  Exam(
      this._qNum,
      this._question,
      this._choice_A,
      this._choice_B,
      this._choice_C,
      this._choice_D,
      this._choice_E,
      this._explanation,
      this._isExplain,
      this._correctAns);

  // factory Exam.fromJSON(Map<String, dynamic> json) {
  //   if (json == null) {
  //     return null;
  //   } else {
  //     return Exam(
  //         json["qNum"], json["question"], json["choiceA"], json["correctAns"]);
  //   }
  // }

  get qNum => this._qNum;
  get question => this._question;
  get choice_A => this._choice_A;
  get choice_B => this._choice_B;
  get choice_C => this._choice_C;
  get choice_D => this._choice_D;
  get choice_E => this._choice_E;
  get exPlanation => this._explanation;
  get isExplain => this._isExplain;
  get correctAns => this._correctAns;
}

//
// Contact.fromMap(Map<String, dynamic> map) {
// id = map[colId];
// name = map[colName];
// mobile = map[colMobile];
// }
//
// Map<String, dynamic> toMap() {
//   var map = <String, dynamic>{colName: name, colMobile: mobile};
//   if (id != null) {
//     map[colId] = id;
//   }
//   return map;
// }
// }
