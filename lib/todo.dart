import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String taskName = ""; //クラスが所持している変数
  DateTime? dueDate;
  DateTime? dueTime;
  String id = "";

  //コンストラクタ
  Todo(DocumentSnapshot documentSnapshot) {
    //変数名から型がわかるように（複数、単数を参考に）
    taskName = (documentSnapshot.data() as Map<String, dynamic>)["title"];

    final Timestamp timestamp =
        (documentSnapshot.data() as Map<String, dynamic>)['createdAt'];

    dueDate = timestamp.toDate();
    dueTime = timestamp.toDate();
    id = documentSnapshot.id;
  }
}
