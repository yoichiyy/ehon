// import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../task_list/todo.dart';

class EditTaskModel extends ChangeNotifier {
  final Todo todo;
  EditTaskModel(this.todo) {
    dateTimeController.text = todo.taskName;
    dueDateController.text = todo.timestamp!.toDate().month.toString();
  }

  void updateTimestamp(DateTime dateTime) {
    todo.timestamp = Timestamp.fromDate(dateTime);
    notifyListeners();
  }

  final dateTimeController = TextEditingController();
  final dueDateController = TextEditingController();

  String? taskName;
  String? timestamp;

  void setTaskName(String taskName) {
    this.taskName = taskName;
    notifyListeners();
  }

  void setDueDate(String dueDate) {
    this.timestamp = dueDate;
    notifyListeners();
  }

  bool isUpdated() {
    return taskName != null || timestamp != null;
  }

  Future update() async {
    taskName = dateTimeController.text;

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
