import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/todo.dart';


class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];

  void getTodoListRealtime() {
    final snapshots =
        FirebaseFirestore.instance.collection('todoList').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;

      final todoList = docs.map((doc) => Todo(doc)).toList();
      //null check のエラーで、ビックリマークつけて解決したが、まだ理解はしていない
      todoList.sort((a, b) => b.dueDate!.compareTo(a.dueDate!));
      
      //ここで、this.と出てくる理由？　何をしている？　これはコンストラクタ？
      this.todoList = todoList; //ここを日本語訳するとしたら、どうなる？

      notifyListeners();
    });
  } 
}



class AddBookModel extends ChangeNotifier {
  String? taskName;
  String? dueDate;

  Future addBook() async {
    if (taskName == null || taskName == "") {
      throw 'タイトルが入力されていません';
    }

    if (dueDate == null || dueDate!.isEmpty) {
      throw '著者が入力されていません';
    }

    // firestoreに追加
    await FirebaseFirestore.instance.collection('books').add({
      'title': taskName,
      'author': dueDate,
    });
  }
}