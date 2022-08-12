import 'package:cloud_firestore/cloud_firestore.dart';

class TodoForView {
  String taskName = ""; //クラスが所持している変数
  String dueDate = "";
  String dueTime = "";
  String id = "";
  Timestamp? createdAtForRead;
  //https://flutter.ctrnost.com/basic/interactive/form/datapicker/

  //コンストラクタ
  TodoForView(DocumentSnapshot documentSnapshot) {
    //変数名から型がわかるように（複数、単数を参考に）
    taskName = (documentSnapshot.data() as Map<String, dynamic>)["title"];

//F質問：このtimestampそのものを、編集することはできないのか？もしだめなら、
//1.timestampでなくて、年月日時でfirebase側も管理する。タスク登録時点で、この４つを送信する。
//2.edit画面のコントローラーを工夫？して、timestampを表示/編集できるcontrollerにする。
    createdAtForRead =
        (documentSnapshot.data() as Map<String, dynamic>)['createdAt'];
    id = documentSnapshot.id;
  }
}
