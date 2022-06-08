import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String title = ""; //クラスが所持している変数
  DateTime? createdAt;

  Todo(DocumentSnapshot doc) {
    title = (doc.data() as Map<String, dynamic>)["title"];
    createdAt = (doc.data() as Map<String, dynamic>)["createdAt"];    
  }

  //これを使うと、TODOに２つの引数を必ず入れなくてはなくなる。
  // Todo(this.title, this.createdAt);//

  // factory Todo.fromFirestore(DocumentSnapshot doc){//TODOのインスタンスを作る
  //   return Todo((doc.data() as Map<String, dynamic>)["title"], (doc.data() as Map<String, dynamic>)["createdAt"]);
  //   }//関数に名前をつけられる

}
