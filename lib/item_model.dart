class ItemModel {
  int?
      id; // เนื่่องจากปรับเป็น null-safety แล้ว เครื่องหมาย ? บอกว่า เป็น nullable แทนการใช้ required
  // ตรงนี้ ใช้  required มีปัญหาตรง ItemModel itemModel = new ItemModel();
  String? file_name;
  String? item_id;
  String? item_date;
  String? isClicked;
  String? isNew;

  ItemModel(
      {this.id,
      this.file_name,
      this.item_id,
      this.item_date,
      this.isClicked,
      this.isNew});

  static fromMap(Map map) {
    ItemModel itemModel = new ItemModel();
    itemModel.id = map["id"];
    itemModel.file_name = map["file_name"];
    itemModel.item_id = map["item_id"];
    itemModel.item_date = map["item_date"];
    itemModel.isClicked = map["isClicked"];
    itemModel.isNew = map["isNew"];
    return itemModel;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "file_name": file_name,
        "item_id": item_id,
        "item_date": item_date,
        "isClicked": isClicked,
        "isNew": isNew
      };

  @override
  // toString() => 'ddd: $item_id';
// @override
  String toString() {
    return '$id, $file_name, $item_id, $item_date, $isClicked, $isNew';
  }
}
