class ExamModel {
  int id;
  String menu_name;
  String file_name;
  String progress_pic_name;
  //String trailing_pic_name;
  int dateCreated;
  int isNew;
  int exam_type;
  int field_2;
  String position;
  String open_last;
  String field_5;

  ExamModel({
    required this.id,
    required this.menu_name,
    required this.file_name,
    required this.progress_pic_name,
    //  this.trailing_pic_name,
    required this.dateCreated,
    required this.isNew,
    required this.exam_type,
    required this.field_2,
    required this.position,
    required this.open_last,
    required this.field_5,
  });

  fromMap(Map map) {
    ExamModel progress = new ExamModel(
        id: id,
        menu_name: menu_name,
        file_name: file_name,
        progress_pic_name: progress_pic_name,
        dateCreated: dateCreated,
        isNew: isNew,
        exam_type: exam_type,
        field_2: field_2,
        position: position,
        open_last: open_last,
        field_5: field_5);
    progress.id = map["id"];
    progress.menu_name = map["menu_name"];
    progress.file_name = map["file_name"];
    progress.progress_pic_name = map["progress_pic_name"];
    //  progress.trailing_pic_name = map["trailing_pic_name"];
    progress.dateCreated = map["dateCreated"];
    progress.isNew = map["isNew"];
    progress.exam_type = map["exam_type"];
    progress.field_2 = map["field_2"];
    progress.position = map["position"];
    progress.open_last = map["open_last"];
    progress.field_5 = map["field_5"];
    return progress;
  }

  @override
  // toString() => 'ddd: $progress_pic_name';
// @override
  String toString() {
    return '$id, $menu_name,$file_name, $progress_pic_name, $dateCreated, $isNew, $exam_type, $field_2, $position, $open_last, $field_5';
    // return '$id, $menu_name,$file_name, $progress_pic_name, $trailing_pic_name, $dateCreated, $isNew, $exam_type, $field_2, $position, $open_last, $field_5';
  }
}
//
// // Convert a Dog into a Map. The keys must correspond to the names of the
// // columns in the database.
// Map<String, dynamic> toMap() {
//   return {
//     'id': id,
//     'fileName': file_name,
//     'progressPicName': progress_pic_name,
//     'dateCreated': date_created,
//     'isNew' : is_new,
//     'exam_type' : exam_type,
//     'field_2' : field_2,
//     'position' : position,
//     'open_last' : open_last,
//     'field_5' : field_5,
//   };
// }
//
// // Implement toString to make it easier to see information about
// // each dog when using the print statement.
// @override
// String toString() {
//   return 'Dog{id: $id, name: $name, age: $age}';
// }
// }
