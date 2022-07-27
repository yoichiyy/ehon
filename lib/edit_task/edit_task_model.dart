// import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../todo.dart';

class EditTaskModel extends ChangeNotifier {
  final Todo todo;
  EditTaskModel(this.todo) {
    titleController.text = todo.taskName;
    authorController.text = '${todo.dueDate} ${todo.dueTime}';
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  String? taskName;
  String? dueDate;

  void setTaskName(String taskName) {
    this.taskName = taskName;
    notifyListeners();
  }

  void setDueDate(String dueDate) {
    this.dueDate = dueDate;
    notifyListeners();
  }

  bool isUpdated() {
    return taskName != null || dueDate != null;
  }

  Future update() async {
    taskName = titleController.text;
    dueDate = authorController.text;

    // firestoreに追加
    await FirebaseFirestore.instance
        .collection('todoList')
        .doc(todo.id)
        .update({
      'title': taskName,
      'createdAt': dueDate,
    });
  }
}
