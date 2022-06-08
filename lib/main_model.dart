import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/todo.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];

  Future getToDoList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("todoList").get();
    final docs = snapshot.docs;
    final todoList = docs.map((doc) => Todo(doc)).toList();
    this.todoList = todoList; //thisをやると、上にアクセスできるから
    notifyListeners();
  }
}
