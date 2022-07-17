import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/todo.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todos = []; //日本語訳？：「リストです。Todoクラスで定義した３つの変数を使います。」

  void getTodoListRealtime() {
    final querySnapshots =
        FirebaseFirestore.instance.collection('todoList').snapshots(); 

    //snapshots snapshot それぞれfirebaesのデータのどこを指している？

    querySnapshots.listen((querySnapshot) {
      //future型の延長→stream型　：　いとこ
      //データ4つここで認識

      final queryDocumentSnapshots = querySnapshot.docs; //コレクション内のドキュメント全部

      // final String id = queryDocumentSnapshots.id; //id取得したい。。。

      //docsは４つある。一つ一つのdocを、"Todoクラスに入れて”、
      //"4つの変数を作って"、再びリストに戻した。
      //Todoクラスのコンストラクタには、idがないから、ここで作ってあげれば、idも変数として使えるようになる
      final todoList = queryDocumentSnapshots.map((doc) => Todo(doc)).toList();

      //todo.dart内でidを定義しようとするが、[title]とはまた違う場所にあるので、方法わからず。。。

      //並べ替えて、最後にリストをtodoListというリストの箱に詰め替えてる
      todoList.sort((a, b) => b.dueDate!.compareTo(a.dueDate!));
      todos = todoList;

      notifyListeners();
    });
  }
}

class AddBookModel extends ChangeNotifier {
  String? taskName;
  String? dueDate;

  Future addBook() async {
    if (taskName == null || taskName == "") {
      throw 'タスク名が入力されていません';
    }
    // firestoreに追加
    await FirebaseFirestore.instance.collection('books').add({
      'title': taskName,
      'author': dueDate,
    });
  }
}
