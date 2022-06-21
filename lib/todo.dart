import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String taskName = ""; //クラスが所持している変数
  DateTime? dueDate;
  DateTime? dueTime;

  //コンストラクタ
  Todo(DocumentSnapshot doc) {
    taskName = (doc.data() as Map<String, dynamic>)["title"];

    final Timestamp timestamp =
        (doc.data() as Map<String, dynamic>)['createdAt'];
    dueDate = timestamp.toDate();
    dueTime = timestamp.toDate();
    
  }
}
