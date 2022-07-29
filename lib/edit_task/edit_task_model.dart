// import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../todo.dart';

class EditTaskModel extends ChangeNotifier {
  final Todo todo;
  EditTaskModel(this.todo) {
    titleController.text = todo.taskName;
    authorController.text = todo.timestamp;
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  String? taskName;
  String? timestamp;

  void setTaskName(String taskName) {
    this.taskName = taskName;
    notifyListeners();
  }

  void setDueDate(String dueDate) {
    this.timestamp = timestamp;
    notifyListeners();
  }

  bool isUpdated() {
    return taskName != null || timestamp != null;
  }

  Future update() async {
    taskName = titleController.text;
    timestamp = authorController.text;

    // firestoreに追加
    await FirebaseFirestore.instance
        .collection('todoList')
        .doc(todo.id)
        .update({
      'title': taskName,
      'createdAt': timestamp,
    });
  }
}
