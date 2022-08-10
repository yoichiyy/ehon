import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'todo.dart';

class MainModel extends ChangeNotifier {
  List<TodoForView> todos = []; //日本語訳？：「リストです。Todoクラスで定義した３つの変数を使います。」

  void getTodoListRealtime() {
    final querySnapshots =
        FirebaseFirestore.instance.collection('todoList').snapshots();

    //↑は、collectionをまるっと。↓は、データ４つ、かな？
    //F質問：querySnapshotsはコレクション全体で、下のqueryDocumentSnapshotsも、docs、と書いてあるので、同じくデータ４つのように見える。
    querySnapshots.listen((querySnapshot) {
      //future型の"いとこ"→stream型。listenで、
      final queryDocumentSnapshots = querySnapshot.docs; //コレクション内のドキュメント全部

      //Todoクラスのコンストラクタに、idも追加した。これでTodo(doc)をリスト変換したtodoListには、idという変数もできました。
      final todoList =
          queryDocumentSnapshots.map((doc) => TodoForView(doc)).toList();

      //並べ替えて、最後にリストをtodoListというリストの箱に詰め替えてる
      todoList.sort((a, b) => b.dueDate.compareTo(a.dueDate));
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
