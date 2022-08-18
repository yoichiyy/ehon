import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String taskNameOfTodoClass = ""; //クラスが所持している変数
  String dueDate = "";
  String dueTime = "";
  String id = "";
  // Timestamp? createdAtForRead;
  DateTime? createdAt;
  //https://flutter.ctrnost.com/basic/interactive/form/datapicker/

  //コンストラクタ
  Todo(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    //キャスト。解釈するため。前半：fireのdoc.
    //変数名から型がわかるように（複数、単数を参考に）

    //lint：静的解析をどのくらい強くするか
    taskNameOfTodoClass = data["title"] as String;

//F質問：このtimestampそのものを、編集することはできないのか？もしだめなら、
//1.timestampでなくて、年月日時でfirebase側も管理する。タスク登録時点で、この４つを送信する。
//2.edit画面のコントローラーを工夫？して、timestampを表示/編集できるcontrollerにする。
    // createdAtForRead = data['createdAt'] as Timestamp?;
    createdAt =
        (data['createdAt'] as Timestamp?)?.toDate(); //null aware operator
    id = documentSnapshot.id;
  }
}
